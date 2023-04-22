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

#### Introduction to infrastructure as code using Bicep

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



