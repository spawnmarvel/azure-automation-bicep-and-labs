# Azure Automation bicep and labs

When picking the right tool, consider your past experience and current work environment.

* Azure CLI syntax is similar to that of Bash scripting. If you work primarily with Linux systems, Azure CLI feels more natural.
* Azure PowerShell is a PowerShell module. If you work primarily with Windows systems, Azure PowerShell is a natural fit. 
* * Commands follow a verb-noun naming scheme and data is returned as objects.

With that said, being open-minded will only improve your abilities. Use a different tool when it makes sense.

https://learn.microsoft.com/en-us/cli/azure/choose-the-right-azure-command-line-tool

## Learn modules for Bicep

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep


## Best practices for Bicep

* Parameters
* Good naming
* Think carefully about the parameters your template uses.
* Be mindful of the default values you use.
* Deploy clean resources and add custom extensions after

Read more:

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices


You can also look or export templates.

VM | Automation -> Export template -> Bicep 

 Structure your Bicep code for collaboration https://learn.microsoft.com/en-us/training/modules/structure-bicep-code-collaboration/3-improve-parameters-names

## When is Bicep the right tool?

* Azure-native
* Azure integration
* Azure support
* No state management
* Easy transition from JSON

https://learn.microsoft.com/en-us/training/modules/introduction-to-infrastructure-as-code-using-bicep/6-when-use-bicep

## Install Bicep tools

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually

## Bicep functions to use

```bicep

@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The tags to apply to each resource.')
param tags object = {
  CostCenter: 'Marketing'
  DataClassification: 'Public'
  Owner: 'WebsiteTeam'
  Environment: 'Production'
}

// Define the names for resources.
var appServiceAppName = 'webSite${resourceNameSuffix}'
var appServicePlanName = 'AppServicePLan'
var sqlServerName = 'sqlserver${resourceNameSuffix}'
var sqlDatabaseName = 'ToyCompanyWebsite'
var managedIdentityName = 'WebSite'
var applicationInsightsName = 'AppInsights'
var storageAccountName = 'toywebsite${resourceNameSuffix}'

// Bicep provides several types of parameter decorators:
// Be careful when you use the @allowed() parameter decorator to specify SKUs. 
// Azure services often add new SKUs, and you don't want your template to unnecessarily prohibit their use.
@allowed()

// enforce the minimum and maximum values for numeric parameters
@minValue()
@maxValue()

// enforce the length of string and array parameters
@minLength()
@maxLength()

// Symbolic names are used only within the Bicep file and don't appear on your Azure resources.
productManualStorageAccount

// Resource names are the names of the resources that are created in Azure
// For example, when you create an App Service app named myapp, the hostname you use to access the app will be myapp.azurewebsites.net. 
// You can't rename resources after they're deployed.
myapp

// When creating outputs, try to use resource properties wherever you can.
output hostname string = app.properties.defaultHostname

```

## Note: Connect Az and CustomScriptExtension for Windows and Linux post installation

Connect with ps1

```ps1

Connect-AzAccount -TenantId The-tenant-id-we-copied-from-azure-ad

```

Don use time with making and CustomScriptExtension in the template.bicep like:

```bicep

resource customScriptExtensionInstallIis 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = {
  parent: vm
  name: 'customScriptInstallIis'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: []  // Add any file URIs if needed
    }
    protectedSettings: {
      commandToExecute: 'powershell.exe -Command "Install-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools"'
    }
  }
}

```
Do this instead:

1. Make clean templates for reusable
2. Use custom script extension post install and stored scripts
3. Scripts are then reusable for custom script extension or as logged in user and run it
4. Scripts are downloaded to vm's also

```ps1
# must check for windows
C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.*\Downloads\<n>
# or 
C:\WindowsAzure\Logs\
```

```bash
# must check for linux
```

## Custom Script Extension vs Run Command (remote ext) for VM Configuration

Use case Custom Script Extension vs Run Command (remote ext)

![Use case custom ext](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/compare_cust_ext.jpg)


https://learn.microsoft.com/en-us/answers/questions/2149891/custom-script-extension-vs-run-command-for-vm-conf

### Custom Script Extension for Windows

You can just use the Set-AzVMCustomScriptExtension.

The Custom Script Extension downloads and runs scripts on Azure virtual machines (VMs). Use this extension for post-deployment configuration, software installation, or any other configuration or management task.
You can download scripts from Azure Storage or GitHub, or provide them to the Azure portal at extension runtime.


Tips for Choosing

1. For initial setup or deploying consistent configurations across multiple VMs, use Custom Script Extension.
2. For one-off fixes, diagnostics, or when you're troubleshooting an issue, use Run Command.
3. If you're integrating with IaC (ARM templates, Terraform, etc.), prefer Custom Script Extension as it fits well with automation pipelines.
4. For debugging a single VM without logging in, Run Command offers convenience without requiring prior setup.

