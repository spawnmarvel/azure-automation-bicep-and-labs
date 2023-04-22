
$rgName = "Rg-iac-0001"
$location  = "uk south"

# deployment name
$deploymentUnixTime = Get-Date -UFormat %s
$deploymentName = $deploymentUnixTime + "-unixTime"
Write-Host $deploymentName

New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# Set-Location -Path templates

New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentName -TemplateFile templates\main.bicep # -WhatIf


