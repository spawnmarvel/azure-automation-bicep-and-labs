# Bicep Linux VM using Powershell

## Quickstart: Create an Ubuntu Linux virtual machine using a Bicep file and Powershell

Read more:

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=PowerShell

## Use ps1 scripts (but example in both for connect)

Powershell

```ps1
Connect-AzAccount -TenantId The-tenant-id-we-copied-from-azure-ad

```
* deploy.ps1, does it work, else fix it = Y/N
* deploy_remove.ps1, does it work, else fix it = Y/N
* deploy_manual_reset_user.ps1, Go to Portal->VM->Help->Reset password, or make az cli for this
* deploy_verify.ps1, does it work, else fix it = Y/N
* deploy_autoshutdown.ps1, does it work, else fix it = Y/N

Bash

```bash
az login --tenant The-tenant-id-we-copied-from-azure-ad
```

az-ps1 and cli reference https://follow-e-lo.com/azure-tips-for-test-vms/

SSH to Linux VM

```bash
ssh user@ip-address

```



