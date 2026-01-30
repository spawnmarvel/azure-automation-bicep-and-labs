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


#### The Final Production Runbook for one vm

```ps1
# =================================================================================
# 1. HARDCODED SETTINGS (Replace these with your actual IDs)
# =================================================================================
$ClientId       = "00000000-0000-0000-0000-000000000000" # From jeklmanagedidentity
$TenantId       = "00000000-0000-0000-0000-000000000000" # From Default Directory Overview
$SubscriptionId = "00000000-0000-0000-0000-000000000000" # Your Subscription ID
$ResourceGroup  = "jekl-dev-rg"                          # The RG containing your VMs

# =================================================================================
# 2. DISCOVERY LOGGING (Per your request: Verifies IDs in the logs)
# =================================================================================
Write-Output "--- Discovery Log ---"
$automationAccountName = "jeklautomation"
try {
    $aa = Get-AzAutomationAccount -ResourceGroupName $ResourceGroup -Name $automationAccountName
    $UAMI_PrincipalId = $aa.Identity.UserAssignedIdentities.Values.PrincipalId
    $uami = Get-AzUserAssignedIdentity | Where-Object { $_.PrincipalId -eq $UAMI_PrincipalId }

    Write-Output "Detected ClientId: $($uami.ClientId)"
    Write-Output "Detected TenantId: $((Get-AzContext).Tenant.Id)"
} catch {
    Write-Output "Discovery info: Identity lookup skipped or failed. Using hardcoded IDs."
}
Write-Output "--------------------"

# =================================================================================
# 3. AUTHENTICATION
# =================================================================================
Write-Output "Attempting connection for jeklmanagedidentity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId

# =================================================================================
# 4. VM MAINTENANCE LOGIC
# =================================================================================

# We target VMs with the tag 'Patching: Weekly'
$targetVMs = Get-AzVM -ResourceGroupName $ResourceGroup | Where-Object { $_.Tags['Patching'] -eq 'Weekly' }

if ($null -eq $targetVMs -or $targetVMs.Count -eq 0) {
    Write-Warning "No VMs found with tag 'Patching: Weekly'. Please check your VM tags."
    return
}

Write-Output "SUCCESS: Found $($targetVMs.Count) VMs to process."

# START PHASE (Parallel)
foreach ($vm in $targetVMs) {
    Write-Output "Starting VM: $($vm.Name)..."
    Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -NoWait
}

Write-Output "Waiting 90 seconds for OS and VM Agents to initialize..."
Start-Sleep -Seconds 90

# UPDATE SCRIPT (Dated Logs)
$BashScript = @"
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-\$LOG_DATE.log"
echo "--- Maintenance Started: $(date) ---" > \$LOG_FILE
sudo apt-get update -y >> \$LOG_FILE 2>&1
sudo apt-get upgrade -y >> \$LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> \$LOG_FILE
"@

# EXECUTE PHASE
foreach ($vm in $targetVMs) {
    Write-Output "Executing updates on $($vm.Name)..."
    try {
        Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
                              -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
        Write-Output "Update successful for $($vm.Name)."
    }
    catch {
        Write-Error "Failed to update $($vm.Name): $($_.Exception.Message)"
    }

    # STOP PHASE (Deallocate)
    Write-Output "Deallocating $($vm.Name) to stop billing..."
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
}

Write-Output "Monday Maintenance Sequence Complete."
```

#### The Final Production Runbookfor all vms with tag

Why this handles "Many Resource Groups" perfectly:

- Scope: By calling Get-AzVM without the -ResourceGroupName parameter, PowerShell asks Azure for a list of every VM in the subscription.

- Filtering: It then looks at the Tags of every VM. Only the ones you’ve specifically marked for the dev team (Patching: Weekly) will be touched.

- Dynamic Reference: When the script runs the Start or Stop commands, it uses $vm.ResourceGroupName. This means it automatically knows which "folder" each VM lives in, even if they are all in different ones.

```ps1
# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId       = "00000000-0000-0000-0000-000000000000" # From jeklmanagedidentity
$TenantId       = "00000000-0000-0000-0000-000000000000" # From Default Directory Overview
$SubscriptionId = "00000000-0000-0000-0000-000000000000" # Your Subscription ID

# =================================================================================
# 2. DISCOVERY LOGGING (Verifies IDs in the Runbook Output)
# =================================================================================
Write-Output "--- Discovery Log ---"
try {
    # We use Get-AzContext here because it's faster inside the Runbook environment
    $currentContext = Get-AzContext
    Write-Output "Executing in Tenant: $($currentContext.Tenant.Id)"
    Write-Output "Executing in Subscription: $($currentContext.Subscription.Name)"
} catch {
    Write-Output "Context discovery failed. Proceeding with hardcoded IDs."
}
Write-Output "--------------------"

# =================================================================================
# 3. AUTHENTICATION
# =================================================================================
Write-Output "Connecting via jeklmanagedidentity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId

# =================================================================================
# 4. GLOBAL VM DISCOVERY (Across ALL Resource Groups)
# =================================================================================

# Removing -ResourceGroupName allows Get-AzVM to scan the entire Subscription
Write-Output "Scanning all Resource Groups for VMs with tag 'Patching: Weekly'..."
$targetVMs = Get-AzVM | Where-Object { $_.Tags['Patching'] -eq 'Weekly' }

if ($null -eq $targetVMs -or $targetVMs.Count -eq 0) {
    Write-Warning "No VMs found with the required tag. Ensure VMs have Patching=Weekly."
    return
}

Write-Output "SUCCESS: Found $($targetVMs.Count) VMs across your Resource Groups."

# =================================================================================
# 5. EXECUTION PHASE (Start -> Update -> Stop)
# =================================================================================

# Step A: Parallel Start
foreach ($vm in $targetVMs) {
    Write-Output "Starting VM: $($vm.Name) [RG: $($vm.ResourceGroupName)]"
    Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -NoWait
}

Write-Output "Waiting 90 seconds for initialization..."
Start-Sleep -Seconds 90

# Step B: Update via Bash Script
$BashScript = @"
LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-\$LOG_DATE.log"
echo "--- Maintenance Started: $(date) ---" > \$LOG_FILE
sudo apt-get update -y >> \$LOG_FILE 2>&1
sudo apt-get upgrade -y >> \$LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> \$LOG_FILE
"@

foreach ($vm in $targetVMs) {
    Write-Output "Updating $($vm.Name)..."
    try {
        Invoke-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
                              -CommandId 'RunShellScript' -ScriptString $BashScript -ErrorAction Stop
        Write-Output "Success: $($vm.Name) updated."
    }
    catch {
        Write-Error "Failed to update $($vm.Name): $($_.Exception.Message)"
    }

    # Step C: Deallocate
    Write-Output "Deallocating $($vm.Name)..."
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force -NoWait
}

Write-Output "Maintenance Sequence Complete."
```