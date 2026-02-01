# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "YOUR-CLIENT-ID" 
$TenantId       = "YOUR-TENANT-ID" 
$SubscriptionId = "YOUR-SUB-ID" 

##### script to copy v 1.0

# Target VM for testing
$TestVMName     = "vmchaos09" 
$TestRG         = "RG-UKCHAOS-0009"

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
# 3. POWER STATE VERIFICATION
# =================================================================================
Write-Output "Checking power state for $TestVMName..."

$vmStatus = Get-AzVM -ResourceGroupName $TestRG -Name $TestVMName -Status
$displayStatus = ($vmStatus.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus

Write-Output "Current status: $displayStatus"

# Safety Gate: Skip if the VM is already running (someone might be using it)
if ($displayStatus -ne "VM deallocated") {
    Write-Warning "SKIPPING: Maintenance aborted because VM is not in a deallocated state."
    return 
}

# =================================================================================
# 4. START SEQUENCE
# =================================================================================
Write-Output "VM is idle. Booting $TestVMName for maintenance..."

Start-AzVM -ResourceGroupName $TestRG -Name $TestVMName -ErrorAction Stop

# Wait for the Azure Guest Agent to pulse (crucial for RunCommand)
Write-Output "Waiting 90 seconds for Guest Agent to become Ready..."
Start-Sleep -Seconds 90

# =================================================================================
# 5. MAINTENANCE EXECUTION (BASH)
# =================================================================================
# Note: Using single-quote here-string to prevent PowerShell from parsing $ variables
$BashScript = @'
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

# Output the last few lines of the log so they appear in the Runbook output
tail -n 5 $LOG_FILE
'@

Write-Output "Executing apt-get update and upgrade..."

try {
    $result = Invoke-AzVMRunCommand -ResourceGroupName $TestRG -VMName $TestVMName `
                                    -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
    
    # Display the Bash output in the Automation Job logs
    Write-Output "Bash Output: $($result.Value[0].Message)"
    Write-Output "SUCCESS: Maintenance script completed on $TestVMName."
}
catch {
    Write-Error "FAILURE: Maintenance command failed on $TestVMName. Error: $($_.Exception.Message)"
}

# =================================================================================
# 6. SHUTDOWN & DEALLOCATE
# =================================================================================
Write-Output "Maintenance finished. Deallocating $TestVMName to stop billing..."

Stop-AzVM -ResourceGroupName $TestRG -Name $TestVMName -Force -NoWait

Write-Output "Runbook execution finished."