
# Log it
Function LogResult($txt) {
    Add-Content log.txt $txt
}
$st = "Start-" + (Get-Date)
LogResult($st)

# rg and location
$rgName = "Rg-iac-0001"
$location  = "uk south"

# deployment name
$deploymentUnixTime = Get-Date -UFormat %s
$deploymentName = $deploymentUnixTime + "-unixTimeId"
Write-Host $deploymentName
LogResult($deploymentName)

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentName -TemplateFile templates\main.bicep # -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End-" + ($deployResult.ProvisioningState)
LogResult($end)


