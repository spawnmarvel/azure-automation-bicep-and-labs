# Exam AZ-800: Administering Windows Server Hybrid Core Infrastructure

https://learn.microsoft.com/en-us/credentials/certifications/exams/az-800/

## Study guide

* Deploy and manage Active Directory Domain Services (AD DS) in on-premises and cloud environments (30–35%)
* Manage Windows Servers and workloads in a hybrid environment (10–15%)
* Manage virtual machines and containers (15–20%)
* Implement and manage an on-premises and hybrid networking infrastructure (15–20%)
* Manage storage and file services (15–20%)

https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-800

## How I Cracked AZ-800 Exam in Just 4 Hours | Administering Windows Server Hybrid Core Infrastructure

https://www.youtube.com/watch?v=HwphsRrH8RU

## Administering Windows Server Hybrid Core Infrastructure - Exam last updated: February 15, 2026

https://examheist.com/exam/microsoft/az-800/1/

## Tips

Helpful Tips for AZ-800:

* The "Hybrid" Rule: This exam is obsessed with Azure Arc and Azure File Sync. If the answer involves connecting a local server to the cloud, look for these first.
* Identity is King: Nearly 35% of the exam is Active Directory. If you aren't familiar with FSMO roles or Group Policy inheritance, prioritize those modules.
* PowerShell is mandatory: Unlike AZ-104 where you can mostly use the portal, AZ-800 will test you on specific Windows Server PowerShell cmdlets (e.g., Install-ADDSDomainController vs. Add-WindowsFeature).

## Deploy and manage identity infrastructure

### Introduction to AD FS

* Describe AD DS.
* Describe users, groups, and computers.
* Identify and describe AD DS forests and domains.
* Describe OUs.
* Manage objects and their properties in AD DS.

AD DS and its related services form the foundation for enterprise networks that run Windows operating systems. The AD DS database is the central store of all the domain objects, such as user accounts, computer accounts, and groups. AD DS provides a searchable, hierarchical directory and a method for applying configuration and security settings for objects in an enterprise.

Components

* Partition, A partition, or naming context, is a portion of the AD DS database. Example schema partition contains a copy of the Active Directory schema. The configuration partition contains the configuration objects for the forest, and the domain partition contains the users, computers, groups, and other objects specific to the domain
* Schema, set of definitions of the object types and attributes that you use to define the objects created in AD DS.
* Domain, logical administrative container for objects such as users and computers. 
* Domain tree, hierarchical collection of domains that share a common root domain and a contiguous Domain Name System (DNS) namespace.
* Forest, collection of one or more domains that have a common AD DS root, a common schema, and a common global catalog.
* OU, container object for users, groups, and computers that provides a framework for delegating administrative rights and administration by linking Group Policy Objects (GPOs).
* Conatiner, object that provides an organizational framework for use in AD DS.

Physical components in AD DS are those objects that are tangible, or that described tangible components in the real world.
* Domain controller, contains a copy of the AD DS database.
* Data store, A copy of the data store exists on each domain controller, stores the directory information in the Ntds.dit file and associated log files. The C:\Windows\NTDS
* Global catalog server, a domain controller that hosts the global catalog, which is a partial, read-only copy of all the objects in a multiple-domain forest. speeds up searches for objects that might be stored on domain controllers in a different domain in the forest.
* Read-only domain controller (RODC), special read only installation of AD DS. RODCs are common in branch offices where physical security isn't optimal, IT support is less advanced than in the main corporate centers, or need domain controller.
* Site, a container for AD DS objects, such as computers and services that are specific to a physical location. 
* Subnet, portion of the network IP addresses of an organization assigned to computers in a site.

Define users, groups, and computers

* The username.
* A user password.
* Group memberships.

What are managed service accounts?

* Many apps contain services that you install on the server that hosts the program. These services typically run at server startup or are triggered by other events. F_KEY

What are group managed service accounts?

* Group Managed Service Accounts (gMSA) enable you to extend the capabilities of standard managed service accounts to more than one server in your domain. And automatic password maintenance and simplified SPN management.

What are delegated managed service accounts?

* dMSAs and gMSAs are two types of managed service accounts that are used to run services and applications in Windows Server. A dMSA is managed by an administrator and is used to run a service or application on a specific server. A gMSA is managed by AD and is used to run a service or application on multiple servers. 

What are group objects?

* if several users need the same level of access to a folder, it's more efficient to create a group that contains the required user accounts, and then assign the required permissions to the group.

Group types

* Security, Security groups are security-enabled, and you use them to assign permissions to various resources.
* Distribution, Email applications typically use distribution groups, which aren't security-enabled.

Group scopes

* Local,for standalone servers or workstations, on domain-member servers that aren't domain controllers, or on domain-member workstations.
* Domain-local,Domain-local groups exist on domain controllers in an AD DS domain, and so, the group’s scope is local to the domain in which it resides.
* Global, For example, you might use global groups to join users who are part of a department or a geographic location.
* Universal, most often in multidomain networks because it combines the characteristics of both domain-local groups and global groups.

What are computer objects?

* They have an account with a sign-in name and password that Windows changes automatically on a periodic basis.
* They authenticate with the domain.
* They can belong to groups and have access to resources, and you can configure them by using Group Policy.

A computer account begins its lifecycle when you create the computer object and join it to your domain. 

Before you create a computer object in AD DS, you must have a place to put it. The Computers container is a built-in container in an AD DS domain. 

* This container isn't an OU. Instead, it's an object of the Container class. Its common name is CN=Computers.

Define AD DS forests and domains







### Manage AD DS domain controllers and FSMO roles

### Implement Group Policy Objects

### Manage advanced features of AD DS

### Implement hybrid identity with Windows Server

### Deploy and manage Azure IaaS Active Directory domain controllers in Azure



https://learn.microsoft.com/en-us/training/paths/deploy-manage-identity-infrastructure/https://learn.microsoft.com/en-us/training/paths/deploy-manage-identity-infrastructure/