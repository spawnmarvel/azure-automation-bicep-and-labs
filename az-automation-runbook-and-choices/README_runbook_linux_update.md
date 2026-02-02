# What is Azure Automation?

Automation simplifies cloud operations in three key areas:

- **Deploy and manage** – Deliver repeatable and consistent infrastructure as code.
- **Response** – Create event-based automation to diagnose and resolve issues.
- **Orchestrate** – Orchestrate and integrate your automation with other Azure or third-party services.

## Azure Automation runbook types
[Learn more about Runbook types](https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps74%2Cpy10)

## Quickstart: Create an Automation account using the Azure portal
One Automation account can manage resources across all regions and subscriptions for a given tenant. 

- **System-assigned:** A Microsoft Entra identity tied to the lifecycle of the Automation account.
- **User-assigned:** A standalone Azure resource managed separately from the resources that use it.

> **Note:** You can choose to enable managed identities later, and the Automation account is created without one. 

[Enable Managed Identity Guide](https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity)

### Networking
- **Public Access** – Provides a public endpoint that can receive traffic over the internet (default). 
- **Private Access** – Provides a private endpoint using a private IP address from your virtual network. 

![account](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/account.png)

[Create an Automation Account Guide](https://learn.microsoft.com/en-us/azure/automation/quickstarts/create-azure-automation-account-portal)

### Create a user-assigned managed identity
- Search for **Managed Identities** in the Azure Portal and select it under Services to create your identity resource.

![managed identity](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi.png)

[Identity Management Guide](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity)

### Enable managed identities for your Automation account using the Azure portal
**Prerequisites:** Active subscription, Automation account, and a user-assigned managed identity.

![system assignd was on](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_on.png)

**Add user-assigned managed identity:**
- Navigate to the **User assigned** tab.
- Click **+ Add**, select your identity, and click **Add**.

![mi_add_user_assigned](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_add_user_assigned.png)

[Detailed Identity Setup](https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity)

## Tutorial: Create Automation PowerShell runbook using managed identity
[Official PowerShell Runbook Tutorial](https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity)

## User-Assigned (The "Enterprise" Path) — What you have now

### 1. System-Assigned (The "Simple" Path)
- **How it works:** Tied directly to the Automation account.
- **Pros:** Automatic lifecycle management; no "orphan" resources.
- **Cons:** Limited to a single Automation account.

### 2. User-Assigned (The "Enterprise" Path) — What you have now
- **How it works:** A standalone resource (`name-managedidentity`) plugged into the account.
- **Pros:** **Reusability.** Manage permissions once and assign the identity to any tool (Logic Apps, Functions) that needs it.
- **Cons:** Requires manual deletion and `ClientId` reference in scripts.

**Recommendation:** Stick with **User-Assigned**. It is better practice for Infrastructure as Code and centralized permission management.

## Automation PowerShell runbook for linux updates
Automated weekly maintenance workflow:
- **Start VM** (if deallocated).
- **Run updates** via Bash.
- **Log to file** on the VM.
- **Stop VM** to save costs.

> **Important:** Managed Identities do not work on local machines; they only function within the Azure infrastructure.

### Step 1: Create the Runbook
1. Open your Automation Account.
2. Select **Runbooks** > **+ Create a runbook**.
3. Name: `Update-Dev-VMs-Weekly`, Type: **PowerShell**, Runtime: **7.2**.

![runbook](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/runbook.png)

### Check your RBAC
Assign the **Virtual Machine Contributor** role to your identity.
- **Subscription level:** Necessary if VMs are spread across multiple Resource Groups.

![add reader](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/add_reader.png)

### Step 2: To use the Identity you created, you must run the code inside the Automation Account's Test Pane:
1. Navigate to Runbook > **Edit** > **Test pane**.
2. Use the connection script below to verify authentication.

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

```

Result in log

```log
--- STARTING CONNECTIVITY TEST ---

Environments                                                                                           Context
------------                                                                                           -------
{[AzureCloud, AzureCloud], [AzureChinaCloud, AzureChinaCloud], [AzureUSGovernment, AzureUSGovernment]} Microsoft.Azure.…

SUCCESS: Authenticated as xxxxxxxxxxxxxxx
SUCCESS: Found 4 VMs.
```
## One Final Requirement:

Assign the Virtual Machine Contributor role at the Subscription scope. 

Run this locally on your admin machine:

```ps1

# 1. Configuration
$uamiName = "name-managedidentity"
$uamiRG = "YOUR_IDENTITY_RG"

# 2. Get Identity Details
$uami = Get-AzUserAssignedIdentity -ResourceGroupName $uamiRG -Name $uamiName

# 3. Apply Role Assignment at Subscription scope
New-AzRoleAssignment -ObjectId $uami.PrincipalId -RoleDefinitionName "Virtual Machine Contributor" -Scope "/subscriptions/$((Get-AzContext).Subscription.Id)"

```

## The Final Production Runbook for one vm

Safety Gate: The script skips the update if the VM is already running to avoid interrupting active work.

Script

```ps1

# other code
# =================================================================================
# 3. POWER STATE VERIFICATION
# =================================================================================
Write-Output "Checking power state for $TestVMName..."

$vmStatus = Get-AzVM -ResourceGroupName $TestRG -Name $TestVMName -Status
$displayStatus = ($vmStatus.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus

Write-Output "Current status: $displayStatus"

# Safety Gate: Skip if the VM is already running
if ($displayStatus -ne "VM deallocated") {
    Write-Warning "SKIPPING: Maintenance aborted because VM is not in a deallocated state."
    return 
}
# other code
```
Testing results:

## The Final Production Runbook for all vms with tag Patching:Weekly

Target VMs globally across the subscription using the tag Patching: Weekly.

Why this handles "Many Resource Groups" perfectly:

* Global Scope: Scans the entire subscription for tagged VMs.* Dynamic Targeting: Automatically identifies the correct Resource Group for each VM.

Script
```ps1
# other code
# =================================================================================
# 3. GLOBAL DISCOVERY (Scanning Entire Subscription via Tags)
# =================================================================================
Write-Output "Scanning all Resource Groups for VMs with tag 'Patching: Weekly'..."

# Get-AzVM without -ResourceGroupName pulls every VM in the subscription
$allVMs = Get-AzVM 
$targetVMs = $allVMs | Where-Object { $_.Tags['Patching'] -eq 'Weekly' }

if ($null -eq $targetVMs -or $targetVMs.Count -eq 0) {
    Write-Warning "No VMs found with tag 'Patching: Weekly'. Execution aborted."
    return
}

Write-Output "SUCCESS: Found $($targetVMs.Count) tagged VMs across the subscription."

# other code

```
1. Publish the RunbookThe runbook must move from "Draft" to "Published" to allow for scheduled execution.
2. Link the ScheduleLink a schedule (e.g., Mondays at 09:00 AM). Verify the Time Zone.

Trigger runbook

You can manually trigger, edit, or view job logs from the dashboard.

#### Azure Automation Costs

First 500 minutes of job execution are free every month.

* Usage: 4 VMs x ~5 mins = 20 mins/week (~80 mins/month).
* Result: Fully covered by the Free Tier.

Category Free Limit, Post-Limit Price

* Job runtime 500 min, $0.002/min
* Watchers 744 hours, $0.002/hour
* Non-Azure nodes5, nodes$6/node

Official Pricing Details

#### How reboot is handled

The Stop-AzVM (Deallocate) and Start-AzVM cycle performs a cold boot.
* Hardware is re-initialized.
* The Linux bootloader (GRUB) automatically picks the newest kernel installed during the maintenance window.
* Result: A cold boot ensures all updates apply correctly without manual intervention.

#### Executive Summary: Automated Infrastructure Maintenance

Benefit and Impact

💰 Cost ReductionAutomated deallocation eliminates spend on idle resources.

🛡️ SecurityWeekly patching ensures compliance and reduces vulnerability risks.

⚙️ EfficiencySaves hours of manual labor, allowing the team to focus on high-value projects.

📉 Risk MitigationRepeatable logic eliminates human error and manual typos.

####

Job status or health check
The Big Picture: Check Jobs for "Completed" status.

The Receipts: Check the Output tab for Bash logs.

Manual Validation:

```bash

ssh <vm-ip>
cat apt-maintenance-2026-02-02.log

```

Or check in the portal

![portal log](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/portal_log.png)


#### Automatic Module Updates (TODO)

Keep your Az modules current via Shared Resources > Modules > Update Az modules.

Module Update Guide

#### Alert (TODO)

Set up a "Failure" Alert in Azure Monitor to notify the team via email if a job fails


## Now that your User-Assigned Identity has the power to manage VMs and the Run Command is working, the possibilities are endless.