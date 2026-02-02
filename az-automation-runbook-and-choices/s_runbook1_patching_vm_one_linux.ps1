# =================================================================================
# DESCRIPTION: 
# This script performs automated Linux patching using a User-Assigned Managed Identity.
#
# REQUIRED ROLES (Assign to the User-Assigned Identity via IAM):
# 1. Virtual Machine Contributor (on the Resource Group or Subscription)
# =================================================================================

# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "YOUR-CLIENT-ID"  # ID of ' yourmanagedidentity'
$TenantId       = "YOUR-TENANT-ID" 
$SubscriptionId = "YOUR-SUBSCRIPTION-ID" 

##### Script version 2.3

# Target VM for testing
$TestVMName     = "vmchaos09" 
$TestRG         = "RG-UKCHAOS-0009"

# =================================================================================
# 2. AUTHENTICATION (User-Assigned Identity)
# =================================================================================
Write-Output "Connecting to Azure via User-Assigned Managed Identity..."

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

# Safety Gate: Skip if the VM is already running
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
$BashScript = @'
# This prevents the "debconf" errors seen in the previous log
export DEBIAN_FRONTEND=noninteractive

LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
# -o Dpkg::Options::="--force-confold" keeps existing configs and prevents prompts
sudo apt-get upgrade -y -o Dpkg::Options::="--force-confold" >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

cat $LOG_FILE
'@

Write-Output "Executing apt-get update and upgrade..."

try {
    $result = Invoke-AzVMRunCommand -ResourceGroupName $TestRG -VMName $TestVMName `
                                    -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
    
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

Write-Output "Runbook execution finished (Version 2.3)."