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











