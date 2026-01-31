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


![account](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/account.png)


https://learn.microsoft.com/en-us/azure/automation/quickstarts/create-azure-automation-account-portal

### Create a user-assigned managed identity

- In the search box, enter Managed Identities. Under Services, select Managed Identities.

![managed identity](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/mi.png)

https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal?pivots=identity-mi-methods-azp#create-a-user-assigned-managed-identity

### Enable managed identities for your Automation account using the Azure portal

- An Azure account with an active subscription
- An Azure Automation account
- A user-assigned managed identity.

![system assignd was on](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/mi_on.png)

Your Automation account can now use the system-assigned identity, that is registered with Microsoft Entra ID and is represented by an object ID.


Add user-assigned managed identity

- Select the User assigned tab, and then select + Add or Add user assigned managed identity to open the Add user assigned managed i... page.
- Under User assigned managed identities, select your existing user-assigned managed identity and then select Add. You'll then be returned to the User assigned tab.


![mi_add_user_assigned](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/mi_add_user_assigned.png)


https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity


## Tutorial: Create Automation PowerShell runbook using managed identity


https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity

1. System-Assigned (The "Simple" Path)

- How it works: You turn it on directly inside the jeklautomation account. Azure creates an identity with the exact same name as your Automation account.

- Pros: It’s "set it and forget it." If you delete the Automation account, the identity vanishes too. No leftover "orphan" resources.

- Cons: It only lives on that one Automation account. If you create a second Automation account later for a different project, you have to set up permissions all over again for the new one.

2. User-Assigned (The "Enterprise" Path) — What you have now


 How it works: Your jeklmanagedidentity is a standalone resource. You "plug" it into your Automation account.

- Pros: Reusability. If you later decide to use a Logic App or a Function to handle other dev tasks, you can give them the same jeklmanagedidentity. You manage the "Dev Permissions" once, and assign that identity to whatever tools need it.

- Cons: You have to manually delete it if you ever stop using it, and the script requires that ClientId we talked about.


Which should you choose?

Recommendation: Since you've already created jeklmanagedidentity, stick with it. It’s better practice for "Infrastructure as Code" and keeps your permissions centralized under one "Dev Identity" rather than tying them strictly to the tool (Automation Account).


## Automation PowerShell runbook for linux updates

- Run on schedule once a week
- Start vm
- Run updates
- Log to file on vm
- Stop vm


Managed Identities do not work on local machines. They only exist "inside" the Azure infrastructure.


Step 1: Create the Runbook

1. In the Azure Portal, go to your jeklautomation Automation Account.

2. On the left menu, select Runbooks (under Process Automation).

3. Click + Create a runbook.

4. Name: Update-Dev-VMs-Weekly

5. Runbook type: PowerShell

6. Runtime version: 7.2 (the latest stable version).

7. Click Create.

![runbook](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/RUNBOOK.png)

Check your RBAC

1. Go to your Subscription (not just the RG).

2. Access Control (IAM).

3. Ensure jeklmanagedidentity has at least Reader at the Subscription level, or Contributor at the Resource Group level.

![add reader](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/add_reader.png)

Step 2: To use the Identity you created, you must run the code inside the Automation Account's Test Pane:

The "Dry Run" Connection Script:

1. Go to the Azure Portal.

2. Navigate to your Automation Account jeklautomation > Runbooks.

3. Open your Runbook and click Edit.

4. Click on the Test pane button.

5. Paste your code there and click Start.