https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

```ps1

Set-AzVMCustomScriptExtension -ResourceGroupName <resourceGroupName> `
    -VMName <vmName> `
    -Location myLocation `
    -FileUri <fileUrl> `
    -Run 'myScript.ps1' `
    -Name DemoScriptExtension

# use raw file from github

Set-AzVMCustomScriptExtension -ResourceGroupName $rg `
    -VMName $winVm `
    -Location $loc `
    -FileUri "https://raw.githubusercontent.com/spawnmarvel/azure-administrator-grinding/refs/heads/main/applied-skills/lab_env_01_deploy_configure_monitor/custom_install_all_features_ws-vm1.ps1" `
    -Run "custom_install_all_features_ws-vm1.ps1" `
    -Name DeployIisAndIndexHtml


```

Example from applied skills lab

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/applied_skills-labs/lab_env_01_deploy_configure_monitor/deploy_lab_resources.ps1

![ps1 vm extension eample](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/extension.jpg)


### Use the Azure Custom Script Extension Version 2 with Linux virtual machines

```bash

az vm extension set \
  --resource-group exttest \
  --vm-name exttest \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --protected-settings '{"fileUris": ["https://raw.githubusercontent.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/scripts/config-music.sh"],"commandToExecute": "./config-music.sh"}'

```

https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux

## Learn modules for Bicep


Use the log function for a deployes

```ps1

# Function to append to the log file
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logFile = "c:\temp\bicep_install_log.txt"
    Add-Content -Path $logFile -Value $logEntry
    # comment this out for only file log
    Write-Host $logEntry
}

```

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep

## Exercise 1 - Part 1 fundamentals Build your first Bicep template (ok)

* Create and deploy Azure resources by using Bicep.
* Add flexibility to your templates by using parameters, variables, and expressions.
* Create and deploy a Bicep template that includes modules.


What is the key take away?

You've been asked to deploy a new marketing website in preparation for the launch.

You'll host the website in Azure using Azure App Service. You'll incorporate a storage account for files, such as manuals and specifications, for the toy.

* Exercise - Create a Bicep template that contains a storage account
* Exercise - Add parameters and variables to your Bicep template
* Exercise - Add parameters and variables to your Bicep template
* Exercise - Refactor your template to use modules

The end tutorial is here https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=powershell

![Exercise 1](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_1.jpg)

## Exercise 2 -  Part 1 fundamentals Build reusable Bicep templates by using parameters (ok)

* Customize parameters and limit the values that can be used by each parameter
* Understand the ways that parameters can be supplied to a Bicep template deployment
* Work with secure parameters

What is the key take away?

You've been asked to prepare infrastructure for three environments: dev, test, and production. You'll build this infrastructure by using infrastructure as code techniques so that you can reuse the same templates to deploy across all of your environments. You'll create separate sets of parameter values for each environment, while securely retrieving database credentials from Azure Key Vault.

* Exercise - Add parameters and decorators
* Exercise - Add a parameter file and secure parameters

After deploy

```log
SubscriptionIsOverQuotaForSku - This
     | region has quota of 0 instances for your subscription. Try selecting different region or SKU.
  
```
The issues was a bad copy from the tutorial on main.bicep.
I have a policy for allowed locations:

["norwayeast","norwaywest","northeurope","westeurope","eastus","westus","uksouth","ukwest"]

```bicep

@description('The Azure region into which the resources should be deployed.')
param location string = 'eastus'

 // changed to
@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

```

I stopped at: Create a key vault and secrets

Your toy company already has a key vault with the secrets it needs for its deployments. To simulate this scenario, you'll create a new key vault and add some secrets to use.

The reason for this is that we need to: Add a key vault reference to a parameters file

The thing it does is:


```ps1
cmdlet New-AzResourceGroupDeployment at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
sqlServerAdministratorLogin: *****
sqlServerAdministratorPassword: *********
```
You aren't prompted to enter the values for sqlServerAdministratorLogin and sqlServerAdministratorPassword parameters when you execute the deployment this time. Azure retrieves the values from your key vault instead.


The end tutorial is here https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/6-exercise-create-use-parameter-files?pivots=powershell

![Exercise 2](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_2.jpg)

## Exercise 3 -  Part 1 fundamentals Build flexible Bicep templates by using conditions and loops (ok)

* Deploy resources conditionally within a Bicep template.
* Deploy multiple instances of resources by using loops.
* Use output and variable loops.

What is the key take away?

Suppose you're responsible for deploying and configuring the Azure infrastructure at a toy company. Your company is designing a new smart teddy bear toy. Some of the teddy bear's features are based on back-end server components and SQL databases that are hosted in Azure. For security reasons, within your production environments, you need to make sure that you've enabled auditing on your Azure SQL logical servers.

