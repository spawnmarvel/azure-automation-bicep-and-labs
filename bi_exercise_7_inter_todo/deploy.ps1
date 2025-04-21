# Function to append to the log file
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logFile = "c:\temp\bicep_install_log.txt"
    Add-Content -Path $logFile -Value $logEntry
    # comment this out for only file log
    Write-Host $logEntry
}

$st = "Start deploy:" + (Get-Date)
Write-Log $st

# rg and location
$rgName = "Rg-iac-00101"
$location  = "uk south"

# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "DeplN-" + $tempId.ToString()
Write-Log $deploymentId


# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile main.bicep -WhatIf

Write-Log $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
Write-Log $end