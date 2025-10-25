# AZ-104 certified professional must know

As an AZ-104 certified professional, the most important hands-on knowledge revolves around the core daily operational tasks of an Azure Administrator, which often appear as scenario-based questions or lab items on the exam.
The key practical areas you should be able to perform in the Azure Portal, PowerShell, and Azure CLI are:

## 1. Networking (VNet Management)

The core foundation of Azure. You must be comfortable with:
 * Virtual Networks (VNets) and Subnets: Creating, configuring, and connecting them.
 * Network Security Groups (NSGs): Creating and applying effective security rules (inbound/outbound) to control traffic to VMs.
 * VNet Peering: Configuring peering between two virtual networks for connectivity.
 * Private/Public IP Addresses: Allocating and configuring IP addresses.
 * Azure DNS: Configuring Azure DNS zones, including Private DNS for internal resolution.

### 1. Networking (VNet Management) Tutorials

Tutorial: Log network traffic to and from a virtual network using the Azure portal
* https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-tutorial



## 2. Compute (Virtual Machines)

The bread and butter of IaaS. You need to know how to:
 * Deploy Virtual Machines (VMs): Using the portal, ARM templates, or CLI/PowerShell, and selecting appropriate sizes and images.
 * VM Availability: Configuring Availability Sets and understanding Availability Zones to ensure high availability.
 * VM Disks: Creating, attaching, detaching, and resizing managed disks (OS and data disks).
 * Scale Sets (VMSS): Deploying and configuring auto-scaling for groups of identical VMs.

### 2. Compute (Virtual Machines) Tutorials

Create a snapshot of a virtual hard disk
* https://learn.microsoft.com/en-us/azure/virtual-machines/snapshot-copy-managed-disk?tabs=portal
Create a VM from a specialized disk using
https://learn.microsoft.com/en-us/azure/virtual-machines/attach-os-disk?tabs=portal

## 3. Identity and Governance

This is critical for security and compliance. Hands-on skills include:
 * Microsoft Entra ID (Azure AD) Users and Groups: Creating, managing, and assigning licenses.
 * Role-Based Access Control (RBAC): Assigning built-in roles (Owner, Contributor, Reader) and understanding the concept of creating Custom RBAC Roles at the correct scope (subscription, resource group, resource).
 * Azure Policy: Creating, assigning, and troubleshooting policy definitions and initiatives to enforce organizational standards (e.g., only allow specific VM sizes in a region).
 * Resource Locks: Applying locks (Read-Only, Cannot-Delete) to critical resources or resource groups to prevent accidental changes.

### 3. Identity and Governance Tutorials

## 4. Storage

You must know how to manage cloud data effectively:
 * Storage Accounts: Creating and configuring various types (e.g., general-purpose v2).
 * Access Management: Configuring Access Keys, generating Shared Access Signatures (SAS), and implementing Storage Account Firewalls and virtual networks to restrict access.
 * Blob Storage Tiers: Moving between hot, cool, and archive tiers for cost optimization.
 * Azure File Shares: Setting up and configuring Azure Files, often for use with Azure File Sync.

### 4. Storage Tutorials

Az Storage Account with robocopy and fileshare
* https://github.com/spawnmarvel/azure-automation-bicep-and-labs/tree/main/az-104-storage-account

## 5. Monitoring and Backup

Knowing how to keep things running and recoverable:
 * Azure Monitor: Configuring and interpreting Metrics, Logs (Log Analytics), and Alerts based on defined criteria and routing them to an Action Group.
 * Azure Backup: Configuring a Recovery Services vault and setting up backup policies for Azure VMs.
 * Disaster Recovery: Understanding and configuring VM replication using Azure Site Recovery.

### 5. Monitoring and Backup Tutorials

Azure Workbooks provide a flexible canvas for data analysis and the creation of rich visual reports within the Azure porta
*  https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview

The video below covers the AZ-104 syllabus in a study-cram format, which helps reinforce the practical knowledge required for the exam.
AZ-104 Administrator Associate Study Cram v2 - YouTube

https://www.youtube.com/watch?v=0Knf9nub4-k

