## AZ-104 certified professional must know

As an Azure administrator, you often serve as part of a larger team dedicated to implementing an organization's cloud infrastructure. You also coordinate with other roles to deliver Azure networking, security, database, application development, and DevOps solutions.

https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-104

You should be familiar with:

* Operating systems
* Networking
* Servers
* Virtualization

In addition, you should have experience with:

* PowerShell
* Azure CLI
* The Azure portal
* Azure Resource Manager templates
* Microsoft Entra ID

Skills at a glance

* Manage Azure identities and governance (20–25%)
* Implement and manage storage (15–20%)
* Deploy and manage Azure compute resources (20–25%)
* Implement and manage virtual networking (15–20%)
* Monitor and maintain Azure resources (10–15%)

## Practice Assessments for Microsoft Certifications

https://learn.microsoft.com/en-us/credentials/certifications/practice-assessments-for-microsoft-certifications

## Exam Readiness Zone

https://learn.microsoft.com/en-us/shows/exam-readiness-zone/?terms=az-104

## Tips use a script language and the portal

You should always do the tutorials as two steps:

1. Use the Portal
2. Use Powershell or Azure CLI, you can even use the Azure Portal Powershell or Azure Cli

Powershell connect ps1

```ps1
Connect-AzAccount -TenantId The-tenant-id-we-copied-from-azure-ad
# Login and verify
```

Azure Cli (git bash or ps1)

```bash
az login
# or
az login --tenant The-tenant-id-we-copied-from-azure-ad
```

## Manage Azure identities and governance (20–25%)

### Manage Microsoft Entra users and groups

* Create users and groups
* Manage user and group properties
* Manage licenses in Microsoft Entra ID
* Manage external users
* Configure self-service password reset (SSPR)

### Manage access to Azure resources

* Manage built-in Azure roles
* Assign roles at different scopes
* Interpret access assignments

### Manage Azure subscriptions and governance

* Implement and manage Azure Policy
* Configure resource locks
* Apply and manage tags on resources
* Manage resource groups
* Manage subscriptions
* Manage costs by using alerts, budgets, and Azure Advisor recommendations
* Configure management groups

## Implement and manage storage (15–20%)

### Configure access to storage

* Configure Azure Storage firewalls and virtual networks
* Create and use shared access signature (SAS) tokens
* Configure stored access policies
* Manage access keys
* Configure identity-based access for Azure Files

### Configure and manage storage accounts

* Create and configure storage accounts
* Configure Azure Storage redundancy
* Configure object replication
* Configure storage account encryption
* Manage data by using Azure Storage Explorer and AzCopy

### Configure Azure Files and Azure Blob Storage

* Create and configure a file share in Azure Storage
* Create and configure a container in Blob Storage
* Configure storage tiers
* Configure soft delete for blobs and containers
* Configure snapshots and soft delete for Azure Files
* Configure blob lifecycle management
* Configure blob versioning

### Implement and manage storage (15–20%) Tutorials

Az Storage Account with robocopy and fileshare

* https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-storage-account

Configure directory and file-level permissions for Azure file shares, Configure Windows ACLs (icalcs)

* https://learn.microsoft.com/en-us/azure/storage/files/storage-files-identity-configure-file-level-permissions

## Deploy and manage Azure compute resources (20–25%)

### Automate deployment of resources by using Azure Resource Manager (ARM) templates or Bicep files

* Interpret an Azure Resource Manager template or a Bicep file
* Modify an existing Azure Resource Manager template
* Modify an existing Bicep file
* Deploy resources by using an Azure Resource Manager template or a Bicep file
* Export a deployment as an Azure Resource Manager template or convert an Azure Resource Manager template to a Bicep file

### Create and configure virtual machines

* Create a virtual machine
* Configure Azure Disk Encryption
* Move a virtual machine to another resource group, subscription, or region
* Manage virtual machine sizes
* Manage virtual machine disks
* Deploy virtual machines to availability zones and availability sets
* Deploy and configure an Azure Virtual Machine Scale Sets

