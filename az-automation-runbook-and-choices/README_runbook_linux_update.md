# What is Azure Automation?

Automation is needed in three broad areas of cloud operations:

- Deploy and manage - Deliver repeatable and consistent infrastructure as code.
- Response - Create event-based automation to diagnose and resolve issues.
- Orchestrate - Orchestrate and integrate your automation with other Azure or third party services and products.

## Azure Automation runbook types

https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps74%2Cpy10

## Quickstart: Create an Automation account using the Azure portal

One Automation account can manage resources across all regions and subscriptions for a given tenant. 

- System-assigned	Optional	A Microsoft Entra identity that is tied to the lifecycle of the Automation account.
- User-assigned	Optional	A managed identity represented as a standalone Azure resource that is managed separately from the resources that use it.

- You can choose to enable managed identities later, and the Automation account is created without one. To enable a managed identity after the account is created, see

https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity

Networking

- Public Access – This default option provides a public endpoint for the Automation account that can receive traffic over the internet and does not require any additional configuration. 
- Private Access – This option provides a private endpoint for the Automation account that uses a private IP address from your virtual network. 


![account](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/account.png)


https://learn.microsoft.com/en-us/azure/automation/quickstarts/create-azure-automation-account-portal

### Create a user-assigned managed identity

- In the search box, enter Managed Identities. Under Services, select Managed Identities.

![managed identity](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi.png)

https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity

### Enable managed identities for your Automation account using the Azure portal

- An Azure account with an active subscription
- An Azure Automation account
- A user-assigned managed identity.

![system assignd was on](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_on.png)

Your Automation account can now use the system-assigned identity, that is registered with Microsoft Entra ID and is represented by an object ID.


Add user-assigned managed identity

- Select the User assigned tab, and then select + Add or Add user assigned managed identity to open the Add user assigned managed i... page.
- Under User assigned managed identities, select your existing user-assigned managed identity and then select Add. You'll then be returned to the User assigned tab.


![mi_add_user_assigned](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/mi_add_user_assigned.png)


https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity


## Tutorial: Create Automation PowerShell runbook using managed identity


https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity

## User-Assigned (The "Enterprise" Path) — What you have now

1. System-Assigned (The "Simple" Path)

- How it works: You turn it on directly inside the name-automation account. Azure creates an identity with the exact same name as your Automation account.

- Pros: It’s "set it and forget it." If you delete the Automation account, the identity vanishes too. No leftover "orphan" resources.

- Cons: It only lives on that one Automation account. If you create a second Automation account later for a different project, you have to set up permissions all over again for the new one.

2. User-Assigned (The "Enterprise" Path) — What you have now


 How it works: Your name-managedidentity is a standalone resource. You "plug" it into your Automation account.

- Pros: Reusability. If you later decide to use a Logic App or a Function to handle other dev tasks, you can give them the same name-managedidentity. You manage the "Dev Permissions" once, and assign that identity to whatever tools need it.

- Cons: You have to manually delete it if you ever stop using it, and the script requires that ClientId we talked about.


Which should you choose?

Recommendation: Since you've already created name-managedidentity, stick with it. It’s better practice for "Infrastructure as Code" and keeps your permissions centralized under one "Dev Identity" rather than tying them strictly to the tool (Automation Account).


## Automation PowerShell runbook for linux updates

- Run on schedule once a week
- Start vm
- Run updates
- Log to file on vm
- Stop vm


Managed Identities do not work on local machines. They only exist "inside" the Azure infrastructure.


Step 1: Create the Runbook

1. In the Azure Portal, go to your name-automation Automation Account.

2. On the left menu, select Runbooks (under Process Automation).

3. Click + Create a runbook.

4. Name: Update-Dev-VMs-Weekly

5. Runbook type: PowerShell

6. Runtime version: 7.2 (the latest stable version).

7. Click Create.

![runbook](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/runbook.png)

Check your RBAC

1. Go to your Subscription (not just the RG).

2. Access Control (IAM).

3. Ensure name-managedidentity has at least Reader at the Subscription level, or Contributor at the Resource Group level.

![add reader](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/add_reader.png)

Step 2: To use the Identity you created, you must run the code inside the Automation Account's Test Pane:

