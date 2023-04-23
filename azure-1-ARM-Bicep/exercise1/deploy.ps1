
# import log module
Import-Module .\Modules\LogModule\

$st = "Start deploy:" + (Get-Date)
LogModule($st)

# rg and location
$rgName = "Rg-iac-0001"
$location  = "uk south"

# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "Depl-" + $tempId.ToString()
Write-Host $deploymentId
LogModule($deploymentId)

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile templates\main.bicep # -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
LogModule($end)




