# Azure Automation Glasspaper

## Automating Azure (glasspaper 2023 Paul "Dash" Wojcicki-Jarocki)

Make our life easier in Azure. Explorer Powershell and where it fits in, main topic is Automation accounts.

#### 1. Azure Portal, check out stuff in preview.

![Preview things ](https://github.com/spawnmarvel/azure-automation/blob/main/images/preview.jpg)

####  2. Cloud shell (a bit buggy but ok), store scripts and files in the fileshare.
*  Disable Predictive Intellisens and Save autentication token (could need it later)
```
PS /home/espen/clouddrive> code $PROFILE.CurrentUserAllHosts

# Edit the profile.ps1
# profile.ps1 for use in Azure Cloud Shell

# Disable Predictive Intellisens
Set-PSReadLineOption -PredictiveSource None -BellStyle Visual

# Save autentication token
$AUTH = Invoke-RestMethod -Uri "env:MSI_ENDPOINT`?resource=https://management.core.windows.net/" -Headers @{Metadata = 'true'}
```

Shell and files

![Cloud shell ](https://github.com/spawnmarvel/azure-automation/blob/main/images/cloudshell.jpg)

####  3. Scripts, ARM templates, Bicep
* ARM templates
* https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview

* Some limitiations of scripts:
* * Many collaborators and different styles
* * Have to have the correct modules (have to keep track of versions etc)
* * Current modules starts with Az: Get-AzContext | Select-Object Account, Name
* * Template JSON files, template and parameter.json
* * Custom script extensions 

```

# parameters.json

{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "customName": {
            "value": "testtutorial"
        },
        "storageSKU": {
            "value": "Standard_LRS"
          },
        "location": {
            "value": "westeurope"
        },
        "resourceTags": {
            "value": {
              "Environment": "Test",
              "Project": "Tutorial"
            }
          }
        
    }
}

