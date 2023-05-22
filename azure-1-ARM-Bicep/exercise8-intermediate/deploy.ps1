

$st = "Start deploy:" + (Get-Date)


# rg and location
$rgName = "Rg-iac-0080"
$location  = "uk south"

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy with main name and other resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main.bicep #  -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
Write-Host $end




