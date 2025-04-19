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
* Deploy clean resources and add custom extensions after

Read more:

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices


You can also look or export templates.

VM | Automation -> Export template -> Bicep 

Understanding and Using Project BICEP - The NEW Azure Deployment Technology

https://www.youtube.com/watch?v=_yvb6NVx61Y

## Install Bicep tools

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually

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

https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep

## Exercise 1 - Part 1 fundamentals Build your first Bicep template (check it)

* Create and deploy Azure resources by using Bicep.
* Add flexibility to your templates by using parameters, variables, and expressions.
* Create and deploy a Bicep template that includes modules.


What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/


## Exercise 2 -  Part 1 fundamentals Build reusable Bicep templates by using parameters (check it)

* Customize parameters and limit the values that can be used by each parameter
* Understand the ways that parameters can be supplied to a Bicep template deployment
* Work with secure parameters

What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/


## Exercise 3 -  Part 1 fundamentals Build flexible Bicep templates by using conditions and loops (check it)

* Deploy resources conditionally within a Bicep template.
* Deploy multiple instances of resources by using loops.
* Use output and variable loops.

What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/

## Exercise 5 -  Part 1 fundamentals Exercise - fundamentals Deploy multiple resources by using loops (check it)

What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/5-exercise-loops?pivots=powershell

## Exercise 6 -  Part 1 fundamentals Exercise - fundamentals Use variable and output loops (check it)


What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/8-exercise-loops-variables-outputs?pivots=powershell

## Exercise 8 Part 2 intermediate - TODO or (check it)

* Explain resource types and resource IDs
* Deploy child and extension resources
* Represent and use pre-existing resources in a Bicep template


What is the key take away?

```bicep
```

https://learn.microsoft.com/en-us/training/modules/child-extension-bicep-templates/

## Exercise x Part 3 advanced

## Introduction to deployment stacks

## Build your first deployment stack

## Manage resource lifecycles with deployment stacks

## Skip the stuff with piplines

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




