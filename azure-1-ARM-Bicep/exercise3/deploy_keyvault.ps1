
# rg and location
$rgName = "Rg-iac-0003"
$location  = "uk south"

$keyVaultName = 'kviac0041'
$login = Read-Host "Enter username" -AsSecureString
$password = Read-Host "Enterpassword" -AsSecureString

New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password


# You're setting the -EnabledForTemplateDeployment setting on the vault so that Azure can use the secrets from your vault during deployments. 
# If you don't set this setting then, by default, your deployments can't access secrets in your vault.
# Also, whoever executes the deployment must also have permission to access the vault. 
# Because you created the key vault, you're the owner, so you won't have to explicitly grant the permission in this exercise. 
# For your own vaults, you need to grant access to the secrets.
