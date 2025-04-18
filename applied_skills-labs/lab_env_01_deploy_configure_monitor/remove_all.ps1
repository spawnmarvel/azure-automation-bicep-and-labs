
$rg = "rg-alphadev"
Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -AsJob