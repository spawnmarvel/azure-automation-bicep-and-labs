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

#### Better understand your cloud resources

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

#### Azure Resource Manager

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

#### What is Bicep?

* Bicep is used only to create Resource Manager templates. 
* Bicep provides many improvements over JSON for template authoring, including:
* * Simpler syntax
* * Modules
* * Automatic dependency management
* * Type validation and IntelliSense

#### How Bicep works

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


#### Add an App Service plan and app to your Bicep template

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/4-exercise-define-resources-bicep-template?pivots=powershell

#### Add flexibility by using parameters and variables

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

#### Exercise - Add parameters and variables to your Bicep template


Notice that you're explicitly specifying the value for the environmentType parameter when you execute the deployment. You don't need to specify the other parameter values, because they have valid default values.

![Deploy nonprod ](https://github.com/spawnmarvel/azure-automation/blob/main/images/deploy_non_prod.jpg)

Or you coud pass the args in the file

```
# -environmentType nonprod
New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentId -environmentType nonprod -TemplateFile templates\main.bicep # -WhatIf
```
![Deploy nonprod args ](https://github.com/spawnmarvel/azure-automation/blob/main/images/deploy_non_prod_args.jpg)

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/6-exercise-add-parameters-variables-bicep-template?pivots=powershell

#### Group related resources by using modules

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


#### Exercise - Refactor your template to use modules

* Add a new module and move the App Service resources into it.
* Reference the module from the main Bicep template.
* Add an output for the App Service app's host name, and emit it from the module and template deployments.
* Test the deployment to ensure that the template is valid.

![App is ready ](https://github.com/spawnmarvel/azure-automation/blob/main/images/app_ready1.jpg)

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/8-exercise-refactor-template-modules?pivots=powershell


#### Build reusable Bicep templates by using parameters

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

#### Exercise 2 - Add parameters and decorators

* Create a Bicep file that includes parameters and variables.
* Add decorators to the parameters.
* Test the deployment to ensure that the template is valid.

![Exercise 2 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/exercise2.jpg)

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/3-exercise-add-parameters-with-decorators?pivots=powershell


#### Provide values using parameter files

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

#### Secure your parameters

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

#### Exercise 3 - Add a parameter file and secure parameters

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


