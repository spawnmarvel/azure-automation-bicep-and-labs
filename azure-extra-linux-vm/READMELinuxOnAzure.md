# Linux on Azure

This comprehensive learning path reviews deployment and management of Linux on Azure. Learn about cloud computing concepts, Linux IaaS and PaaS solutions and benefits and Azure cloud services. 

Discover how to migrate and extend your Linux-based workloads on Azure with improved scalability, security, and privacy.

https://learn.microsoft.com/en-us/training/paths/azure-linux/?wt.mc_id=youtube_S-1076_video_reactor&source=learn

## 1 Introduction to Linux on Azure

First, choose the Linux distribution you want based on familiarity, usage, cost, and support requirements.

First, choose the Linux distribution you want based on familiarity, usage, cost, and support requirements.

* IaaS
* PaaS 
* DBaaS — Azure automates database updates, provisioning, and backups, which enable you to focus on application development.
* SaaS 

This module focuses on IaaS, PaaS, and database as a service options for Linux.

### Identify Azure IaaS options for Linux deployments

Choosing a Linux distribution

* Licensing/pricing
* Support, Microsoft gives you the option of running almost any Linux image, but the level of support you receive depends on the type of Linux distribution you choose.
* * Microsoft recommends using endorsed distributions for most production workloads because you benefit from the support and collaboration between Microsoft and Linux providers — Red Hat, SUSE, Canonical, and others.
* * Three of the largest Linux vendors — Red Hat, SUSE, and Ubuntu — partner with Microsoft to provide end-to-end support of Linux deployments.
* Virtual networking and network appliances
* Azure Storage
* Choose the appropriate Azure Files tier

When to use Azure IaaS resources for Linux deployments

* Some organizations want to take a hands-on approach with all aspects of their infrastructure, from the choice of virtual machine configurations to storage and network optimization to building custom development environments. For those organizations, IaaS is an appropriate approach.

Identify Azure PaaS options for Linux deployments

Azure managed platforms allow you to take advantage of the benefits of PaaS while retaining the Linux-based technology foundation you're already familiar with. Some of the popular managed platforms for Linux include:

* Azure App Service
* Azure Functions
* Azure Red Hat OpenShift
* Azure Red Hat OpenShift
* Azure Container Instances

When to use Azure PaaS resources for Linux deployments

* If your goal is to create new applications and services quickly, use PaaS to gain greater agility and reusability by adopting modern development tools and advanced application architectures. 

Identify database-as-a-service options for Linux deployments

A partial list of the fully managed databases available on Azure includes:

* Azure SQL Database
* Azure Database for PostgreSQL
* Azure Database for MySQL
* Azure Cosmos DB
* Azure Cache for Redis

Identify other Azure tools and services for Linux deployments

Examples of open-source tools

* Prometheus,  On Azure, you don't need to set up and manage a Prometheus server with a database. Instead, use Azure Monitor managed service for Prometheus, a component of Azure Monitor Metrics. 
* Terraform, To simplify common IT Ops and DevOps tasks, use Terraform, an open-source declarative coding tool. Terraform works with Bash or Azure PowerShell for Linux.

NOTE: Terraform uses its own Terraform CLI. If you want to use a declarative coding tool more closely integrated with Azure, consider Bicep, which works with Azure CLI and the Azure portal.

* Red Hat Ansible Automation Platform on Azure, Operate and manage automation with a Red Hat solution that's integrated with native Azure services.
* Azure CLI, Azure Portal, Azure Resource Manager, 


Security tools and capabilities

* Azure provides multilayered security across physical datacenters, infrastructure, and operations in Azure. No matter which Linux distribution you choose, you can protect your workloads by using built-in controls and services in Azure across identity, data, networking, and apps.


Business continuity and disaster recovery

Azure offers an end-to-end backup and disaster recovery solution for Linux that's simple, secure, scalable, and cost-effective — and can be integrated with on-premises data protection solutions.

* Azure Backup
* Azure Site Recovery
* Azure Archive Storage
* Azure Migrate, Use Azure Migrate to simplify migration and optimization when moving Linux workloads to Azure.


## 2 Plan your Linux environment in Azure


Plan for sizing and networking of Azure VMs running Linux

* This planning process should consider the compute, networking, and storage aspects of the VM configuration.
* Microsoft has partnered with prominent Linux vendors to integrate their products with the Azure platform, such as SUSE, Red Hat, and Ubuntu.
* Sizes for virtual machines in Azure
* * https://learn.microsoft.com/en-us/azure/virtual-machines/sizes?toc=%2Fazure%2Fvirtual-network%2Ftoc.json
* Plan for networking of Azure VMs running Linux
* Virtual networks and subnets
* Remote connectivity
* Azure Bastion
* JIT VM Access
* Network throughput
* * Although an Azure VM can have multiple network interfaces, its available bandwidth is dependent exclusively on its size. In general, larger VM sizes are allocated more bandwidth than smaller ones.

Implement best practices for managing Linux on Azure VMs

VM provisioning is the process in which the platform creates the Azure VM configuration parameter values (such as hostname, username, and password) that are available to the OS during the boot process. A provisioning agent consumes these values, configures the OS, and then reports the results when completed.

Azure supports cloud-init provisioning agents and Azure Linux Agent (WALA):

* Cloud-init provisioning agent. The cloud-init agent is a widely used approach to customizing Linux during an initial boot. You can use cloud-init to install packages and write files, or to configure users and security.
* WALA. WALA is an Azure platform-specific agent you can use to provision and configure Azure VMs. You can also use it to implement support for Azure extensions.

Optimize the management and troubleshooting boot process

* Enable boot diagnostics when provisioning an Azure VM.
* Leverage the Azure VM serial console access for troubleshooting boot failures.

There are many scenarios in which the serial console can help you restore an Azure VM running Linux to an operational state. The most common ones include:

* Broken file system table (fstab) files
* Misconfigured firewall rules
* File system corruption
* SSH configuration issues
* Interaction with bootloader
* Increase the timeout value in the grub menu on generation 2 Azure VMs.
* Reserve more memory for kdump. Just in case the dump capture kernel ends up with a panic on boot, you should reserve more memory for the kernel.

Optimize Linux on Azure VMs for performance and functionality