#### Connect and test
```ps1
# 1. Provide your specific IDs
$ClientId = "xxxxxxxxxxxxxxxxxxxx"        # From jeklmanagedidentity
$TenantId = "xxxxxxxxxxxxxxxxxxxxxxxx"    
$SubscriptionId = "xxxxxxxxxxxxxxxxxxx"     # Your Subscription ID

Write-Output "Attempting connection for jeklmanagedidentity..."

# 2. Connect with ALL parameters to avoid 'null' context
# Adding -TenantId and -SubscriptionId here forces the session to bind correctly
Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

# 3. Explicitly set the context (The 'Double-Check')
Set-AzContext -SubscriptionId $SubscriptionId

# 4. Verify we can see the VMs
$vms = Get-AzVM
if ($vms.Count -gt 0) {
    Write-Output "SUCCESS: Found $($vms.Count) VMs."
} else {
    Write-Warning "Connected, but no VMs found in this subscription. Check Resource Group permissions."
}

```
result

![test ps1](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/test_ps1.png)

One Final Requirement:

Your jeklmanagedidentity needs the Virtual Machine Contributor role.

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
$uamiName = "jeklmanagedidentity"
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

#### The Final Production Runbook for one vm

Create a new runbook, Update-Dev-VMs-Weekly-test1-vm

If the vm is running it should not be updated, because someone could be working on it.


Script

```ps1
# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "YOUR-CLIENT-ID" 
$TenantId       = "YOUR-TENANT-ID" 
$SubscriptionId = "YOUR-SUB-ID" 

# Target VM for testing
$TestVMName     = "vmchaos09" 
$TestRG         = "RG-UKCHAOS-0009"

# =================================================================================
# 2. AUTHENTICATION
# =================================================================================
Write-Output "Connecting to Azure via Managed Identity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId | Out-Null

# =================================================================================
# 3. POWER STATE VERIFICATION
# =================================================================================
Write-Output "Checking power state for $TestVMName..."

$vmStatus = Get-AzVM -ResourceGroupName $TestRG -Name $TestVMName -Status
$displayStatus = ($vmStatus.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus

Write-Output "Current status: $displayStatus"

# Safety Gate: Skip if the VM is already running (someone might be using it)
if ($displayStatus -ne "VM deallocated") {
    Write-Warning "SKIPPING: Maintenance aborted because VM is not in a deallocated state."
    return 
}

# =================================================================================
# 4. START SEQUENCE
# =================================================================================
Write-Output "VM is idle. Booting $TestVMName for maintenance..."

Start-AzVM -ResourceGroupName $TestRG -Name $TestVMName -ErrorAction Stop

# Wait for the Azure Guest Agent to pulse (crucial for RunCommand)
Write-Output "Waiting 90 seconds for Guest Agent to become Ready..."
Start-Sleep -Seconds 90

# =================================================================================
# 5. MAINTENANCE EXECUTION (BASH)
# =================================================================================
# Note: Using single-quote here-string to prevent PowerShell from parsing $ variables
$BashScript = @'
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

# Output the last few lines of the log so they appear in the Runbook output
tail -n 5 $LOG_FILE
'@

Write-Output "Executing apt-get update and upgrade..."

try {
    $result = Invoke-AzVMRunCommand -ResourceGroupName $TestRG -VMName $TestVMName `
                                    -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
    
    # Display the Bash output in the Automation Job logs
    Write-Output "Bash Output: $($result.Value[0].Message)"
    Write-Output "SUCCESS: Maintenance script completed on $TestVMName."
}
catch {
    Write-Error "FAILURE: Maintenance command failed on $TestVMName. Error: $($_.Exception.Message)"
}

# =================================================================================
# 6. SHUTDOWN & DEALLOCATE
# =================================================================================
Write-Output "Maintenance finished. Deallocating $TestVMName to stop billing..."

Stop-AzVM -ResourceGroupName $TestRG -Name $TestVMName -Force -NoWait

Write-Output "Runbook execution finished."


```


Test when VM is running success

![test ps1 vm running](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/vm_running.png)

Test when VM is not running success

![test ps1 vm not running](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/vm_stopped.png)

#### The Final Production Runbookfor all vms with tag Patching:Weekly

Create Runbook Update-VMs-Weekly-If-Tag-Patching-Weekly

![tag patch](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/tag_patch.png)

Why this handles "Many Resource Groups" perfectly:

- Scope: By calling Get-AzVM without the -ResourceGroupName parameter, PowerShell asks Azure for a list of every VM in the subscription.

- Filtering: It then looks at the Tags of every VM. Only the ones you’ve specifically marked for the dev team (Patching: Weekly) will be touched.

- Dynamic Reference: When the script runs the Start or Stop commands, it uses $vm.ResourceGroupName. This means it automatically knows which "folder" each VM lives in, even if they are all in different ones.


Script

```ps1

# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "YOUR-CLIENT-ID" 
$TenantId       = "YOUR-TENANT-ID" 
$SubscriptionId = "YOUR-SUB-ID" 

# =================================================================================
# 2. AUTHENTICATION
# =================================================================================
Write-Output "Connecting to Azure via Managed Identity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId | Out-Null

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

# =================================================================================
# 4. POWER STATE VERIFICATION & START (Parallel)
# =================================================================================
$vmsToUpdate = @()

foreach ($vm in $targetVMs) {
    # Get real-time status (requires the -Status flag)
    $statusInfo = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    $displayStatus = ($statusInfo.Statuses | Where-Object { $_.Code -like "PowerState/*" }).DisplayStatus
    
    # SAFETY CHECK: Only start if Deallocated (Someone might be working if it's Running)
    if ($displayStatus -eq "VM deallocated") {
        Write-Output "Starting $($vm.Name) in RG: $($vm.ResourceGroupName) [Current: $displayStatus]..."
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -NoWait
        $vmsToUpdate += $vm
    } else {
        Write-Warning "SKIPPING $($vm.Name): Status is '$displayStatus'. Will not interrupt active session."
    }
}

if ($vmsToUpdate.Count -eq 0) {
    Write-Output "No deallocated VMs found for patching. Execution finished."
    return
}

Write-Output "Waiting 90 seconds for Linux Agents to become Ready..."
Start-Sleep -Seconds 90

# =================================================================================
# 5. MAINTENANCE EXECUTION (BASH)
# =================================================================================
# Using single-quote here-string to ensure Bash variables are passed correctly
$BashScript = @'
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get upgrade -y >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

tail -n 5 $LOG_FILE
'@

foreach ($vm in $vmsToUpdate) {
    Write-Output "Executing updates on $($vm.Name)..."
    try {
        $result = Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
                                        -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
        
        Write-Output "[$($vm.Name)] Bash Output: $($result.Value[0].Message)"
    }
    catch {
        Write-Error "FAILURE: Maintenance command failed on $($vm.Name). Error: $($_.Exception.Message)"
    }

    # =================================================================================
    # 6. SHUTDOWN & DEALLOCATE
    # =================================================================================
    Write-Output "Deallocating $($vm.Name) to save costs..."
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
}

Write-Output "Global Weekly Maintenance Sequence Complete."

# =================================================================================
# 7. FINAL SUMMARY
# =================================================================================
Write-Output "----------------------------------------------"
Write-Output "FINAL MAINTENANCE SUMMARY"
Write-Output "Total VMs Found: $($targetVMs.Count)"
Write-Output "Total VMs Processed: $($vmsToUpdate.Count)"
Write-Output "----------------------------------------------"
Write-Output "Global Weekly Maintenance Sequence Complete."
```

1. Publish the Runbook

Your script currently exists in a "Draft" state because you've been using the Test Pane. For the Schedule to execute the code, it must be published.

- Close the Test Pane.

- Click the Edit button (if not already in edit mode).

- Click the Publish button at the top of the screen.

- Select Yes when asked to override the previous version.

2. Link the Schedule

- Now that the "Official" version is published, you need to tell Azure when to run it.

- On the Runbook's main menu, select Schedules.

- Click + Add a schedule.

- Choose Link a schedule to your runbook.

- Select your Monday 09:00 AM schedule.

- Important: Check that the Time Zone in your schedule matches your actual local time, as Azure often defaults to UTC.

![schedule](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-automation-runbook/images/schedule.png)
