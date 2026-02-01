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
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

tail -n 5 $LOG_FILE
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
#