# https://stackoverflow.com/questions/44051241/how-to-catch-exceptions-on-powershell

$rgName = "Rg-iac-0080"
try {
    Get-AzResourceGroup -Name $rgName -Force
}
catch {
    Write-Host "rg does not exist $rgName"
}
