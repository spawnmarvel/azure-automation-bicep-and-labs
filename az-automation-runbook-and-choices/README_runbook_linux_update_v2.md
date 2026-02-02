# What is Azure Automation?

Automation simplifies cloud operations in three key areas:

- **Deploy and manage** – Deliver repeatable and consistent infrastructure as code.
- **Response** – Create event-based automation to diagnose and resolve issues.
- **Orchestrate** – Integrate Azure services with third-party products.

## Azure Automation runbook types
[Learn more about Runbook types](https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps74%2Cpy10)

## Quickstart: Create an Automation account using the Azure portal
One Automation account can manage resources across regions and subscriptions for a given tenant.

- **System-assigned:** An identity tied to the lifecycle of the Automation account.
- **User-assigned:** A standalone Azure resource managed separately.

> **Note:** Managed identities can be enabled during creation or after the account is created. 

[Enable Managed Identity Guide](https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity)

### Networking
- **Public Access** – Default option providing a public endpoint via the internet.
- **Private Access** – Provides a private endpoint using a private IP from your virtual network.

![account](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/account.png)

[Create an Automation Account Guide](https://learn.microsoft.com/en-us/azure/automation/quickstarts/create-azure-automation-account-portal)

### Create a user-assigned managed identity
- Search for **Managed Identities** in the portal to create a standalone identity resource.

![managed identity](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi.png)

[Identity Management Guide](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity)

### Enable managed identities for your Automation account using the Azure portal
**Prerequisites:** An active subscription, an Automation account, and a user-assigned managed identity.

![system assignd was on](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_on.png)

**Add user-assigned managed identity:**
- Select the **User assigned** tab and click **+ Add**.
- Select your existing identity and click **Add**.

![mi_add_user_assigned](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_add_user_assigned.png)

[Detailed Identity Setup](https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity)

## Tutorial: Create Automation PowerShell runbook using managed identity
[Official PowerShell Runbook Tutorial](https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity)

## User-Assigned (The "Enterprise" Path) — What you have now

### 1. System-Assigned (The "Simple" Path)
- **Mechanism:** Enabled directly inside the account. Identity name matches the account name.
- **Pros:** Automatic lifecycle management; no "orphan" resources upon deletion.
- **Cons:** Limited to a single Automation account.

### 2. User-Assigned (The "Enterprise" Path) — What you have now
- **Mechanism:** A standalone resource (`name-managedidentity`) plugged into the account.
- **Pros:** **Reusability.** Centralize permissions for multiple tools (Logic Apps, Functions) under one identity.
- **Cons:** Manual cleanup required; script requires a `ClientId`.

**Recommendation:** Stick with **User-Assigned**. It is best practice for Infrastructure as Code (IaC) and keeps permissions centralized.

## Automation PowerShell runbook for linux updates
The automated weekly workflow handles:
- Starting the VM (if deallocated).
- Executing updates via Bash.
- Logging output to the VM.
- Deallocating the VM to save costs.

> **Important:** Managed Identities only function *within* Azure infrastructure and will not work on local machines.

### Step 1: Create the Runbook
1. Go to your Automation Account > **Runbooks**.
2. Click **+ Create a runbook**.
3. Name: `Update-Dev-VMs-Weekly`, Type: **PowerShell**, Runtime: **7.2**.

![runbook](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/runbook.png)

### Check your RBAC
Assign the **Virtual Machine Contributor** role to your identity at the **Subscription level** to ensure power over all VMs across multiple Resource Groups.

![add reader](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/add_reader.png)

### Step 2: To use the Identity you created, you must run the code inside the Automation Account's Test Pane:
1. Navigate to Runbook > **Edit** > **Test pane**.
2. Paste the diagnostic code to verify connectivity.

## Connect and test
```ps1
# DESCRIPTION: Diagnostic Script for name-managedidentity
# REQUIRED ROLES: Reader or VM Contributor at SUBSCRIPTION level.

$ClientId       = "xxxxxxxxxxxxxxxxxxxx" 
$TenantId       = "xxxxxxxxxxxxxxxxxxxx" 
$SubscriptionId = "xxxxxxxxxxxxxxxxxxxx" 

Write-Output "--- STARTING CONNECTIVITY TEST ---"

try {
    Connect-AzAccount -Identity -AccountId $ClientId -TenantId $TenantId -SubscriptionId $SubscriptionId -ErrorAction Stop
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
    Write-Output "SUCCESS: Authenticated as $((Get-AzContext).Account.Id)"
}
catch {
    Write-Error "AUTHENTICATION FAILED: $($_.Exception.Message)"; return
}

$vms = Get-AzVM -ErrorAction Stop
if ($vms.Count -gt 0) {
    Write-Output "SUCCESS: Found $($vms.Count) VMs."
} else {
    Write-Warning "Connected, but no VMs found. Check RBAC permissions."
}