# template.json (Not complete file just for logic)

    // your api reference
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    // your version
    "contentVersion": "1.0.0.0",
    "parameters": {

        "customName": {
            // a custom paramter
            "type": "string",
            "metadata" :{
                "description": "a description"
            }
        },

         "location": {
            "type": "string",
            // a function call
            "defaultValue": "[resourceGroup().location]",

    "variables": {
        // a var
        "customNameUnique": "[concat(parameters('customName'),uniqueString(resourceGroup().id))]"

    "functions": [],
    "resources": [
        // 1 resource
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2021-04-01",
            // var used
            "name": "[variables('customNameUnique')]",
            "location": "[parameters('location')]",
            "tags": "[parameters('resourceTags')]",

            "dependsOn": [],

            "sku": {
                "name": "[parameters('storageSKU')]"
            },

            "kind": "StorageV2",

    "outputs": {
        //
            "storageEndpoint": {
                "type": "object",
                "value": "[reference(variables('customNameUnique')).primaryEndpoints]"
            }
        //


```

The newer version of this is Bicep
* Another txt file.bicep with simpler syntax, more readble.
* MS is investing much in this 2023.
* Bicep gets translated to json ARM.

```
# https://learn.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroupdeployment?view=azps-9.6.0

New-AzResourceGroupDeployment
   [-Name <String>]
   -ResourceGroupName <String>
   [-Mode <DeploymentMode>]
   [-DeploymentDebugLogLevel <String>]
   [-RollbackToLastDeployment]
   [-RollBackDeploymentName <String>]
   [-Tag <Hashtable>]
   [-WhatIfResultFormat <WhatIfResultFormat>]
   [-WhatIfExcludeChangeType <String[]>]
   [-Force]
   [-ProceedIfNoChange]
   [-AsJob]
   [-QueryString <String>]
   -TemplateFile <String>
   [-SkipTemplateParameterPrompt]
   [-Pre]
   [-DefaultProfile <IAzureContextContainer>]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]


```

#### 3. 1 Template specs
* A template spec is a resource type for storing an Azure Resource Manager template (ARM template) in Azure for later deployment. 
* This resource type enables you to share ARM templates with other users in your organization.
* https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell

![Template spec ](https://github.com/spawnmarvel/azure-automation/blob/main/images/template-spec.jpg)

View deployments in RG:

![View deployments ](https://github.com/spawnmarvel/azure-automation/blob/main/images/deployments.jpg)

Use or view template that was deployed

![Reuse template ](https://github.com/spawnmarvel/azure-automation/blob/main/images/reuse-template.jpg)


####  4. Blueprints
* Makes sense with templates
* https://learn.microsoft.com/en-us/azure/governance/blueprints/overview
* Azure Blueprints enables cloud architects and central information technology groups to define a repeatable set of Azure resources that implements and adheres to an organization's standards, patterns, and requirements.
* Deploy the resource group also (can do it with extra Powershell and ARM:)
```

$rgName = "az104-06-rg1-682093"

New-AzResourceGroup -Name $rgName -Location "west europe" [-Tag <Hashtable>] [...]  [-WhatIf] [...] -Force 

New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile .\az104-06-vms-loop-template.json -TemplateParameterFile .\az104-06-vms-loop-parameters.json -WhatIf

```
* How it's different from ARM templates?
* The service is designed to help with environment setup. This setup often consists of a set of resource groups, policies, role assignments, and ARM template deployments. A blueprint is a package to bring each of these artifact types together and allow you to compose and version that package, including through a continuous integration and continuous delivery (CI/CD) pipeline. 
* How it's different from Azure Policy?
* A blueprint is a package or container for composing focus-specific sets of standards, patterns, and requirements related to the implementation of Azure cloud services, security, and design that can be reused to maintain consistency and compliance.

#### 5. Automation runbook
* Process automation in Azure Automation allows you to create and manage PowerShell, PowerShell Workflow, and graphical runbooks.
* Automation executes your runbooks based on the logic defined inside them.
* Starting a runbook in Azure Automation creates a job, which is a single execution instance of the runbook.
* The Azure Automation Process Automation feature supports several types of runbooks (ps1, py, graphical)
* https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps51%2Cpy27

#### 5. 1 Automation Accounts
* Automation is needed in three broad areas of cloud operations:
* * Deploy and manage - Deliver repeatable and consistent infrastructure as code.
* * Response - Create event-based automation to diagnose and resolve issues.
* * Orchestrate - Orchestrate and integrate your automation with other Azure or third party services and products.
* https://learn.microsoft.com/en-us/azure/automation/overview
* DSC will be auto manage
* Update management, install monitoring extenions to windows and linux
* Runbook is a script you can run in Azure (Powershell or Python, Yea!)
* Edit Powershell Runbook, modules, cmdlets.
* Test it in portal an run it.
* Hybrid worker can be outside of Azure, if agent from Azure is installed.


#### 6. Azure functions (alternative to Automation Account, why use Automation, functions are more for dev, but not necessarily infrastructure, but processing data)
* Azure Functions is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs.
* Executed after visit to API URL for example, can run logic app schedule.
* https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview
* The following are a common, but by no means exhaustive, set of scenarios for Azure Functions.

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

#### 7. Low code option
* Azure Logic Apps is a cloud platform where you can create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, you can quickly build a workflow that integrates and manages your apps, data, services, and systems.
* * Schedule and send email notifications
* * Route and process customer orders across on-premises systems and cloud services.
* * Move uploaded files from an SFTP or FTP server to Azure Storage.
* * Run an Azure Function
* https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview


## Azure PowerShell Documentation

https://learn.microsoft.com/en-us/powershell/azure/?view=azps-9.6.0

## Azure Command-Line Interface (CLI) documentation

https://learn.microsoft.com/en-us/cli/azure/

## 1 Bicep TODO

We've introduced a new language named Bicep that offers the same capabilities as ARM templates but with a syntax that's easier to use. Each Bicep file is automatically converted to an ARM template during deployment. 

If you're considering infrastructure as code options, we recommend looking at Bicep.


Benefits of Bicep

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep

## Go folder azure-1-ARM-Bicep

## 1.1 Azure Resource Manager template specs NEXT

https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell

A template spec is a resource type for storing an Azure Resource Manager template (ARM template) in Azure for later deployment