### Provision and manage containers in the Azure portal

* Create and manage an Azure container registry
* Provision a container by using Azure Container Instances
* Provision a container by using Azure Container Apps
* Manage sizing and scaling for containers, including Azure Container Instances and Azure Container Apps

### Create and configure Azure App Service

* Provision an App Service plan
* Configure scaling for an App Service plan
* Create an App Service
* Configure certificates and Transport Layer Security (TLS) for an App Service
* Map an existing custom DNS name to an App Service
* Configure backup for an App Service
* Configure networking settings for an App Service
* Configure deployment slots for an App Service

### Deploy and manage Azure compute resources (20–25%) Tutorials

Create a Linux virtual machine in the Azure portal

* https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal?tabs=ubuntu

Create a Windows virtual machine in the Azure portal

* https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-portal

Create a snapshot of a virtual hard disk

* https://learn.microsoft.com/en-us/azure/virtual-machines/snapshot-copy-managed-disk?tabs=portal

Create a VM from a specialized disk using

* https://learn.microsoft.com/en-us/azure/virtual-machines/attach-os-disk?tabs=portal

Use the portal to attach a data disk to a Linux VM

* https://learn.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal

Attach a managed data disk to a Windows VM by using the Azure portal

* https://learn.microsoft.com/en-us/azure/virtual-machines/windows/attach-managed-disk-portal

## Implement and manage virtual networking (15–20%)

### Configure and manage virtual networks in Azure

* Create and configure virtual networks and subnets
* Create and configure virtual network peering
* Configure public IP addresses
* Configure user-defined network routes
* Troubleshoot network connectivity

### Configure secure access to virtual networks

* Create and configure network security groups (NSGs) and application security groups
* Evaluate effective security rules in NSGs
* Implement Azure Bastion
* Configure service endpoints for Azure platform as a service (PaaS)
* Configure private endpoints for Azure PaaS

## Configure name resolution and load balancing

* Configure Azure DNS
* Configure an internal or public load balancer
* Troubleshoot load balancing

### Implement and manage virtual networking (15–20%) Tutorials

Create an Azure Virtual Network

* https://learn.microsoft.com/en-us/azure/virtual-network/quickstart-create-virtual-network?tabs=portal

Azure Virtual Network concepts and best practices

* https://learn.microsoft.com/en-us/azure/virtual-network/concepts-and-best-practices

Create, change, or delete a network security group

* https://learn.microsoft.com/en-us/azure/virtual-network/manage-network-security-group?tabs=network-security-group-portal

Connect virtual networks with virtual network peering

* https://learn.microsoft.com/en-us/azure/virtual-network/tutorial-connect-virtual-networks?tabs=portal

Private IP addresses

* https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/private-ip-addresses

Public IP addresses

* https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses

Tutorial: Log network traffic to and from a virtual network using the Azure portal

* https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-tutorial

## Monitor and maintain Azure resources (10–15%)

### Monitor resources in Azure

* Interpret metrics in Azure Monitor
* Configure log settings in Azure Monitor
* Query and analyze logs in Azure Monitor
* Set up alert rules, action groups, and alert processing rules in Azure Monitor
* Configure and interpret monitoring of virtual machines, storage accounts, and networks by using Azure Monitor Insights
* Use Azure Network Watcher and Connection Monitor

### Implement backup and recovery

* Create a Recovery Services vault
* Create an Azure Backup vault
* Create and configure a backup policy
* Perform backup and restore operations by using Azure Backup
* Configure Azure Site Recovery for Azure resources
* Perform a failover to a secondary region by using Site Recovery
* Configure and interpret reports and alerts for backups

### Monitor and maintain Azure resources (10–15%) Tutorials

Azure Workbooks provide a flexible canvas for data analysis and the creation of rich visual reports within the Azure portal

*  https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview