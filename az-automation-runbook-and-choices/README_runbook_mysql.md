# Azure MySql Runbook

## Final runbook for stop Azure MySQL

When we first run the script

script

```ps1
s_runbook1_patching_vm_one_linux.ps1
```

```log
does not have authorization to perform action 'Microsoft.DBforMySQL/flexibleServers/stop/action' over scope
```
We need to define a custom role to the usernamemanagedidentity



![rbak custom](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/rbac_custom.png)