
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
$location = "uk south"
$existingLogAna = "ToyLogs"
$existingStAccount = "toylogstsacount945"


# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "DeplN-" + $tempId.ToString()
Write-Log $deploymentId


# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure = "IAC" } -Force

 # Create an Azure Log Analytics workspace to simulate your R&D team's already having created one in your organization. Use Azure PowerShell instead of Bicep.
try {
    # Try to get the existing Log Analytics workspace
    $check_la = $null
    try {
        $check_la = Get-AzOperationalInsightsWorkspace -ResourceGroupName $rgName -Name $existingLogAna -ErrorAction Stop
    }
    catch {
        # Workspace not found or another error
        Write-Host "Workspace '$existingLogAna' not found in resource group '$rgName'. It will be created."
    }

    if ($null -eq $check_la) {
        # Create the workspace
        New-AzOperationalInsightsWorkspace -ResourceGroupName $rgName -Name $existingLogAna -Location $location
        Write-Host "Workspace '$existingLogAna' created in resource group '$rgName'."
    }
    else {
        Write-Host "Workspace '$existingLogAna' already exists in resource group '$rgName'."
    }
}
catch {
    Write-Host "An unexpected error occurred:"
    Write-Host $_
}

# Create an Azure storage account to simulate your R&D team's already having created one in your organization. Use Azure PowerShell instead of Bicep.
try {
    # Try to get the existing storage account
    $check_st = $null
    try {
        $check_st = Get-AzStorageAccount -ResourceGroupName $rgName -Name $existingStAccount
    }
    catch {
        # Workspace not found or another error
        Write-Host "Workspace '$existingLogAna' not found in resource group '$rgName'. It will be created."
    }

    if ($null -eq $check_st) {
        # Create the st account
        New-AzStorageAccount -ResourceGroupName $rgName -Name $existingStAccount -Location $location -SkuName "Standard_LRS"
        Write-Host "Workspace '$existingStAccount' created in resource group '$rgName'."
    }
    else {
        Write-Host "Workspace '$existingStAccount' already exists in resource group '$rgName'."
    }
}
catch {
    Write-Host "An unexpected error occurred:"
    Write-Host $_
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




