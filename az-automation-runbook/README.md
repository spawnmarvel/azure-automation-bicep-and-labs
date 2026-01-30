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

Start vmchaos09

```ps1
# # Sign in to your Azure subscription
$t_id = "tenant-id"
Connect-AzAccount -Tenant $t_id


$resourceGroup = "Rg-ukautomation-0001"
# These values are used in this tutorial
$automationAccount = "jeklautomation"
$userAssignedManagedIdentity = "jeklmanagedidentity"

```


System-Assigned (The "Simple" Path)
How it works: You turn it on directly inside the jeklautomation account. Azure creates an identity with the exact same name as your Automation account.

Pros: It’s "set it and forget it." If you delete the Automation account, the identity vanishes too. No leftover "orphan" resources.

Cons: It only lives on that one Automation account. If you create a second Automation account later for a different project, you have to set up permissions all over again for the new one.

2. User-Assigned (The "Enterprise" Path) — What you have now
How it works: Your jeklmanagedidentity is a standalone resource. You "plug" it into your Automation account.

Pros: Reusability. If you later decide to use a Logic App or a Function to handle other dev tasks, you can give them the same jeklmanagedidentity. You manage the "Dev Permissions" once, and assign that identity to whatever tools need it.

Cons: You have to manually delete it if you ever stop using it, and the script requires that ClientId we talked about.

https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity

## Automation PowerShell runbook for linux updates

- Run on schedule once a week
- Start vm
- Run updates
- Log to file on vm
- Stop vm