The "Dry Run" Connection Script:

1. Go to the Azure Portal.

2. Navigate to your Automation Account name-automation > Runbooks.

3. Open your Runbook and click Edit.

4. Click on the Test pane button.

5. Paste your code there and click Start.

## Connect and test
```ps1
# =================================================================================
# DESCRIPTION: 
# This is a Diagnostic Connectivity Script to verify that the User-Assigned 
# Managed Identity (name-managedidentity) can authenticate and read the environment.
#
# REQUIRED ROLES (Assign to the User-Assigned Identity via IAM):
# 1. Reader or Virtual Machine Contributor (Assigned at the SUBSCRIPTION level).
# =================================================================================

# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "xxxxxxxxxxxxxxxxxxxx"  # ID of 'name-managedidentity'
$TenantId       = "xxxxxxxxxxxxxxxxxxxx" 
$SubscriptionId = "xxxxxxxxxxxxxxxxxxxx" 

##### Script version 2.5

# =================================================================================
# 2. AUTHENTICATION (User-Assigned Identity Verification)
# =================================================================================
Write-Output "--- STARTING CONNECTIVITY TEST: Version 2.5 ---"
Write-Output "Attempting connection for name-managedidentity..."

try {
    # Connect with ALL parameters to avoid 'null' context
    Connect-AzAccount -Identity `
                      -AccountId $ClientId `
                      -TenantId $TenantId `
                      -SubscriptionId $SubscriptionId -ErrorAction Stop

    # Explicitly set the context (The 'Double-Check')
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
    
    $CurrentContext = Get-AzContext
    Write-Output "SUCCESS: Authenticated as $($CurrentContext.Account.Id)"
}
catch {
    Write-Error "AUTHENTICATION FAILED: $($_.Exception.Message)"
    return
}

# =================================================================================
# 3. RESOURCE DISCOVERY VERIFICATION
# =================================================================================
Write-Output "Verifying resource visibility in Subscription: $SubscriptionId"

try {
    # Attempt to list VMs to prove RBAC roles are active
    $vms = Get-AzVM -ErrorAction Stop
    
    if ($vms.Count -gt 0) {
        Write-Output "SUCCESS: Found $($vms.Count) VMs."
    } else {
        Write-Warning "Connected, but no VMs found. Check if Identity has 'Reader' or 'VM Contributor' at the Subscription level."
    }
}
catch {
    Write-Error "DISCOVERY FAILED: Identity is logged in but lacks permissions to list VMs."
    Write-Error "Error Detail: $($_.Exception.Message)"
}

Write-Output "--- CONNECTIVITY TEST COMPLETE ---"

```
result

![test ps1](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/test_ps1.png)

One Final Requirement:

Your name-managedidentity needs the Virtual Machine Contributor role.

Since your VMs are spread across many Resource Groups, the easiest way to handle permissions is to assign that role at the Subscription level. 

This gives the identity permission to start/stop any VM in any group within that subscription.

Run this script locally on your machine using your own administrator credentials:

```ps1
$id = "xxxxxxxxx"
connect-AzAccount -TenantId $id
```

Then run this and set role

```ps1
# 1. Configuration
$uamiName = "name-managedidentity"
$uamiResourceGroup = "YOUR_IDENTITY_RG" # The RG where the identity lives

# 2. Get the Identity's Principal ID (Object ID)
$uami = Get-AzUserAssignedIdentity -ResourceGroupName $uamiResourceGroup -Name $uamiName
$principalId = $uami.PrincipalId

# 3. Get the Subscription ID (Current Context)
$subId = (Get-AzContext).Subscription.Id

Write-Host "Assigning 'Virtual Machine Contributor' to $uamiName for the ENTIRE Subscription: $subId" -ForegroundColor Cyan

# 4. Apply the Role Assignment at the Subscription scope
New-AzRoleAssignment -ObjectId $principalId -RoleDefinitionName "Virtual Machine Contributor" -Scope "/subscriptions/$subId" -ErrorAction Stop

Write-Host "SUCCESS: The Identity now has power over all VMs in the subscription." -ForegroundColor Green
```

## The Final Production Runbook for one vm

Create a new runbook, Update-Dev-VMs-Weekly-test1-vm

If the vm is running it should not be updated, because someone could be working on it.


Script

```ps1

