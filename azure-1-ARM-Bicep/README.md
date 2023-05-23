# Azure Bicep

## What is Bicep?

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep

## Benefits of Bicep

Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. 

* Support for all resource types and API versions
* Simple syntax
* Authoring experience
* Repeatable results
* Orchestration
* Modularity
* Integration with Azure services
* Preview changes,  what-if operation
* No state or state files to manage
* No cost and open source



## Learn modules for Bicep

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep


## Part 1: Fundamentals of Bicep

## Introduction to infrastructure as code using Bicep

Why use infrastructure as code?
* Integration with current processes
* Consistency
* Automated scanning
* Secret management
* Access control
* Avoid configuration drift: Idempotence is a term that's frequently associated with infrastructure as code. When an operation is idempotent, it means that it provides the same result each time it's run. If you choose tooling that uses idempotent operations, you can avoid configuration drift.

Install Azure CLI on Windows

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli

azure-cli-2.47.0.msi

Run the Azure CLI
You can now run the Azure CLI with the az command from either Windows Command Prompt or PowerShell.

![Az cli from ps1 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/az-cli.jpg)


* Manage multiple environments
* Non-production environments: A common problem organizations face is differentiation between production and non-production environments. When you manually provision resources in separate environments, it's possible that the end configurations won't match.
* Disaster recovery

### Better understand your cloud resources

* Audit trail
* Documentation
* Unified system
* Better understanding of cloud infrastructure

When you use the Azure portal to provision resources, many of the processes are abstracted from view. Infrastructure as code can help provide a better understanding of how Azure works and how to troubleshoot issues that might arise.


Imperative code
* Sequence of commands
* Is accomplished programmatically by using a scripting language like Bash or Azure PowerShell.

Declarative code
* Specify only the end configuration
* A declarative code approach is accomplished by using templates. (jJSON, Bicep, Ansible, Terraform)

Bicep example:
* The resources section defines the storage account configuration.
* The Bicep template doesn't specify how to deploy the storage account. It specifies only what the storage account needs to look like. 
* The actual steps that are executed, are left for Azure to decide.

```

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'mystorageaccount'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

```

### Azure Resource Manager

Before beginning the process of building your first template, you need to understand how Azure Resource Manager works. Investigating the types of templates that are available to use with Azure will help you determine the next steps in your infrastructure-as-code strategy.

Resource Manager and the two types of Resource Manager templates.

* Resource: A manageable item that is available on the Azure platform.
* Resource group: A logical container that holds related resources for an Azure solution.
* Subscription: A logical container and billing boundary for your resources and resource groups. 
* Management group: A logical container that you use to manage more than one subscription.
* Azure Resource Manager template (ARM template): A template file that defines one or more resources to deploy to a resource group, subscription, management group, or tenant.

There are two types of ARM template files: JSON and Bicep. This module focuses on Bicep.

Operations: Control plane and data plane

* You use a control plane operation to create a virtual machine.
* * When you send a request from any of the Azure tools, APIs, or SDKs, Resource Manager receives, authenticates, and authorizes the request. Then, it sends the request to the Azure resource provider, which takes the requested action.

* You use a data plane operation to connect to the virtual machine by using Remote Desktop Protocol (RDP).
* * When a data plane operation starts, the requests are sent to a specific endpoint in your Azure subscription.


JSON and Bicep templates

Bicep is a new domain-specific language that was recently developed for authoring ARM templates by using an easier syntax.

### What is Bicep?

* Bicep is used only to create Resource Manager templates. 
* Bicep provides many improvements over JSON for template authoring, including:
* * Simpler syntax
* * Modules
* * Automatic dependency management
* * Type validation and IntelliSense

### How Bicep works

* When you deploy a resource or series of resources to Azure, you submit the Bicep template to Resource Manager, which still requires JSON templates.
* The tooling that's built into Bicep converts your Bicep template into a JSON template. 
* The latest versions of Azure CLI and Azure PowerShell have built-in Bicep support.
* You can use the same deployment commands to deploy Bicep and JSON templates. 

```
az deployment group create \
  --template-file main.bicep \
  --resource-group storage-resource-group
```

You can view the JSON template that's submitted to Resource Manager by using the bicep build command.

```
bicep build main.bicep
```

### When to use Bicep

When is Bicep the right tool?

* Azure-native
* Azure integration
* Azure support
* No state management
* Easy transition from JSON

When is Bicep not the right tool?

* Bicep doesn't work as a language for other cloud providers.
* Existing tool set: When you're determining when to use Bicep, the first question to ask is, does my organization already have a tool set in use?
* Multicloud, Other cloud providers don't support Bicep as a template language. Open source tools like Terraform can be used for multicloud deployments, including deployments to Azure.


### Build your first Bicep template

