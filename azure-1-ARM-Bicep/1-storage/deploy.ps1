
$rgName = "Rg-iac-0001"
$location  = "uk south"

New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

Set-Location -Path templates

New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main.bicep # -WhatIf

