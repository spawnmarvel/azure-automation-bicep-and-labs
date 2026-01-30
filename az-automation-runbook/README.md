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

https://learn.microsoft.com/en-us/azure/automation/quickstarts/enable-managed-identity

## Tutorial: Create Automation PowerShell runbook using managed identity

Start vmchaos09




https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity

## Automation PowerShell runbook for linux updates

- Run on schedule once a week
- Start vm
- Run updates
- Log to file on vm
- Stop vm
