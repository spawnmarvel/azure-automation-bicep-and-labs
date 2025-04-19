$rgName = "Rg-iac-0001"
Get-AzResourceGroupDeployment -ResourceGroupName $rgName | Format-Table