s_runbook1_patching_vm_one_linux.ps1

```


Test when VM is running success

![test ps1 vm running](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/vm_running.png)

Test when VM is not running success

![test ps1 vm not running](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/vm_stopped.png)

## The Final Production Runbook for all vms with tag Patching:Weekly

Create Runbook Update-VMs-Weekly-If-Tag-Patching-Weekly

![tag patch](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/tag_patch.png)

Why this handles "Many Resource Groups" perfectly:

- Scope: By calling Get-AzVM without the -ResourceGroupName parameter, PowerShell asks Azure for a list of every VM in the subscription.

- Filtering: It then looks at the Tags of every VM. Only the ones you’ve specifically marked for the dev team (Patching: Weekly) will be touched.

- Dynamic Reference: When the script runs the Start or Stop commands, it uses $vm.ResourceGroupName. This means it automatically knows which "folder" each VM lives in, even if they are all in different ones.


Script

```ps1
s_runbook2_patching_vm_many_weekly_tag_linux.ps1

```

1. Publish the Runbook

Your script currently exists in a "Draft" state because you've been using the Test Pane. For the Schedule to execute the code, it must be published.

- Close the Test Pane.

- Click the Edit button (if not already in edit mode).

- Click the Publish button at the top of the screen.

- Select Yes when asked to override the previous version.

![publsihed](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/published.png)

2. Link the Schedule

- Now that the "Official" version is published, you need to tell Azure when to run it.

- On the Runbook's main menu, select Schedules.

- Click + Add a schedule.

- Choose Link a schedule to your runbook.

- Select your Monday 09:00 AM schedule.

- Important: Check that the Time Zone in your schedule matches your actual local time, as Azure often defaults to UTC.

![schedule](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/schedule.png)

View your schedule at the runbook.

![view schedule](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/view_time.png)


### Trigger runbook

You could edit or trigger it.

![trigger runbook](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/trigger_runbook.png)

Logs

![trigger log](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/trigger_log.png)


### Azure Automation Costs

Azure provides the first 500 minutes of job execution time for free every month.

- Your usage: 4 VMs × ~5 minutes per run = 20 minutes per week.

- Monthly total: ~80 minutes per month.

- Remaining Free Tier: You still have 420 minutes left over each month.

Simplify cloud management with process automation

A node is any machine whose configuration is managed by configuration management. 

This could be an Azure virtual machine (VM), on-premises VM, physical host, or a VM in another public cloud.

* Job runtime, each month 500 minutes, price after that $0.002/minute
* Watchers, each month 744 hours, price after that $0.002/hour
* Azure nodes N/A, price free
* Non-Azure nodes 5 nodes, price after $6/node 

https://azure.microsoft.com/en-us/pricing/details/automation/


### How reboot is handled

Since we run runbook with startvm, update vm, make log on vm, deallocated vm, the next time you log on is a boot—but only if you "Deallocated" correctly.

Script runs Stop-AzVM, it moves the VM into a Deallocated state. This means Azure physically unbinds your VM from the hardware rack it was running on.

* When you (or the script) run Start-AzVM the following Monday:
* (Whether you use your script, the PowerShell command, or simply click the Start button in the Azure Portal, the result is the same: A cold boot that applies your updates.)

* Azure finds a fresh piece of hardware.

* The VM goes through a full Hardware Boot sequence.

* The Linux bootloader (GRUB) initializes and automatically picks the newest kernel found on the disk (the one your script just installed).

Result: Your updates are applied perfectly. For Linux, a "Start" after "Deallocation" is as good as a "Reboot."


### Executive Summary: Automated Infrastructure Maintenance

Benefit Category,Impact of Automation

💰 Cost Reduction,"Significant Savings. By automatically deallocating (shutting down) VMs immediately after patching, we eliminate wasted spend on idle resources. We only pay for the ~10 minutes required for the update rather than 24/7 uptime."

🛡️ Security Posture,"Reduced Vulnerability Window. Security patches (Kernel and OS) are applied every Monday morning without fail, ensuring compliance with security best practices and reducing the risk of exploitation."

⚙️ Operational Efficiency,"Focus on Strategy. IT staff no longer spend time manually logging into servers to run apt-upgrade. This saves hours of manual labor per month, allowing the team to focus on high-value projects."

📉 Risk Mitigation,"Elimination of Human Error. The script follows an exact, repeatable logic. It removes the risk of typos, missed steps, or forgotten shutdowns that occur during manual maintenance."

Technical Highlights

* Cold-Boot Integrity: The script utilizes a "Stop-and-Start" cycle. This ensures that every Monday, the VMs perform a fresh hardware boot, which automatically clears temp files and loads the latest security kernel without manual intervention.

* Centralized Control: All maintenance logs are stored in a single Azure Automation dashboard, providing a clear audit trail of exactly what was updated and when.

* Scalability: The framework is designed to automatically detect and include new VMs based on simple "Tags," allowing our infrastructure to grow without increasing administrative overhead.


### Job status or health check

1. The "Big Picture" (Job Status)

- Go to your Automation Account > Jobs (under Process Automation).

- Look for: A job with the status "Completed" at ~09:10 AM.

- Warning Signs: If it says "Failed," click the job to see the specific error line. If it says "Suspended," it usually means a permission (RBAC) issue.

![job done](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/job_done.png)


2. The "Receipts" (Output Stream)
Even if the job "Completed," you want to verify that the VMs actually updated.

- Click on the "Completed" job from Step 1.

- Click the Output tab at the top.

- What to look for: Look for the text from your Bash script. You should see:

``` log
0 upgraded, 0 newly installed... (if already patched).
Fetched XX.X MB in 2s... (if updates were found).
"No reboot required" or "Rebooting now..."
```

![job output](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook-and-choices/images/job_output.png)

3. Check script

```bash
ssh

