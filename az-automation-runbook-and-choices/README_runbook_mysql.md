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
4. Click Save.

```json
"actions": [
    "Microsoft.DBforMySQL/flexibleServers/start/action",
    "Microsoft.DBforMySQL/flexibleServers/stop/action",
    "Microsoft.DBforMySQL/flexibleServers/read"
],
```

![rbak custom](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/rbac_custom.png)

Step 4: Assignable Scopes
1. Click the Assignable scopes tab.
2. Ensure your Subscription ID is listed there. This tells Azure where this role is allowed to be used.

Step 5: Review and Create

We can now search for it:

![role](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/role.png)

Step 6: Assign the Role to your Managed Identity
1. Go back to your Resource Group
2. Click Access control (IAM) -> + Add -> Add role assignment.
3. In the search box, type your new role name: MySQL Flexible Server Power Operator.
4. Select it and click Next.
5. Select Managed identity and pick your name-managedidentity.
6. Click Review + assign.


Log when it is stopped.

```log
--- STARTING SYSTEM CHECK: Version 1.0.2 ---
Attempting connection for name-managedidentity...

Environments                                                                                           Context
------------                                                                                           -------
{[AzureUSGovernment, AzureUSGovernment], [AzureChinaCloud, AzureChinaCloud], [AzureCloud, AzureCloud]} Microsoft.Azure.…

SUCCESS: Authenticated as 3xxxxxxxxxxxxxxxxxxxxxxxxxx
Checking status of MySQL Flexible Server: mysqlzabbix0101
Current Server State: Stopped
NOTICE: Server is already in 'Stopped' state. No action taken.
--- SCRIPT COMPLETE ---
```

Log when it is started.

```
--- STARTING SYSTEM CHECK: Version 1.0.2 ---
Attempting connection for name-managedidentity...

Environments                                                                                           Context
------------                                                                                           -------
{[AzureCloud, AzureCloud], [AzureChinaCloud, AzureChinaCloud], [AzureUSGovernment, AzureUSGovernment]} Microsoft.Azure.…

SUCCESS: Authenticated as 3xxxxxxxxxxxxxxxxxxxxx
Checking status of MySQL Flexible Server: mysqlzabbix0101
Current Server State: Ready
Server is ACTIVE. Initiating Stop command...
SUCCESS: Stop command sent. State will move to 'Stopped' shortly.
--- SCRIPT COMPLETE ---
```

Automatic Start: 

The server will remain in the stopped state for 30 consecutive days. If you do not manually start it within that period, it will automatically start at the end of the 30 days.

Management Operations: 

While the server is stopped, you cannot perform most management operations or configuration changes (e.g., changing pricing tier, storage size, or server parameters). You must start the server first to make these changes.


## Final runbook for stop Azure MySQL

script

```ps1
s_runbook3_stop_mysql_weekly.ps1
```

Schedule at Sundays at 23:00 every week.

![schedule_mysql](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/schedule_mysql.png)
