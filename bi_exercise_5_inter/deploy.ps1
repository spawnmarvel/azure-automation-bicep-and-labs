
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
$rgName = "Rg-iac-0080"
$location  = "uk south"
$existingLogAna = "ToyLogs"
$existingStAccount = "toylogstsacount945"


# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "DeplN-" + $tempId.ToString()
Write-Log $deploymentId


# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# Create a Log Analytics workspace to simulate having one already created in your organization. Use Azure PowerShell instead of Bicep.
$check_la = Get-AzOperationalInsightsWorkspace -ResourceGroupName $rgName -Name $existingLogAna
if (null -eq $check_la) {
    # create it
    New-AzOperationalInsightsWorkspace -ResourceGroupName $rgName -Name $existingLogAna -Location $location
}
else {
    <# Action when all if and elseif conditions are false #>
    # pass, we have it
}
# Create an Azure storage account to simulate your R&D team's already having created one in your organization. Use Azure PowerShell instead of Bicep.
$check_st = Get-AzStorageAccount -ResourceGroupName $rgName -Name $existingStAccount
if ($null -eq $check_st) {
    # create it
    New-AzStorageAccount -ResourceGroupName $rgName -Name $existingStAccount -Location $location -SkuName "Standard_LRS"
}
else {
    <# Action when all if and elseif conditions are false #>
    # pass, we have it
}


# Your R&D team wants you to log all successful requests to the storage account they created. 
# You decide to use the Azure Storage integration with Azure Monitor logs to achieve this goal. 
# You decide to log all read, write, and delete activities within blob storage on the R&D team's storage account.

# Notice that both of these resources use the existing keyword. -TemplateFile main.bicep

# deploy with main name and other resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile main.bicep -storageAccountName $existingStAccount #  -WhatIf

Write-Log $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
Write-Log $end




