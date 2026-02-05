# Azure MySql Runbook

## Final runbook for stop Azure MySQL

When we first runt the script

```log
does not have authorization to perform action 'Microsoft.DBforMySQL/flexibleServers/stop/action' over scope
```
We need to define a custom role to the usernamemanagedidentity



![rbak custom](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/rbac_custom.png)