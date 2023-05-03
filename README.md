# Azure Automation

## Continued from

1. azure-arm-104 https://github.com/spawnmarvel/azure-arm-104
2. Azure Administrator Cheat Sheet https://github.com/spawnmarvel/quickguides/tree/main/azure
3. Azure Administrator Cheat Sheet quick guide https://github.com/spawnmarvel/quickguides/tree/main/azure/quick-guide

##  Azure Automation as Microsoft Certified: Azure Administrator Associate

According to Microsoft https://learn.microsoft.com/en-us/certifications/azure-administrator/

* Candidates for the Azure Administrator Associate certification should have subject matter expertise in implementing, managing, and monitoring an organization’s Microsoft Azure environment, including virtual networks, storage, compute, identity, security, and governance.

* An Azure administrator often serves as part of a larger team dedicated to implementing an organization's cloud infrastructure. 

* Azure administrators also coordinate with other roles to deliver Azure networking, security, database, application development, and DevOps solutions.

* Candidates for this certification should be familiar with operating systems, networking, servers, and virtualization. In addition, professionals in this role should have experience using PowerShell, Azure CLI, the Azure portal, Azure Resource Manager templates (ARM templates), and Microsoft Azure Active Directory (Azure AD), part of Microsoft Entra.

## Microsoft Certified: Azure Administrator Associate

Yea, finally passed AZ 104 Microsoft Azure Administrator and earned the title Microsoft Certified: Azure Administrator Associate.


https://www.credly.com/badges/6576b809-9a24-41ff-80bf-f52aab150a49/public_url


What now..... 

### Focus on

#### 1. Compute

   * The Azure Administrator is most often identified with infrastructure-as-a-service (IaaS), which normally boils down to running virtual machines (VMs) in the cloud.
   * Containers represent a newer way to virtualize services, and Docker is extremely well-represented in Azure.

#### 2. Storage

   * Azure provides Administrators with essentially limitless storage. You need space to store VM virtual hard disks (VHDs), database files, application data, and potentially user data.
   * Cloud computing’s shared responsibility model.
   * Securing data against unauthorized access.
   * Backing up data and making it efficient to restore when needed.

#### 3. Network

   * Deploying and configuring virtual networks
   * Managing public and private IP addresses for your VMs and selected other Azure resources

####  4. Security

   * The security stakes are high in the Azure public cloud because your business stores its proprietary data on someone else’s infrastructure.
   * Encrypting data in transit, at rest, and in use.
   * Protecting Azure Active Directory accounts against compromise
   * Reducing the attack surface of all your Azure resources

####  5. Monitor

   * Azure Monitor Insights overview
   * https://learn.microsoft.com/en-us/azure/azure-monitor/insights/insights-overview
   * Application insight
   * Container insight
   * VM insights
   * Network insights


####  6. Bone up on your PowerShell / Cli and JavaScript Object Notation, (ARM and BICEP).

   * Unlike most of the Azure training and labs, relatively-little day-to-day work takes place within the web console.



## Azure PowerShell Documentation

https://learn.microsoft.com/en-us/powershell/azure/?view=azps-9.6.0


```
# After installed Az module

# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1
# Connect as user with mfa

Connect-AzAccount  [-Tenant <String>] [...]

# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.7.1
# Connect as function user, ad user from a vm after installed az module

$Credential = Get-Credential
Connect-AzAccount -Credential $Credential
```

![Credential ](https://github.com/spawnmarvel/azure-automation/blob/main/images/ps1_credential.jpg)

## Azure Command-Line Interface (CLI) documentation

https://learn.microsoft.com/en-us/cli/azure/


## Azure automation

https://github.com/spawnmarvel/azure-automation/tree/main/azure-automation-glasspaper

#### Azure Portal, check out stuff in preview.

#### Cloud shell (a bit buggy but ok), store scripts and files in the fileshare.

#### 1. Bicep

If you're considering infrastructure as code options, Bicep.

#### 1.1 Template specs

A template spec is a resource type for storing an Azure Resource Manager template (ARM template) in Azure for later deployment. 


#### 2. Blueprints

Azure Blueprints enables cloud architects and central information technology groups to define a repeatable set of Azure resources that implements and adheres to an organization's standards, patterns, and requirements.

#### 3. Automation runbook

Process automation in Azure Automation allows you to create and manage PowerShell, PowerShell Workflow, and graphical runbooks.


#### 4 Automation Accounts
Automation is needed in three broad areas of cloud operations:
* Deploy and manage - Deliver repeatable and consistent infrastructure as code.
* Response - Create event-based automation to diagnose and resolve issues.
* Orchestrate - Orchestrate and integrate your automation with other Azure or third party services and products.
* https://learn.microsoft.com/en-us/azure/automation/overview
* DSC will soon be auto manage
* Update management, install monitoring extenions to windows and linux
* Runbook is a script you can run in Azure (Powershell or Python, Yea!)
* Edit Powershell Runbook, modules, cmdlets.
* Test it in portal an run it.
* Hybrid worker can be outside of Azure, if agent from Azure is installed.


#### 5. Azure functions (alternative to Automation Account, why use Automation, functions are more for dev, but not necessarily infrastructure, but processing data)

Azure Functions is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs.

| If you want to | Then...
| -------------- | -------
| Build a web API |	Implement an endpoint for your web applications using the HTTP trigger
| Process file uploads |	Run code when a file is uploaded or changed in blob storage
| Build a serverless workflow |	Create an event-driven workflow from a series of functions using durable functions
| Respond to database changes |	Run custom logic when a document is created or updated in Azure Cosmos DB
| Run scheduled tasks |	Execute code on pre-defined timed intervals
| Create reliable message queue systems |	Process message queues using Queue Storage, Service Bus, or Event Hubs
| Analyze IoT data streams |	Collect and process data from IoT devices
| Process data in real time	| Use Functions and SignalR to respond to data in the moment
| Connect to a SQL database	| Use SQL bindings to read or write data from Azure SQL

#### 6. Low code option
Azure Logic Apps is a cloud platform where you can create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, you can quickly build a workflow that integrates and manages your apps, data, services, and systems.
* Schedule and send email notifications
* Route and process customer orders across on-premises systems and cloud services.
* Move uploaded files from an SFTP or FTP server to Azure Storage.

#### 7. Auto manage


## Do above 1-7 after that work with the important parts again

### Compute, Storage, Network, Security, Monitor and more Powershell








