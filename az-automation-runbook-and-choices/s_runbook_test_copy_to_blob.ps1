# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId           = "YOUR-CLIENT-ID" 
$TenantId           = "YOUR-TENANT-ID" 
$SubscriptionId     = "YOUR-SUB-ID" 
$ResourceGroupName  = "RG-UKCHAOS-0009"
$TargetVMName       = "vmchaos09"
$StorageAccountName = "jeklrunbooklogs"
$ContainerName      = "vm-logs-linux-updates"

##### Script version 1.3

# =================================================================================
# 2. AUTHENTICATION (Consistent with Main Script)
# =================================================================================
$OverallStart = Get-Date
Write-Output "--- STARTING MAINTENANCE: Version 1.3 ---"
Write-Output "Authenticating via Managed Identity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId | Out-Null

# =================================================================================
# 3. STATUS CHECK
# =================================================================================
Write-Output "Checking status for $TargetVMName in $ResourceGroupName..."

try {
    $vmStatus = Get-AzVM -Name $TargetVMName -ResourceGroupName $ResourceGroupName -Status -ErrorAction Stop
    $displayStatus = ($vmStatus.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    Write-Output "Current Power Status: $displayStatus"
}
catch {
    Write-Error "CRITICAL: Access denied or VM not found. Check variables for Version 1.3"
    return
}

# =================================================================================
# 4. START LOGIC
# =================================================================================
if ($displayStatus -eq "VM deallocated") {
    Write-Output "Waking up VM..."
    Start-AzVM -Name $TargetVMName -ResourceGroupName $ResourceGroupName -NoWait
    Write-Output "Waiting 90s for Linux Guest Agent..."
    Start-Sleep -Seconds 90
} else {
    Write-Output "VM is already $displayStatus. Proceeding..."
}

# =================================================================================
# 5. EXECUTION & STORAGE UPLOAD
# =================================================================================
$BashScript = @"
echo "--- Patching Log \$(date) ---"
echo "Script Version: 1.3"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "--- Finish Log \$(date) ---"
"@

try {
    Write-Output "Executing Update Command on $TargetVMName..."
    $result = Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName `
                                    -VMName $TargetVMName `
                                    -CommandId 'RunShellScript' `
                                    -ScriptString $BashScript -ErrorAction Stop
    
    $LogContent = $result.Value[0].Message

    if ($null -ne $LogContent -and $LogContent.Trim() -ne "") {
        $Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount
        $FileName = "${TargetVMName}_$(Get-Date -Format 'yyyyMMdd_HHmm').log"
        $TempPath = Join-Path $env:TEMP $FileName
        
        $LogContent | Out-File -FilePath $TempPath -Encoding utf8
        
        Set-AzStorageBlobContent -Context $Ctx -Container $ContainerName `
                                 -Blob $FileName -File $TempPath -Force | Out-Null
        
        Write-Output "SUCCESS: Log file $FileName uploaded to Storage."
        Remove-Item $TempPath
    }
}
catch {
    Write-Error "PROCESS FAILED: $($_.Exception.Message)"
}

# =================================================================================
# 6. STOP & SUMMARY
# =================================================================================
Write-Output "Deallocating $TargetVMName..."
Stop-AzVM -Name $TargetVMName -ResourceGroupName $ResourceGroupName -Force -NoWait

$OverallEnd = Get-Date
$TimeUsed = "{0:mm} minutes and {0:ss} seconds" -f ($OverallEnd - $OverallStart)
Write-Output "--- MAINTENANCE COMPLETE: Version 1.3 (Total Time: $TimeUsed) ---"