ls *apt-main*
# apt-maintenance-2026-01-31.log

cat apt-maintenance-2026-01-31.log
``` 

log

```log
Maintenance Started: Sat Jan 31 01:20:23 UTC 2026 ---
Hit:1 http://azure.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://azure.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:3 http://azure.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://azure.archive.ubuntu.com/ubuntu noble-security InRelease
Hit:5 https://download.docker.com/linux/ubuntu noble InRelease
Hit:6 https://repo.zabbix.com/zabbix-tools/debian-ubuntu noble InRelease
Hit:7 https://repo.zabbix.com/zabbix/7.0/ubuntu noble InRelease
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
Calculating upgrade...
The following upgrades have been deferred due to phasing:
  fwupd libdrm-common libdrm2 libfwupd2 python3-distupgrade
  ubuntu-release-upgrader-core
0 upgraded, 0 newly installed, 0 to remove and 6 not upgraded.
Maintenance Finished: Sat Jan 31 01:20:34 UTC 2026 
```
### Automatic Module Updates TODO

In Azure Automation, your Runbook is just the script (the "logic"). For that script to actually understand commands like Start-AzVM or Get-AzContext, it needs Modules (the "dictionary").

Automatic Module Updates is a feature that ensures your Automation Account is always using the latest, most secure version of these "dictionaries" without you having to manually update them every month.

Currently, updating AZ modules is only available through the portal. Updates through PowerShell and ARM template will be available in the future. Only default Az modules will be updated when performing the following steps:

1. Sign in to the Azure portal and navigate to your Automation account.
2. Under Shared Resources, select Modules.
3. Select Update Az modules.
4. Select Module to Update. By default, it will show Az module.
5. From the drop-down list, select Module Version and Runtype version
6. Select Update to update the Az module to the version that you’ve selected. On the Modules page, you can view the list as shown below:


https://learn.microsoft.com/en-us/azure/automation/automation-update-azure-modules



### Alert TODO
Set up a "Failure" Alert (The Watchdog)
Since the script is now "set and forget," you should set up an alert so you are notified if it fails to run (e.g., due to an Azure service outage or an expired credential).

- Go to Monitor > Alerts in the Azure Portal.

- Create a New Alert Rule.

- Set the Signal to "Job Status" or "Total Jobs" where the status is Failed.

- Set the Action Group to your email or phone number.

https://learn.microsoft.com/en-us/azure/automation/automation-alert-metric

