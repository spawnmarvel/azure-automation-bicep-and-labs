
# rg and location
$rgName = "Rg-iac-0003"
$location  = "uk south"

$keyVaultName = 'kviac0041'
$login = Read-Host "Marcus0041man" -AsSecureString
$password = Read-Host "Meditations0041-" -AsSecureString

New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password

