


# Read credentials from key vault file
# Read the JSON file
$jsonContent = Get-Content -Path "./user.json" -Raw | ConvertFrom-Json
$userName = $jsonContent.Username
$passwordPlainText = $jsonContent.Password
$securePassword = ConvertTo-SecureString -String $passwordPlainText -AsPlainText -Force

$rg = "rg-alphadev"
$loc = "uksouth"
$winVm = "WS-VM1"
$linVm = "LX-VM2"

# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "DeplN-" + $tempId.ToString()
Write-Host $deploymentId

New-AzResourceGroup -Name $rg -Location $loc -Force

# Quickstart: Create a Windows virtual machine using a Bicep file
# https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-bicep?tabs=PowerShell

# Deploy and configure WS-VM1 add extra NSG for http
New-AzResourceGroupDeployment -Name $deploymentId -ResourceGroupName $rg -TemplateFile ./WS-VM1.bicep -vmName $winVm -adminUsername "prime" -adminPassword $securePassword -Mode Complete # -WhatIf 
Write-Host "Vm deploy done"
Write-Host "Use Set-AzVMCustomScriptExtension or Login to vm and install custom_install_all_features_ws-vm1.ps1"

# https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
# use raw file
Set-AzVMCustomScriptExtension -ResourceGroupName $rg -VMName $winVm -Location $loc `
    -FileUri "https://raw.githubusercontent.com/spawnmarvel/azure-administrator-grinding/refs/heads/main/applied-skills/lab_env_01_deploy_configure_monitor/custom_install_all_features_ws-vm1.ps1" `
    -Run "custom_install_all_features_ws-vm1.ps1" -Name DemoScriptExtension

# Quickstart: Create an Ubuntu Linux virtual machine using a Bicep file
# https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=PowerShell

# Deploy and configure LX-VM2

# Deploy a web app with an SQL Database

# Deploy a Linux web app

