# Azure Automation bicep and labs

When picking the right tool, consider your past experience and current work environment.

* Azure CLI syntax is similar to that of Bash scripting. If you work primarily with Linux systems, Azure CLI feels more natural.
* Azure PowerShell is a PowerShell module. If you work primarily with Windows systems, Azure PowerShell is a natural fit. 
* * Commands follow a verb-noun naming scheme and data is returned as objects.

With that said, being open-minded will only improve your abilities. Use a different tool when it makes sense.

https://learn.microsoft.com/en-us/cli/azure/choose-the-right-azure-command-line-tool


## Best practices for Bicep

* Parameters
* Good naming
* Think carefully about the parameters your template uses.
* Be mindful of the default values you use.

Read more:

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices


You can also look or export templates.

VM | Automation -> Export template -> Bicep 

Understanding and Using Project BICEP - The NEW Azure Deployment Technology

https://www.youtube.com/watch?v=_yvb6NVx61Y

## Install Bicep tools

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually
## Learn modules for Bicep

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep

## Note: Connect Az and CustomScriptExtension

Connect with ps1

```ps1

Connect-AzAccount -TenantId The-tenant-id-we-copied-from-azure-ad

```

Don use time with making and CustomScriptExtension like:

```json
resource customScriptExtensionInstallIis 'Microsoft.Compute/virtualMachines/extensions@2021-11-01'= {}

```
You can just use the Set-AzVMCustomScriptExtension

https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

```ps1

# use raw file from github

Set-AzVMCustomScriptExtension -ResourceGroupName $rg -VMName $winVm -Location $loc `
    -FileUri "https://raw.githubusercontent.com/spawnmarvel/azure-administrator-grinding/refs/heads/main/applied-skills/lab_env_01_deploy_configure_monitor/custom_install_all_features_ws-vm1.ps1" `
    -Run "custom_install_all_features_ws-vm1.ps1" -Name DemoScriptExtension


```

![ps1 vm extension eample](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/x_images/extension.jpg)

## Exercise 1 - Build your first Bicep template (check it)

* Create and deploy Azure resources by using Bicep.
* Add flexibility to your templates by using parameters, variables, and expressions.
* Create and deploy a Bicep template that includes modules.

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/


## Exercise 2 - Build reusable Bicep templates by using parameters (check it)

* Customize parameters and limit the values that can be used by each parameter
* Understand the ways that parameters can be supplied to a Bicep template deployment
* Work with secure parameters

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/


## Exercise 3 - Build flexible Bicep templates by using conditions and loops (check it)

* Deploy resources conditionally within a Bicep template.
* Deploy multiple instances of resources by using loops.
* Use output and variable loops.

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/


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