* Exercise - Deploy resources conditionally
* Exercise - Deploy multiple resources by using loops
* Exercise - Use variable and output loops

For your toy company, you need to deploy virtual networks in each country/region where you're launching the teddy bear. Your developers have also asked you to give them the fully qualified domain names (FQDNs) of each of the regional Azure SQL logical servers you've deployed.



The end tutorial is here https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/8-exercise-loops-variables-outputs?pivots=powershell

![Exercise 3](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_3.jpg)

## Exercise 4 - Part 1 fundamentals Create composable Bicep files by using modules

* Design and create reusable, well-structured Bicep modules
* Create Bicep files that use multiple modules together

What is the key take away?

You've been tasked with adding a content delivery network, or CDN, to your company's website for the launch of a toy wombat. However, other teams in your company have told you they don't need a CDN. In this exercise, you'll create modules for the website and the CDN, and you'll add the modules to a template.

The end tutorial is here https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/8-exercise-loops-variables-outputs?pivots=powershell

![Exercise 4 ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_4.jpg)


## Exercise 5 Part 2 intermediate - Deploy child and extension resources by using Bicep  (ok)

* Child and extension resources allow your Azure deployments to access the advanced functionality and power of the Azure platform. 
* You can create these resource types in Bicep by using a clear and understandable template syntax.

***You can also use Bicep to refer to resources that were created outside the Bicep file itself. ***

What is the key take away?

They want you to set up a new Azure Cosmos DB database for storing this valuable and highly sensitive product test data. They need you to log all database-access attempts so that they can feel confident that no competitors are accessing the data.

The team created a storage account to store all their product design documents, and they want you to help audit all attempts to access them.

* Child resource definitions, through nested resources, the parent property, and by constructing multipart resource names.
* Extension resource definitions, by using the scope property.
* Existing resource references, by using the existing keyword.

During the process, you'll:

* Create a Log Analytics workspace.
* Update your Bicep file to add diagnostic settings to your Cosmos DB account.
* Create a storage account.
* In your Bicep file, update the diagnostic settings for the storage account.
* Deploy your template and verify the result.

End tutorial is here https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/7-exercise-deploy-extension-existing-resources?pivots=powershell


![Exercise 5 ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_5.jpg)

## Exercise none Part 2 intermediate Manage changes to your Bicep code by using Git (already do that)


Full exercise https://learn.microsoft.com/en-us/training/modules/manage-changes-bicep-code-git/

What is the key take away?

## Exercise 6 Part 2 intermediate - Structure your Bicep code for collaboration (ok)

* Select the appropriate parameters for a Bicep file.
* Structure your Bicep code and parameters to support team collaboration.
* Document your Bicep code by using comments and resource tags.

What is the key take away?

One of the benefits of deploying your infrastructure as code is that your templates are shareable, allowing you to collaborate on your Bicep code with other team members. It's important to make your Bicep code easy to read and easy to work with.

Two members of the quality control team have been tasked to run a customer survey. To accomplish this, they need to deploy a new website and database. They're on a tight deadline, and they want to avoid building a whole new template if they don't have to. After you've spoken with them about their requirements, you remember that you already have a template that's close to what they need.

The template is one of the first Bicep files you wrote, so you're worried that it might not be ready for them to use. The question is, how can you revise the template to ensure that it's correct, easy to understand, easy to read, and easy to modify?
 

Full exercise at https://learn.microsoft.com/en-us/training/paths/intermediate-bicep/

Example good bicep file at https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/bi_exercise_6_inter_ok/main.bicep


## Exercise none Part 2 intermediate Review Azure infrastructure changes by using Bicep and pull requests (later in the future)

Full exercise at https://learn.microsoft.com/en-us/training/modules/review-azure-infrastructure-changes-using-bicep-pull-requests/

## Exercise 7 Part 2 intermediate - Preview Azure deployment changes by using what-if (ok)

What is the key take away?

Incremental mode
* The default deployment mode is incremental. In this mode, Resource Manager doesn't delete anything.

Complete mode
* You have to explicitly ask for your deployment to run in complete mode. When you use this mode, resources that exist in Azure but that aren't specified in the template are deleted.
* Complete mode is available when you deploy to a resource group, not subscription, management group, or a tenant


When should I use complete mode?

* If all of your infrastructure is defined in templates, then using complete mode every time you deploy ensures that no errant resources are left afterward. 
* In other words, it helps to avoid configuration drift in your environment.

Types of changes that what-if detects

* Create, 
* Delete, 
* Ignore, 
* NoChange, 
* Modify, 
* Deploy, 

List of what they are at https://learn.microsoft.com/en-us/training/modules/arm-template-whatif/3-what-if?pivots=bicepcli


