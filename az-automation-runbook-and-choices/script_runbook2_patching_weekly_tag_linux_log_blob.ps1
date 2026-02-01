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
# 3. GLOBAL DISCOVERY
# =================================================================================
Write-Output "Scanning for VMs with tag 'Patching: Weekly'..."

$allVMs = Get-AzVM 
$targetVMs = $allVMs | Where-Object { $_.Tags['Patching'] -eq 'Weekly' }

if ($null -eq $targetVMs -or $targetVMs.Count -eq 0) {
    Write-Warning "No tagged VMs found. Execution aborted."
    return
}

Write-Output "SUCCESS: Found $($targetVMs.Count) VMs."

# =================================================================================
# 4. POWER STATE VERIFICATION & START (WITH WAIT)
# =================================================================================
$vmsToUpdate = @()

foreach ($vm in $targetVMs) {
    $statusInfo = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    $displayStatus = ($statusInfo.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    
    if ($displayStatus -eq "VM deallocated") {
        Write-Output "Starting $($vm.Name)... (Waiting for 'Running' status)"
        # Removing -NoWait ensures we don't send commands to a booting VM
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -ErrorAction Stop
        $vmsToUpdate += $vm
    } else {
        Write-Warning "SKIPPING $($vm.Name): Status is '$displayStatus'."
    }
}

if ($vmsToUpdate.Count -eq 0) {
    Write-Output "No VMs were started. Execution finished."
    return
}

# Extra safety buffer to let Linux services (like the Agent) fully initialize
Write-Output "VMs are 'Running'. Waiting 30 seconds for Guest Agent handshake..."
Start-Sleep -Seconds 30

# =================================================================================
# 5. MAINTENANCE EXECUTION (BASH)
# =================================================================================
$BashScript = @'
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"
START_TIME=$SECONDS

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1

DURATION=$((SECONDS - START_TIME))
echo "--- Total Time: $((DURATION / 60))m $((DURATION % 60))s ---" >> $LOG_FILE
sudo find /var/log/ -name "apt-maintenance-*.log" -mtime +30 -delete

cat $LOG_FILE
'@

foreach ($vm in $vmsToUpdate) {
    $VMName = $vm.Name
    Write-Output "----------------------------------------------"
    Write-Output "Processing $VMName..."
    
    try {
        # Execute Bash and capture output
        $RunResult = Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName `
                                           -VMName $VMName `
                                           -CommandId 'RunShellScript' `
                                           -ScriptString $BashScript -ErrorAction Stop
        
        $LogContent = $RunResult.Value[0].Message
        
        # 6. STORAGE UPLOAD (Inside Loop)
        if ($null -ne $LogContent -and $LogContent.Trim() -ne "") {
            Write-Output "Uploading log for $VMName to Storage..."
            $Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
            $BlobName = "${VMName}_" + (Get-Date -Format "yyyy-MM-dd_HHmm") + ".log"
            
            $TempPath = Join-Path $env:TEMP "${VMName}_temp.log"
            $LogContent | Out-File -FilePath $TempPath -Encoding utf8

            Set-AzStorageBlobContent -Context $Ctx -Container $ContainerName -Blob $BlobName -File $TempPath -Force | Out-Null
            Remove-Item $TempPath
            Write-Output "Success: Log stored as $BlobName"
        }
    }
    catch {
        Write-Error "FAILURE: Update failed on $VMName. Error: $($_.Exception.Message)"
    }

    # 7. SHUTDOWN (WITH WAIT)
    Write-Output "Deallocating $VMName... (Waiting for 'Deallocated' status to save costs)"
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $VMName -Force -ErrorAction SilentlyContinue
}

# =================================================================================
# 8. FINAL SUMMARY
# =================================================================================
$OverallEnd = Get-Date
$TimeUsed = "{0:mm} minutes and {0:ss} seconds" -f ($OverallEnd - $OverallStart)

Write-Output "----------------------------------------------"
Write-Output "FINAL MAINTENANCE SUMMARY"
Write-Output "Total VMs Processed: $($vmsToUpdate.Count)"
Write-Output "--- TOTAL TIME USED: $TimeUsed ---"
Write-Output "----------------------------------------------"
Write-Output "Global Weekly Maintenance Sequence Complete."