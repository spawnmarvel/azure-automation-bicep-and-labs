
Function LogModule($txt) {
    Add-Content log.txt $txt
}

$st = "Start deploy:" + (Get-Date)
LogModule($st)

# rg and location
$rgName = "Rg-iac-0052"
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
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main.bicep #  -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
LogModule($end)

Write-Host 'if you create a default Powershell HttpTrigger:'
Write-Host 'Vist URL HttpTrigger1, Authorization level, A function-specific API key is required. This is the default value when a level isn t specifically set.'
Write-Host 'View keys->Functions->App keys'
#           FunctionApp..HttpTrigger1?param=YOUR-INPUT&Code=APP-KEY
Write-Host 'https://FUNCTIONNAME.azurewebsites.net/api/HttpTrigger1?name=espen&code=APP-KEY'

