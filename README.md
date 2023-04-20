# Azure Automation

## Preface

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

What now.....

### Focus on

1. Compute. 

   * The Azure Administrator is most often identified with infrastructure-as-a-service (IaaS), which normally boils down to running virtual machines (VMs) in the cloud.
   * Containers represent a newer way to virtualize services, and Docker is extremely well-represented in Azure.

2. Storage

   * Azure provides Administrators with essentially limitless storage. You need space to store VM virtual hard disks (VHDs), database files, application data, and potentially user data.
   * Cloud computing’s shared responsibility model.
   * Securing data against unauthorized access.
   * Backing up data and making it efficient to restore when needed.

3. Network

   * Deploying and configuring virtual networks
   * Managing public and private IP addresses for your VMs and selected other Azure resources

4. Security

   * The security stakes are high in the Azure public cloud because your business stores its proprietary data on someone else’s infrastructure.
   * Encrypting data in transit, at rest, and in use.
   * Protecting Azure Active Directory accounts against compromise
   * Reducing the attack surface of all your Azure resources

5. Monitor

   * Azure Monitor Insights overview
   * https://learn.microsoft.com/en-us/azure/azure-monitor/insights/insights-overview
   * Application insight
   * Container insight
   * VM insights
   * Network insights


6. Bone up on your PowerShell and JavaScript Object Notation, (ARM and BICEP).

   * Unlike most of the Azure training and labs, relatively-little day-to-day work takes place within the web console.


## Automating Azure (glasspaper 2023 Paul "Dash" Wojcicki-Jarocki)

Make our life easier in Azure. Explorer Powershell and where it fits in, main topic is Automation accounts.

1. Azure Portal, check out stuff in preview.

![Preview things ](https://github.com/spawnmarvel/azure-automation/blob/main/images/preview.jpg)

2. Cloud shell (a bit buggy but ok), store scripts and files in the fileshare.
* 
```
PS /home/espen/clouddrive> code $PROFILE.CurrentUserAllHosts

# Edit the profile.ps1
# profile.ps1 for use in Azure Cloud Shell

# Disable Predictive Intellisens
Set-PSReadLineOption -PredictiveSource None -BellStyle Visual

# Save autentication token
$AUTH = Invoke-RestMethod -Uri "env:MSI_ENDPOINT`?resource=https://management.core.windows.net/" -Headers @{Metadata = 'true'}
```

![Cloud shell ](https://github.com/spawnmarvel/azure-automation/blob/main/images/cloudshell.jpg)

3. Scripts, ARM templates, Bicep
* ARM templates
* https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview

4. Blueprints

5. Automation runbooks

6. Azure functions

7. Low code option




