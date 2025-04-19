# rg and location
$rgName = "Rg-iac-0002"
$location  = "uk south"


$keyVaultName = "dev-kv-0002"
$login = Read-Host "Enter the login name" -AsSecureString
$password = Read-Host "Enter the password" -AsSecureString

New-AzKeyVault -ResourceGroupName $rgName -VaultName $keyVaultName -Location $location -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "sqlServerAdministratorLogin" -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "sqlServerAdministratorPassword" -SecretValue $password