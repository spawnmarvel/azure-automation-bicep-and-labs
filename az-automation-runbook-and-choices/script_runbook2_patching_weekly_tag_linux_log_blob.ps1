# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "YOUR-CLIENT-ID" 
$TenantId       = "YOUR-TENANT-ID" 
$SubscriptionId = "YOUR-SUB-ID" 

##### script to copy

$OverallStart = Get-Date
Write-Output "--- JOB STARTED: $($OverallStart.ToString('yyyy-MM-dd HH:mm:ss')) ---"

# =================================================================================
# 2. AUTHENTICATION
# =================================================================================
Write-Output "Connecting to Azure via Managed Identity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId | Out-Null

# =================================================================================
# 3. GLOBAL DISCOVERY (Scanning Entire Subscription via Tags)
# =================================================================================
Write-Output "Scanning all Resource Groups for VMs with tag 'Patching: Weekly'..."

# Get-AzVM without -ResourceGroupName pulls every VM in the subscription
$allVMs = Get-AzVM 
$targetVMs = $allVMs | Where-Object { $_.Tags['Patching'] -eq 'Weekly' }

if ($null -eq $targetVMs -or $targetVMs.Count -eq 0) {
    Write-Warning "No VMs found with tag 'Patching: Weekly'. Execution aborted."
    return
}

Write-Output "SUCCESS: Found $($targetVMs.Count) tagged VMs across the subscription."

# =================================================================================
# 4. POWER STATE VERIFICATION & START (Parallel)
# =================================================================================
$vmsToUpdate = @()

foreach ($vm in $targetVMs) {
    # Get real-time status (requires the -Status flag)
    $statusInfo = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    $displayStatus = ($statusInfo.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    
    # SAFETY CHECK: Only start if Deallocated (Someone might be working if it's Running)
    if ($displayStatus -eq "VM deallocated") {
        Write-Output "Starting $($vm.Name) in RG: $($vm.ResourceGroupName) [Current: $displayStatus]..."
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -NoWait
        $vmsToUpdate += $vm
    } else {
        Write-Warning "SKIPPING $($vm.Name): Status is '$displayStatus'. Will not interrupt active session."
    }
}

if ($vmsToUpdate.Count -eq 0) {
    Write-Output "No deallocated VMs found for patching. Execution finished."
    return
}

Write-Output "Waiting 90 seconds for Linux Agents to become Ready..."
Start-Sleep -Seconds 90

# =================================================================================
# 5. MAINTENANCE EXECUTION (BASH)
# =================================================================================
# Using single-quote here-string to ensure Bash variables are passed correctly
$BashScript = @'
# 1. Setup Naming and Timing
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"
START_TIME=$SECONDS

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE

# 2. Run Updates (Logging everything to the file)
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1

# 3. Calculate Duration
DURATION=$((SECONDS - START_TIME))
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE
echo "--- Total Time: $((DURATION / 60))m $((DURATION % 60))s ---" >> $LOG_FILE

# 4. Housekeeping: Delete logs older than 30 days
# This keeps the /var/log/ directory from getting cluttered
sudo find /var/log/ -name "apt-maintenance-*.log" -mtime +30 -delete

# 5. Output the FULL log for PowerShell to capture and upload to Storage
cat $LOG_FILE
'@

foreach ($vm in $vmsToUpdate) {
    Write-Output "Executing updates on $($vm.Name)..."
    try {
        $result = Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
                                        -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
        
        Write-Output "[$($vm.Name)] Bash Output: $($result.Value[0].Message)"
    }
    catch {
        Write-Error "FAILURE: Maintenance command failed on $($vm.Name). Error: $($_.Exception.Message)"
    }

    # =================================================================================
    # 6. SHUTDOWN & DEALLOCATE
    # =================================================================================
    Write-Output "Deallocating $($vm.Name) to save costs..."
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
}

$OverallEnd = Get-Date
Write-Output "--- JOB FINISHED: $($OverallEnd.ToString('yyyy-MM-dd HH:mm:ss')) ---"
$Duration = $OverallEnd - $OverallStart
$TimeUsed = "{0:mm} minutes and {0:ss} seconds" -f $Duration

Write-Output "Global Weekly Maintenance Sequence Complete."

# =================================================================================
# 7. FINAL SUMMARY
# =================================================================================
Write-Output "----------------------------------------------"
Write-Output "FINAL MAINTENANCE SUMMARY"
Write-Output "Total VMs Found: $($targetVMs.Count)"
Write-Output "Total VMs Processed: $($vmsToUpdate.Count)"
Write-Output "--- TOTAL TIME USED: $TimeUsed ---"
Write-Output "----------------------------------------------"
Write-Output "Global Weekly Maintenance Sequence Complete."

# =================================================================================
# 8. Copy logs to storage account for easy access
# =================================================================================
# 1. Configuration
$StorageAccountName = "yourstorageaccountname"
$ContainerName = "vm-logs-linux-updates"
$BlobName = "$VMName" + "_" + (Get-Date -Format "yyyy-MM-dd_HHmm") + ".log"

# 2. Authenticate the Context using the Managed Identity (Crucial!)
# This tells PowerShell: "Don't look for a password, use my Azure Identity"
$Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

# 3. Process the Log Text
# We take the output from the 'Invoke-AzVMRunCommand' variable
$LogContent = $RunCommandResult.Value[0].Message 

# Convert text to a stream so Azure can "upload" it as a file
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($LogContent)
$MemoryStream = New-Object System.IO.MemoryStream($Bytes, 0, $Bytes.Length)

# 4. Upload to the Container
Set-AzStorageBlobContent -Context $Ctx -Container $ContainerName -Blob $BlobName -Stream $MemoryStream -Force

Write-Output "Success: Log for $VMName uploaded to storage as $BlobName"