Full exercise at https://learn.microsoft.com/en-us/training/modules/arm-template-whatif/1-introduction

![Exercise 7  ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_7.jpg)

## Exercise 8 Part 2 intermediate -  Migrate Azure resources and JSON ARM templates to use Bicep (50%)

Your team might have already deployed Azure resources by using the Azure portal, JSON Azure Resource Manager templates (ARM templates).
It's worth the investment to use Bicep for your Azure resources, but migrating your existing deployments to Bicep isn't accomplished with a click of a button. The process involves a recommended workflow that includes converting, migrating, refactoring, and testing.

What is the key take away?

Export and convert your Azure resources to Bicep files, and migrate your JSON Azure Resource Manager templates (ARM templates) to Bicep. Refactor your Bicep files to follow best practices. Test your Bicep files and deploy them to production.

* Convert JSON ARM templates to Bicep.
* Create Bicep definitions for your existing Azure resources.
* Verify template conversions by using the what-if operation and documentation.

![Exercise 8  ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_8_todo.jpg)

Convert phase
* Capture a representation of your Azure resources.
* If necessary, convert the JSON representation to Bicep by using the decompile command.

```bash
# The Bicep tooling includes the decompile command to convert templates. 
# You can invoke the decompile command from either Azure CLI or the Bicep CLI.
decompile
```

If you have an existing JSON template that you're converting to Bicep, the first step is easy because you already have your source template. You'll learn how to decompile it to Bicep in this unit.

There are two types of operations in Azure
* For example, you use a control plane operation to create a virtual machine,
* but you use a data plane operation to connect to the virtual machine by using Remote Desktop Protocol (RDP).

You need to consider a few things when you export existing resources:
* The exported resource definition is a snapshot of that resource's current state. It includes all changes made to the resource since its initial deployment.
* The exported template might include some default resource properties that are normally omitted from a Bicep definition.
* The exported template probably won't include all the parameters you'll need to make the template reusable.
* Some resources can't be exported by using this approach, and you need to define them manually in your Bicep file.

Migrate phase
* Create a new empty Bicep file.
* Copy each resource from your decompiled template.
* Identify and re-create any missing resources.

ARM template reference https://learn.microsoft.com/en-us/azure/templates/

Azure Quickstart Templates https://learn.microsoft.com/en-us/samples/browse/?expanded=azure&products=azure-resource-manager

![Exercise 8.1  ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_8_todo_1.jpg)

Manually steps after creating the VM, export the ARM template with parameters.

![Exercise 8.2  ](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/exercise_8_todo_2.jpg)

Inspect the decompiled Bicep file.

Open the template.bicep file in Visual Studio Code and read through it. Notice that it's a valid Bicep file, but it has a few problems, including:
* The symbolic names that are given to parameters and resources include underscores and aren't easy to understand.
* The location property is hard-coded in all the resource definitions.
* The template includes hard-coded values that should either be parameters or be set automatically by Azure.

Create a new Bicep filem splitt VSC and copy each element into your new Bicep file and fix it.

Next up, Refactor the Bicep file https://learn.microsoft.com/en-us/training/modules/migrate-azure-resources-bicep/4-refactor-bicep-file

Full exercise at https://learn.microsoft.com/en-us/training/modules/migrate-azure-resources-bicep/



## Exercise X Part 3 advanced

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep

## Use Bicep in a deployment pipeline (skip it)

After that, you might be interested in adding your Bicep code to a deployment pipeline. Follow one of these two learning paths based on the tool that you want to use:

* Option 1: Deploy Azure resources by using Bicep and Azure Pipelines
* Option 2: Deploy Azure resources by using Bicep and GitHub Actions

## Introduction to deployment stacks (short)

## Build your first deployment stack (short)

## Manage resource lifecycles with deployment stacks (short)

## Labs for applied skills with tags azure administrator

* They are on github, this forces you to read, deploy bicep and learn
* Use Azure to spin up resources with bicep
* You can them deploy all environments fast, typicall and rg with one or more vm's etc.
* Deploy rg, then deploy all resources in the rg


Stored in ./applied_skills

***When you are done with that or need a break you can set up up some of the lab environments for az-104***

## AZ-104-MicrosoftAzureAdministrator

https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator


## Labs for az-104

* They are on github, this forces you to read, deploy bicep and learn
* Use Azure to spin up resources with bicep
* You can them deploy all environments fast, typicall and rg with one or more vm's etc.
* Deploy rg, then deploy all resources in the rg

Lab instructions and env for it https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/tree/master/Instructions/Labs

Templates for some labs https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/tree/master/Allfiles/Labs

Stored in ./az_104-labs

## Check lab updates az-104

* Check the labs and files above from time to time and do them again




