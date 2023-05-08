
Function LogModule($txt) {
    Add-Content log.txt $txt
}

$st = "Start deploy:" + (Get-Date)
LogModule($st)

# rg and location
$rgName = "Rg-iac-0058"
$location  = "uk south"

# deployment id
$tempId = Get-Date -UFormat %s
$deploymentId = "DeplN-" + $tempId.ToString()
Write-Host $deploymentId
LogModule($deploymentId)

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy resources
# $deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile main.bicep #  -WhatIf
# deploy with main name and other resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main_linux.bicep # -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
LogModule($end)



