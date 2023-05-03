# install az module
# if powershell v5, The MSI installation option can only be used to install the Az PowerShell module for use with Windows PowerShell 5.1.

$PSVersionTable.PSVersion
# Major  Minor  Build  Revision
# -----  -----  -----  --------
# 5      1      17763  3770
# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-9.7.1&tabs=powershell&pivots=windows-msi

# Get az version
Get-InstalledModule -Name Az -AllVersions | select Name,Version

Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-9.7.1&tabs=powershell&pivots=windows-msi

# Example 2: Connect to Azure using organizational ID credentials, This scenario works only when the user does not have multi-factor auth turned on. 
# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1

# The Tenant ID and Directory ID are the same.

$password = "you-shall-not-pass"
$username = "DOMAIN\f_user"
$secpassword = $password | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$secpassword) # this is not correct for Azure
# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1

# Connect-AzAccount -Credential $credential -Tenant ID # The Tenant ID and Directory ID are the same.

# Use this !!!!!!
# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1

$Credential = Get-Credential # add user@domain.com and password in the prompt
Connect-AzAccount -Credential $Credential

# RBACK must be set for correct access
Get-AzKeyVault -VaultName NAME -ResourceGroupName RG -SubscriptionId ID