1 Bicep language support for Visual Studio Code
2 Either the latest Azure CLI tools, or the latest version of Azure PowerShell.
* Azure CLI automatically installs the Bicep CLI. Azure PowerShell requires a manual installation.


### Exercise 1 Create a Bicep template that contains a storage account

Install Bicep tools

Azure PowerShell doesn't automatically install the Bicep CLI. Instead, you must manually install the Bicep CLI.

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install?tabs=azure-powershell#install-manually

```
# check version
bicep --version

# Bicep CLI version 0.16.2 (de7fdd2b33)
```
![Bicep version ](https://github.com/spawnmarvel/azure-automation/blob/main/images/bicep_version.jpg)

```
# Connect to Azure
Connect-AzAccount -TenantID 123-THE-ID

# Set the default subscription for all of the Azure PowerShell commands that you run in this session.
# $context = Get-AzSubscription -SubscriptionName 'THE-NAME'
# Set-AzContext $context

# Get the subscription ID. Running the following command lists your subscriptions and their IDs.
# Get-AzSubscription

$context = Get-AzSubscription -SubscriptionId 456-THE-ID
# Set-AzContext $context

# Set the default resource group or make one in ps1
# Set-AzDefault -ResourceGroupName 789-RG

# Deploy/verify/remove the template to Azure
# cd to folders:

deploy.ps1, verify.ps1, remove.ps1

```

Verify deployment

![Verify deployments ](https://github.com/spawnmarvel/azure-automation/blob/main/images/verify_deployments.jpg)

Note:
```
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main.bicep [..]

# -Name The name of the deployment it's going to create. If not specified, defaults to the template file name when a template file is provided
# -Mode Complete: In complete mode, Resource Manager deletes resources that exist in the resource group but are not specified in the template.
# -Mode Incremental: Default value, In incremental mode, Resource Manager leaves unchanged resources that exist in the resource group but are not specified in the template.
# -Tag
# -Force Forces the command to run without asking for user confirmation.
# -AsJob Run cmdlet in the background
# -TemplateFile
# -TemplateUri
# -WhatIf


```


### Add an App Service plan and app to your Bicep template

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/4-exercise-define-resources-bicep-template?pivots=powershell

### Add flexibility by using parameters and variables

* You need to avoid using fixed resource names, so you can reuse the template for multiple product launches. 
* You also have to deploy the resources in different locations, which means you can't embed the resource locations in your template either.

Parameters, para
* A parameter lets you bring in values from outside the template file

Variables, var
* A variable is defined and set within the template.

Things that will change between each deployment, like:
* The names of resources that need to be unique.
* Locations into which to deploy the resources.
* Settings that affect the pricing of resources, like their SKUs, pricing tiers, and instance counts.
* Credentials and information needed to access other systems that aren't defined in the template.

? is called a ternary operator and it evaluates an if/then statement. The value after the ? operator is used if the expression is true. If the expression evaluates to false, the value after the colon (:) is used.

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/5-add-flexibility-parameters-variables

### Exercise - Add parameters and variables to your Bicep template


Notice that you're explicitly specifying the value for the environmentType parameter when you execute the deployment. You don't need to specify the other parameter values, because they have valid default values.

![Deploy nonprod ](https://github.com/spawnmarvel/azure-automation/blob/main/images/deploy_non_prod.jpg)

Or you coud pass the args in the file

```
# -environmentType nonprod
New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -environmentType nonprod -TemplateFile templates\main.bicep # -WhatIf
```
![Deploy nonprod args ](https://github.com/spawnmarvel/azure-automation/blob/main/images/deploy_non_prod_args.jpg)

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/6-exercise-add-parameters-variables-bicep-template?pivots=powershell

### Group related resources by using modules

* Outputs
* * For logs
* * Input to another process
* * If expression is used to generate name->URL

```
# appService.bicep
output appServiceAppHostName string = appServiceApp.properties.defaultHostName

# main.bicep
output appServiceAppHostName string = appService.outputs.appServiceAppHostName

```

Note:
Outputs can use the same names as variables and parameters. This convention can be helpful if you construct a complex expression within a variable to use within your template's resources, and you also need to expose the variable's value as an output.


Design your modules
* A module should have a clear purpose.
* Don't put every resource into its own module.
* A module should have clear parameters and outputs that make sense.
* A module should be as self-contained as possible. 
* *  If a module needs to use a variable to define a part of a module, the variable should generally be included in the module file rather than in the parent template.
* A module should not output secrets.

```
module myModule 'modules/mymodule.bicep' = {
  name: 'MyModule'
  params: {
    location: location
  }
}
```

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/7-group-related-resources-modules


### Exercise - Refactor your template to use modules

* Add a new module and move the App Service resources into it.
* Reference the module from the main Bicep template.
* Add an output for the App Service app's host name, and emit it from the module and template deployments.
* Test the deployment to ensure that the template is valid.

![App is ready ](https://github.com/spawnmarvel/azure-automation/blob/main/images/app_ready1.jpg)

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=powershell


### Build reusable Bicep templates by using parameters

By using parameters, you can create flexible and reusable Bicep templates. You define parameters for any aspect of your deployment that might change, such as environment-specific settings, pricing and capacity configuration for your Azure resources, and API keys to access external systems.
By the end of this module, you'll be able to:

* Customize parameters and limit the values that can be used by each parameter
* Understand the ways that parameters can be passed to a Bicep template
* Work with secure parameters to ensure that secrets aren't leaked or shared unnecessarily

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/


* With parameters, you can provide information to a Bicep template at deployment time. You can make a Bicep template flexible and reusable by declaring parameters within your template.
* Decorators provide a way to attach constraints and metadata to a parameter, which helps anyone using your templates to understand what information they need to provide.

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/2-understand-parameters

```
# param, name, type, value
param environmentName string = 'dev'

param location string = resourceGroup().location

```
Parameters in Bicep can be one of the following types:
* string
* int
* bool
* object and array, which represent structured data and lists.

Object:

```
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
  capacity: 1
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanSku.capacity
  }
}


# Tags are another exmaple of objects
 tags:{
    Infrastructure: 'IAC'
  }

# Arrays

param cosmosDBAccountLocations array = [
  {
    locationName: 'australiaeast'
  }
  {
    locationName: 'southcentralus'
  }
  {
    locationName: 'westeurope'
  }
]

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: accountName
  location: location
  properties: {
    locations: cosmosDBAccountLocations
  }
}

# Specify a list of allowed values
# To enforce this rule, you can use the @allowed parameter decorator, string can be restricted so that only a few specific values can be assigned:
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

# Restrict parameter length and values
@minLength(5)
@maxLength(24)
param storageAccountName string

# with a description
@description('This will ensure a max and min instance for the app service plan')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int

```
Note:
Bicep templates can sometimes be made available in the Azure portal for users to deploy, like when you use template specs. The portal uses the descriptions and other decorators on parameters to help users understand what a parameter value needs to be.
@description('The name of tier of the app service plan SKU')

### Exercise 2 - Add parameters and decorators

* Create a Bicep file that includes parameters and variables.
* Add decorators to the parameters.
* Test the deployment to ensure that the template is valid.

![Exercise 2 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise2.jpg)

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/3-exercise-add-parameters-with-decorators?pivots=powershell


### Provide values using parameter files

* Parameter files make it easy to specify parameter values together as a set.
* Within the parameter file, you provide values for the parameters in your Bicep file. 
* Parameter files are created by using the JavaScript Object Notation (JSON) language.

* $schema helps Azure Resource Manager to understand that this file is a parameter file.
* contentVersion is a property that you can use to keep track of significant changes.
* The parameters section lists each parameter and the value you want to use.

Note:
Make sure you only specify values for parameters that exist in your Bicep template. When you create a deployment, Azure checks your parameters and gives you an error if you've tried to specify a value for a parameter that isn't in the Bicep file.

Note:
Override parameter values:
* Parameter files override default values, and command-line parameter values override parameter files.

![Override ](https://github.com/spawnmarvel/azure-automation/blob/main/images/override.jpg)

By using a mixture of the approaches to specify parameter values, you can avoid having to duplicate parameter values in lots of places, while still getting the flexibility to override where you need to.

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/4-how-use-parameter-file-with-bicep?pivots=powershell

### Secure your parameters

Sometimes you need to pass sensitive values into your deployments, like passwords and API keys. But you need to ensure these values are protected. 

Note:
The best approach is to avoid using credentials entirely. Managed identities for Azure resources can enable the components of your solution to securely communicate with one another without any credentials. Managed identities aren't available for every resource, but it's a good idea to use them wherever you can. Where you can't, you can use the approaches described here.

Define secure parameters

```
#Azure won't make the parameter values available in the deployment logs.
@secure()
param sqlServerAdministratorLogin string

@secure()
param sqlServerAdministratorPassword string
```

* Make sure you don't create outputs for sensitive data
* Avoid using parameter files for secrets
* Integrate with Azure Key Vault
* * You can integrate your Bicep templates with Key Vault by using a parameter file with a reference to a Key Vault secret.
* * The value is never exposed because you only reference its identifier, which by itself isn't anything secret.

```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlServerAdministratorLogin": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/PlatformResources/providers/Microsoft.KeyVault/vaults/toysecrets"
        },
        "secretName": "sqlAdminLogin"
      }
    },
    "sqlServerAdministratorPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/PlatformResources/providers/Microsoft.KeyVault/vaults/toysecrets"
        },
        "secretName": "sqlAdminLoginPassword"
      }
    }
  }
}
```


https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/5-how-secure-parameter

### Exercise 3 - Add a parameter file and secure parameters

You're prompted to enter the values for sqlServerAdministratorLogin and sqlServerAdministratorPassword parameters when you execute the deployment. You don't need to specify solutionName because it has a default value specified in the template. You don't need to specify the other parameter values because their values are specified in the parameter file.

```
# deploy resources
$deployResult = New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -TemplateFile main.bicep -TemplateParameterFile .\main.parameters.dev.json # -WhatIf

```

![Sql deploy ](https://github.com/spawnmarvel/azure-automation/blob/main/images/sql_deploy1.jpg)


Create a key vault and secrets
* Make sure you use the same login and password that you used in the previous step. If you don't, the next deployment won't complete successfully.

```
# rg and location
$rgName = "Rg-iac-0003"
$location  = "uk south"

$keyVaultName = 'kviac0041'
$login = Read-Host "Enter the login name" -AsSecureString
$password = Read-Host "Enter the password" -AsSecureString

# You're setting the -EnabledForTemplateDeployment setting on the vault so that Azure can use the secrets from your vault during deployments. 
New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password
```
![Vault ](https://github.com/spawnmarvel/azure-automation/blob/main/images/vault.jpg)

```
# Get the key vault's resource ID
$keyVaultName = 'kviac0041'

(Get-AzKeyVault -Name $keyVaultName).ResourceId

# The resource ID will look something like this example:
/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/PlatformResources/providers/Microsoft.KeyVault/vaults/toysecrets

```

Add a key vault reference to a parameter file

```
"sqlServerAdministratorLogin": {
      "reference": {
        "keyVault": {
          "id": "YOUR-KEY-VAULT-RESOURCE-ID"
        },
        "secretName": "sqlServerAdministratorLogin"
      }
    },
    "sqlServerAdministratorPassword": {
      "reference": {
        "keyVault": {
          "id": "YOUR-KEY-VAULT-RESOURCE-ID"
        },
        "secretName": "sqlServerAdministratorPassword"
      }
```
Deploy the Bicep template with parameter file and Azure Key Vault references
* You aren't prompted to enter the values for sqlServerAdministratorLogin and sqlServerAdministratorPassword parameters when you execute the deployment this time. 
* Azure retrieves the values from your key vault instead.

1. Notice that the appServicePlanSku and the sqlDatabaseSku parameter values have both been set to the values in the parameter file. 
2. Also, notice that the sqlServerAdministratorLogin and sqlServerAdministratorPassword parameter values aren't displayed, because you applied the @secure() decorator to them.


![Sql deploy key vault ](https://github.com/spawnmarvel/azure-automation/blob/main/images/sql_deploy_keyvault.jpg)

Add IAM Key vault officer and view the secrets

![Key vault secret ](https://github.com/spawnmarvel/azure-automation/blob/main/images/keyvault_secret.jpg)

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/6-exercise-create-use-parameter-files?pivots=powershell


### Build flexible Bicep templates by using conditions and loops

In this module, you'll extend a Bicep template by using conditions and loops. You'll:

* Use conditions to deploy Azure resources only when they're required.
* Use loops to deploy multiple instances of Azure resources.
* Learn how to control loop parallelism.
* Learn how to create nested loops.
* Combine loops with variables and outputs.

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/

### Deploy resources conditionally

When you deploy a resource in Bicep, you can provide the if keyword followed by a condition.

It's common to create conditions based on the values of parameters that you provide. For example, the following code deploys a storage account only when the deployStorageAccount parameter is set to true:

```
// The deployStorageAccount parameter was of type bool, so it's clear whether it has a value of true or false.

param deployStorageAccount bool

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = if (deployStorageAccount) {
  name: 'teddybearstorage'
  location: resourceGroup().location
  kind: 'StorageV2'
  // ...
}

// It's usually a good idea to create a variable for the expression that you're using as a condition. 

@allowed([
  'Development'
  'Production'
])
param environmentName string

var auditingEnabled = environmentName == 'Production'

resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = if (auditingEnabled) {
  parent: server
  name: 'default'
  properties: {
  }
}

// Depend on conditionally deployed resources
// 
resource auditingSettings 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = if (auditingEnabled) {
  parent: server
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}

```
Note:
You can't define two resources with the same name in the same Bicep file and then conditionally deploy only one of them. The deployment will fail, because Resource Manager views this as a conflict.

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/2-use-conditions-deploy-resources

### Exercise 4 - Deploy resources conditionally

* Create a Bicep file that defines a logical server with a database.
* Add a storage account and SQL auditing settings, each of which is deployed with a condition.
* Set up an infrastructure for your development environment, and then verify the result.
* Redeploy your infrastructure against your production environment, and then look at the changes.

Verify the deployment
* Also, be sure to note the login and password that you enter. You'll use them again shortly.


In this case, one logical server and one SQL database are deployed. Notice that the storage account and auditing settings aren't on the list of resources.

![Deploy 1 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise4_1.jpg)

Redeploy for the production environment
* In the previous deployment, the default value for the environmentName parameter was used, which meant that it was set to Development.
```
param environmentName string = 'Development'
```
* You expect that, by making this change, the storage account for auditing purposes will be deployed, and auditing will be enabled on the logical server.

```
New-AzResourceGroupDeployment -ResourceGroupName $rgName -environmentName Production -Name $deploymentId -TemplateFile main.bicep # -WhatIf
```
Note:
Be sure to use the same login and password that you used previously, or else the deployment won't finish successfully.

![Deploy 2 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise4_2.jpg)

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/3-exercise-conditions?pivots=powershell

### Deploy multiple resources by using loops

* Often, you need to deploy multiple resources that are very similar. By adding loops to your Bicep files, you can avoid having to repeat resource definitions. 
* Instead, you can dynamically set the number of instances of a resource you want to deploy. 
* You can even customize the properties for each instance.

```
// for keyword to create a loop.

param storageAccountNames array = [
  'saauditus'
  'saauditeurope'
  'saauditapac'
]

resource storageAccountResources 'Microsoft.Storage/storageAccounts@2021-09-01' = [for storageAccountName in storageAccountNames: {
  name: storageAccountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]

// Loop based on a count for

resource storageAccountResources 'Microsoft.Storage/storageAccounts@2021-09-01' = [for i in range(1,4): {
  //Access the iteration index
  name: 'sa${i}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]

// Filter items with loops , for and if
param sqlServerDetails array = [
  {
    name: 'sqlserver-we'
    location: 'westeurope'
    environmentName: 'Production'
  }
  {
    name: 'sqlserver-eus2'
    location: 'eastus2'
    environmentName: 'Development'
  }
  {
    name: 'sqlserver-eas'
    location: 'eastasia'
    environmentName: 'Production'
  }
]

resource sqlServers 'Microsoft.Sql/servers@2021-11-01-preview' = [for sqlServer in sqlServerDetails: if (sqlServer.environmentName == 'Production') {
  name: sqlServer.name
  location: sqlServer.location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
  tags: {
    environment: sqlServer.environmentName
  }
}]
```


https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/4-use-loops-deploy-resources

### Exercise 5 - Deploy multiple resources by using loops

* Move your existing Bicep code into a module.
* Create a new Bicep file with a copy loop to deploy the module's resources multiple times.
* Deploy the Bicep file, and verify the deployment of the resources.
* Modify the parameter to add an additional location, redeploy the file, and then verify that the new resources have been deployed.

You now need to deploy multiple logical servers, one for each region where your company is launching its new smart teddy bear.

```
@description('The az regions for deployments')
param locations array = [
  'westeurope'
  'uksouth'
]

```

![Loop region sql db ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise5.jpg)


https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/5-exercise-loops?pivots=powershell


### Control loop execution and nest loops

In this unit, you learn how to control the execution of copy loops, and how to use resource property loops and nested loops in Bicep.
* By default, Azure Resource Manager creates resources from loops in parallel, and in a non-deterministic order. 
* In some cases, however, you might need to deploy resources in loops sequentially instead of in parallel, or deploy small batches of changes together in parallel. 

```
// Let's look at an example Bicep definition for a set of App Service applications without the @batchSize decorator:
// All the resources in this loop will be deployed at the same time, in parallel:
resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = [for i in range(1,3): {
  name: 'app${i}'
  // ...
}]

// Now let's apply the @batchSize decorator with a value of 2:
// When you deploy the template, Bicep will deploy in batches of two:
@batchSize(2)
resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = [for i in range(1,3): {
  name: 'app${i}'
  // ...
}]

// You can also tell Bicep to run the loop sequentially by setting the @batchSize to 1:
@batchSize(1)

```

Use loops with resource properties

```
param subnetNames array = [
  'api'
  'worker'
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  
  // more code here
  }
    subnets: [for (subnetName, i) in subnetNames: {
      name: subnetName
      properties: {
        addressPrefix: '10.0.${i}.0/24'
      }


}

```

Nested loops

* You can use a nested loop to deploy the subnets within each virtual network:

```
resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-08-01' = [for (location, i) in locations : {
  name: 'vnet-${location}'

  // mode code here
  subnets: [for j in range(1, subnetCount): {
      name: 'subnet-${j}'
      properties: {
        addressPrefix: '10.${i}.${j}.0/24'
      }

```


https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/6-use-loops-advanced

### Use variable and output loops

In Bicep, loops can also be used with variables and outputs.

```
// Variable loops
var items = [for i in range(1, 5): 'item${i}']


// Output loops
var items = [
  'item1'
  'item2'
  'item3'
  'item4'
  'item5'
]

output outputItems array = [for i in range(0, length(items)): items[i]]

```
https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/7-use-loops-with-variables-and-outputs

### Exercise 6 - Use variable and output loops

Deployment takes time....just cancel, it is saturday!

![Cancel deploy ](https://github.com/spawnmarvel/azure-automation/blob/main/images/cancel.jpg)

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/8-exercise-loops-variables-outputs?pivots=powershell

### Create composable Bicep files by using modules

Bicep modules let you split a complex template into smaller parts. You can ensure that each module is focused on a specific task, and that the modules are reusable for multiple deployments and workloads.

In this module, you'll learn about the benefits of Bicep modules and how you can create, use, and combine them for your own deployments.

https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/


Example scenario

* You've previously created a Bicep template that deploys websites to support the launch of each new toy product.
* Customers are complaining about slow response times because the server can't keep up with the demand.
* To improve performance and reduce cost, you've been asked to add a content delivery network, or CDN, to the website.

What will we be doing?
In this module, you'll create a set of Bicep modules to deploy your website and CDN. Then, you'll create a template that uses those modules together.

https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/1-introduction

### Create and use Bicep modules

Bicep modules help you address these challenges by splitting your code into smaller, more manageable files that multiple templates can reference. Modules give you some key benefits.
* Reusability
* Encapsulation
* Composability

The Bicep visualizer can help you put your whole Bicep file in perspective. The visualizer is included in the Bicep extension for Visual Studio Code.

![Bicep visualizer ](https://github.com/spawnmarvel/azure-automation/blob/main/images/visualizer.jpg)

Use the module in a Bicep template

```
module appModule 'modules/app.bicep' = {
  name: 'myApp'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

```

https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/2-create-use-bicep-modules?tabs=visualizer


```
// Add parameters and outputs to modules
@description('The name of the storage account to deploy.')
param storageAccountName string

// Use conditions

param logAnalyticsWorkspaceId string = ''
//
resource cosmosDBAccountDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' =  if (logAnalyticsWorkspaceId != '') {

// Module outputs
@description('The fully qualified Azure resource ID of the blob container within the storage account.')
output blobContainerResourceId string = storageAccount::blobService::container.id
```

### Exercise 7 - Create and use a module

* Add a module for your application.
* Create a Bicep template that uses the module.
* Add another module for the CDN.
* Add the CDN module to your template, while making it optional.
* Deploy the template to Azure.
* Review the deployment history.

Bicep extension for Visual Studio Code helps you to scaffold the module declaration.
When you type the path to your module and type the equals (=) character, a pop-up menu appears with several options.

![Required properties ](https://github.com/spawnmarvel/azure-automation/blob/main/images/required_props.jpg)

```
// error
 "details": [
    {
      "code": "BadRequest",
      "message": "Azure subscription is not registered with CDN Provider."

// https://learn.microsoft.com/en-us/azure/azure-resource-manager/troubleshooting/error-register-resource-provider?tabs=azure-powershell
```

Register

```
Register-AzResourceProvider -ProviderNamespace "Microsoft.Cdn"
```

* Review the deployment history
* Three deployments are listed.

* Test the website
* Select the copy button for the appServiceAppHostName output.
* On a new browser tab, try to go to the address that you copied in the previous step. The address should begin with https://.
* The App Service welcome page appears, showing that you've successfully deployed the app.

![Exercise 7 app ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise7.jpg)

* Copy the value of the websiteHostName output. Notice that this host name is different, because it's an Azure Content Delivery Network host name.
* On a new browser tab, try to go to the host name that you copied in the previous step. Add https:// to the start of the address.

![Exercise 7.1 cnd ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise7_1.jpg)

Deployment

![Exercise 7.1 all ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise7_1_all.jpg)

https://learn.microsoft.com/en-us/training/modules/create-composable-bicep-files-using-modules/4-exercise-create-use-module?pivots=powershell

Note:

```
// if we remove this parameter from New-AzResourceGroupDeployment 
-Name $deploymentId 

// deploy again
 New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile main.bicep

```
Then the deployments will have correct names according to the bicep files and three deployments will be listed.

![Exercise 7 main deployments ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise7_main.jpg)


## Part 2: Intermediate Bicep


https://learn.microsoft.com/en-us/training/paths/intermediate-bicep/

### Deploy child and extension resources by using Bicep

* Child and extension resources allow your Azure deployments to access the advanced functionality and power of the Azure platform.
* Can also use Bicep to refer to resources that were created outside the Bicep file itself. 
* * Refere to resources that were created manually or from another bicep template, module, rg or subscription.

Note:
Example scenario
* They've already created a storage account to store all their product design documents, and they've asked you to help audit all attempts to access them.

What will we be doing?
* parent, Child resource definitions, through nested resources, the parent property, and by constructing multipart resource names.
* scope, Extension resource definitions, by using the scope property.
* existing, Existing resource references, by using the existing keyword.

https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/

### Understand Azure resources

Resource providers
* All Azure resources are deployed with a specific type. The type identifies the kind of resource it is. A resource ID is the way Azure identifies a specific instance of a resource. 
* A resource provider is a logical grouping of resource types, which usually relate to one or a small number of Azure services. Examples of resource providers include:

| Provider | Desciption
| -------- | ----------
|Microsoft.Compute | for vms
|Microsoft.Network | for vnets, nsg and route tables
|Microsoft.Cache   | for Azure Cache for Redis
|Microsoft.Sql     | for Azure SQL
|Microsoft.Web     | for Azure App Service and Azure Functions
|Microsoft.DocumentDB| for Azure Cosmos DB

Note:
Not all names match: For example, the resource provider for Log Analytics workspaces is Microsoft.OperationalInsights.
Resource providers have to be registered for your subscription before you can use the resource types they expose. Registration is usually a one-time process. 

Resource types
* Each resource type has its own set of properties and behaviors that define the resource and what it can do.

Microsoft.Web resource provider, there are several resource types, including:
* sites: Defines an App Service application or Azure Functions application. (vars, https/https)
* serverFarms: Defines an App Service plan, the infrastructure that runs your applications. (size, SKU, num of instances)

FQDN:
* For example, a storage account’s fully qualified type name is Microsoft.Storage/storageAccounts

Resource IDs
* Every Azure resource has a unique resource ID.
```
/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyDevelopment/providers/Microsoft.Storage/storageAccounts/secrettoys
```
Note:
You can access the ID of any resource in Bicep by using the symbolic name and the id property. 
For example:
* if you define a storage account with the symbolic name toyDesignDocumentsStorageAccount
* you can access its resource ID by using the expression toyDesignDocumentsStorageAccount.id.


https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/2-understand-azure-resources


### Define child resources

| Name | Resource type
| ---- | ------------
|Virtual networks subnets        | Microsoft.Network/virtualNetworks/subnets
|App Service Configuration       | Microsoft.Web/sites/config
|SQL databases                   | Microsoft.Sql/servers/databases
|Virtual machine extensions      | Microsoft.Compute/virtualMachines/extensions
|Storage blob container          | Microsoft.Storage/storageAccounts/blobservice/container

### How are child resources defined?

Nested resources

```
resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    // ...
  }

  // The nested resource has a simpler resource type than normal. 
  // Even though the fully qualified type name is Microsoft.Compute/virtualMachines/extensions, the nested resource automatically inherits the parent's resource type
  resource installCustomScriptExtension 'extensions' = {
    // Bicep assumes that you want to use the same API version as the parent resource, although you can override the API version if you want to.
    name: 'InstallCustomScript'
    location: location
    properties: {
      // ...
    }
  }
}

// You can refer to a nested resource by using the :: operator.
output childResourceId string = vm::installCustomScriptExtension.id
```

Parent property

```
resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    // ...
  }
}

resource installCustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  // A second approach is to declare the child resource without any nesting and then tell Bicep about,
  // the parent-child relationship by using the parent property:
  parent: vm
  name: 'InstallCustomScript'
  location: location
  properties: {
    // ...
  }
}

// To refer to a child resource that's declared with the parent property, you use its symbolic name as you would with a normal parent resource:
output childResourceId string = installCustomScriptExtension.id
```

Construct the resource name IS NOT GOOD TO USE.
It's generally best to avoid constructing resource names, because you lose a lot of the benefits that Bicep can provide when it understands the relationships between your resources. Use this option only when you can't use one of the other approaches for declaring child resources.
Depends on is should be used wuth this, to reslove the order..

```
resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    // ...
  }
}

resource installCustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${vmName}/InstallCustomScript'
  // you could manually tell Bicep about the dependency by using the dependsOn keyword
  dependsOn: [
    vm
  ]
  //...
}
```

Child resource IDs
*  You start creating a child resource ID by including its parent's resource ID and then appending the child resource type and name. 
* Parent: Microsoft.DocumentDB/databaseAccounts, child toyrnd
* /subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyDevelopment/providers/Microsoft.DocumentDB/databaseAccounts/toyrnd

https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/3-define-child-resources


### Exercise 8 - Define child resources

* Create a Bicep file that deploys a Cosmos DB account.
* Add a database and container, which are child resources of the Cosmos DB account.
* Deploy the template and verify the deployment.

Select the deployment called main to see what resources were deployed, and then select Deployment details to expand it. In this case, there's a Cosmos DB account, database, and container listed.


![Exercise 8 main deployments ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise8_main.jpg)

https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/4-exercise-define-child-resources?pivots=powershell


### Define extension resources

Extension resources are always attached to other Azure resources. They extend the behavior of those resources with extra functionality.
* Role assignment
* Policy assignment
* Locks
* Diagnostic settings
* etc

```
// In Bicep, you define an extension resource in mostly the same way as a normal resource. 
// However, you add the scope property to tell Bicep that the resource should be attached to another resource that's defined elsewhere in the Bicep file. 
// You use the resource's symbolic name to refer to it

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: cosmosDBAccountName
  //...
    }

resource lockResource 'Microsoft.Authorization/locks@2016-09-01' = {
  scope: cosmosDBAccount
  name: 'DontDelete'
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevents deletion of the toy data Cosmos DB account.'
  }
}

```
Extension resource IDs

Let's say you deployed the previously mentioned Azure Cosmos DB account, and the account was named toyrnd. Here's what the lock's resource ID would look like:

```
/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyDevelopment/providers/Microsoft.DocumentDB/databaseAccounts/
toyrnd/providers/Microsoft.Authorization/locks/DontDelete

// If you see a resource ID that starts with a normal resource ID and then adds /providers/ 
// and another resource type and name, it means that you're looking at an extension resource ID.
```
https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/5-define-extension-resources


### Work with existing resources

* Bicep files often need to refer to resources that have been created elsewhere. 
* These resources might have been created manually, maybe by a colleague using the Azure portal.
* Or they might have been created in another Bicep file.

Example
* Add SQL db to Azure SQL server
* Diagnostics settings
* Securley access keys for a storage account

```
// Bicep provides the existing keyword for you to use in these situations.
// Within a Bicep file, you can define a resource that already exists

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'toydesigndocs'
}

```
* The existing keyword indicates to Bicep that this resource definition is a reference to an already-created resource, and that Bicep shouldn't try to deploy it.
* The name property is the Azure resource name of the storage account that was previously deployed.
* You don't need to specify the location, sku, or properties, because the template doesn't deploy the resource. It references an existing resource.

Refer to child resources

```
// The following example shows how you can refer to an existing subnet, which is a child resource of a virtual network. 
// The example uses a nested child resource, as shown here:

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: 'toy-design-vnet'

  resource managementSubnet 'subnets' existing = {
    name: 'management'
  }
}
```
Refer to resources outside the resource group

```
// Often, you'll need to refer to resources in a different resource group. 
// For example, if you have a virtual network in a centralized resource group, 
// you might want to deploy a virtual machine into that virtual network in its own resource group. 

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  scope: resourceGroup('networking-rg')
  name: 'toy-design-vnet'
}
// Notice that the scope uses the resourceGroup() keyword to refer to the resource group that contains the virtual network.
// You can even refer to resources within a different Azure subscription, as long as the subscription is within your Azure Active Directory tenant.
```

Add child and extension resources to an existing resource
* By using a combination of the existing keyword and the parent keyword.

Refer to an existing resource's properties
* By using the existing keyword, you get access to the properties of the resource that you're referring to.

https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/6-work-with-existing-resources

### Exercise - Deploy extension resources and use existing resources


* Create a Log Analytics workspace.
* Update your Bicep file to add diagnostic settings to your Cosmos DB account.
* Create a storage account.
* In your Bicep file, update the diagnostic settings for the storage account.
* Deploy your template and verify the result.

Create a Log Analytics workspace

```
 New-AzOperationalInsightsWorkspace -Name ToyLogs -Location uksouth -ResourceGroupName "Rg-iac-0080"
```

![Exercise 8 1  ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise8_1.jpg)

Update your Bicep file to add diagnostic settings to your Cosmos DB account.

Now that you've created your simulated pre-existing Log Analytics workspace, you can reference it from within your Bicep template as an existing resource. You can use it as the destination for the Azure Cosmos DB logs.

Create a storage account.

```
/// Create an Azure storage account to simulate your R&D team's already having created one in your organization. 
// Use Azure PowerShell instead of Bicep.

new-azstorageAccount -ResourceGroupName "Rg-iac-0080" -Name "toyteststorage0062uks" -SkuName Standard_LRS -Location uksouth
```

![Exercise 8 2  ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise8_2.jpg)

Add diagnostics settings for storage account

You need to update your Bicep template to reference the storage account you created in the previous step.

Deploy your template and verify the result.

```
 New-AzResourceGroupDeployment -templateFile main.bicep -storageAccountName "toyteststorage0062uks" -ResourceGroupName "Rg-iac-0080"

```

Check your deployment

Notice that there are two resources listed with a type of Microsoft.Insights/diagnosticSettings. 
These are the extension resources you deployed. 
One of the resources was attached to the storage account and the other was attached to the Azure Cosmos DB account. Now you will verify that the Azure Cosmos DB diagnostic settings are configured correctly.

![Exercise 8 3  ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise8_3.jpg)
