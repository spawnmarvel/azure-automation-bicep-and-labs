

$st = "Start deploy:" + (Get-Date)

# jepp secure it, and get it from keyvault
$var = Get-Content ".\keyvault.txt"
$arr = $var.Split([Environment]::NewLine)
$userName = $arr[0]
$passWordSecure = ConvertTo-SecureString $arr[1] -AsPlainText -Force
Write-Host $userName
Write-Host $passWordSecure

# rg and location
$rgName = "Rg-iac-linux-fu-0981"
$location  = "uk south"

# deploy rg
New-AzResourceGroup -Name $rgName  -Location $location -Tag @{Infrastructure="IAC"} -Force

# deploy with main name and other resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -adminUsername $userName -adminPasswordOrKey $passWordSecure -TemplateFile main.bicep #  -WhatIf

Write-Host $deployResult.ProvisioningState
$end = "End deploy:" + ($deployResult.ProvisioningState)
Write-Host $end




