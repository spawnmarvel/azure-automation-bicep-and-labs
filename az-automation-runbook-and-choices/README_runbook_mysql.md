# Azure MySql Runbook

## Custom role MySQL Flexible Server Power Operator

When we first run the script

script

```ps1
s_runbook3_stop_mysql_weekly.ps1
```

We got:

```log
does not have authorization to perform action 'Microsoft.DBforMySQL/flexibleServers/stop/action' over scope
```
We need to define a custom role to the usernamemanagedidentity

Step 1: Navigate to Custom Roles
1. Search for Subscriptions in the top search bar and click on your active subscription.
2. On the left-hand menu, click Access control (IAM).
3. Click the + Add button at the top and select Add custom role.

Step 2: Basic Configuration
1. Custom role name: MySQL Flexible Server Power Operator
2. Description: Allows starting, stopping, and viewing status of MySQL Flexible Servers.
3. Baseline permissions: Leave as "Start from scratch".

Step 3: Adding the Specific Permissions
11. Instead of searching through the massive list, we will use the JSON editor inside the creation wizard to be precise.
2. Click Edit.
3. Locate the "actions": [] section and replace it so it looks exactly like this:

```json
"actions": [
    "Microsoft.DBforMySQL/flexibleServers/start/action",
    "Microsoft.DBforMySQL/flexibleServers/stop/action",
    "Microsoft.DBforMySQL/flexibleServers/read"
],
```

![rbak custom](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/rbac_custom.png)

## Final runbook for stop Azure MySQL