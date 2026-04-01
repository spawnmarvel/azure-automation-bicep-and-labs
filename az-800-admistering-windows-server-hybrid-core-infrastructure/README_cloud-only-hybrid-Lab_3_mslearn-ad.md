# MS Learn Active Directory Domain Services

https://learn.microsoft.com/en-us/training/paths/active-directory-domain-services/


## Tools

dsa.msc — Active Directory Users and Computers (The classic tool for users, groups, and OUs).

dsac.exe — Active Directory Administrative Center (The modern "Blue" UI; it has the Recycle Bin and PowerShell History).

gpmc.msc — Group Policy Management Console (Where you manage the rules).

dnsmgmt.msc - DNS Manager

## Introduction to AD DS

### Active Directory Domain Services (AD DS)
AD DS is the central "brain" of a Windows enterprise network, providing a searchable database and a framework for managing users, security, and configurations.

📋 Comprehensive Component List
* Logical Components (The Design)
* Partition: A specific segment of the database (e.g., Schema, Configuration, or Domain) that stores specialized data.
* Schema: The master set of rules and definitions that determine what types of objects can be created and what info they can store.
* Domain: The core administrative boundary; a container for users, computers, and groups.
* Domain Tree: A group of domains linked together in a hierarchy sharing a common root and DNS namespace.
* Forest: The top-level container; a collection of one or more trees that share a single schema and global catalog.
* Organizational Unit (OU): A sub-container used to organize objects and, crucially, to link Group Policy Objects (GPOs) and delegate admin rights.
* Container: A default storage folder for objects; unlike an OU, you cannot link Group Policies to a container.

* Physical Components (The Infrastructure)
* Domain Controller (DC): The physical or virtual server that hosts the database and handles authentication requests.
* Data Store: The actual file (Ntds.dit) and log files stored on the disk (usually in C:\Windows\NTDS).
* Global Catalog Server: A specialized DC that keeps a "summary" of every object in the forest to make cross-domain searching faster.
* Read-Only Domain Controller (RODC): A restricted, non-writable version of a DC used in locations where physical security is a concern.
* Site: A group of well-connected computers representing a physical location (like a branch office) to manage network traffic.
* Subnet: A range of IP addresses mapped to a Site to help the system understand where a computer is physically located on the network.

### Active Directory Objects: Users, Groups, and Computers
In AD DS, resources and identities are managed as objects. These are the digital representations of the people, services, and hardware that interact with your network.

📋 Core Object Types
* User Objects
* Standard User Accounts: Required for any person needing network access. Contains a username, password, and group memberships.
* Managed Service Account (MSA): Used specifically for applications/services. It simplifies management by automatically handling password rotations.
* Group Managed Service Account (gMSA): An extension of MSAs that allows multiple servers (like a web farm) to use the same managed account with automatic password syncing.
* Delegated Managed Service Account (dMSA): A new Windows Server 2025 feature that binds authentication to specific device identities, preventing credential harvesting from compromised accounts.

* Group Objects
Groups are used to manage permissions efficiently. Instead of assigning rights to 100 individuals, you assign them to one group.

Group Types:
* Security Groups: Used to assign permissions to resources (files, printers, etc.) via Access Control Lists (ACLs).
* Distribution Groups: Used solely for email lists; they are not security-enabled and cannot be used for permissions.

Group Scopes:
| Scope | Membership Source | Where it can be used |
| :--- | :--- | :--- |
| Local | Anywhere in the forest | Only on the specific local computer. |
| Domain-Local | Anywhere in the forest | Anywhere within the local domain. |
| Global | Only the local domain | Anywhere in the entire forest. |
| Universal | Anywhere in the forest | Anywhere in the entire forest. |

* Computer Objects
Computers are considered "Security Principals," much like users.
* Authentication: Computers have their own hidden passwords that AD changes automatically; they must authenticate to the domain to function.
* Management: Like users, computers can be members of groups and receive settings via Group Policy.
* Containers vs. OUs: By default, new computers land in the CN=Computers container. However, you cannot link Group Policies to a container, so it is best practice to move them into an Organizational Unit (OU).

Best Practice Tip: Always create custom OUs for your computers rather than leaving them in the default "Computers" container. This allows you to apply specific security policies (GPOs) to your machines.

### AD DS Architecture: Forests and Domains
Active Directory Domain Services (AD DS) uses a hierarchical structure to define security, administration, and data replication boundaries.

📋 Architecture Components
* The AD DS Forest
The Forest is the highest-level container in Active Directory. It represents the ultimate security and replication boundary for an entire organization.

* Security Boundary: By default, no users outside the forest can access internal resources.
* Replication Boundary: Configuration and schema partitions replicate forest-wide. Applications requiring different schemas must reside in separate forests.
* Forest Root Domain: The first domain created in the forest. It uniquely holds the Schema Master, Domain Naming Master, and the Enterprise/Schema Admins groups.
* Commonality: All domains in a forest share a common root, a common schema, and a common global catalog.

* The AD DS Domain
A Domain is a logical container used to organize and manage objects like users, computers, and groups.

* Administrative Unit: Contains a local Administrator account and a Domain Admins group with full control over the domain's specific objects.
* Replication Boundary: Changes to domain objects replicate to all domain controllers within that specific domain, but only a subset (via Global Catalog) replicates to other domains.
* Authentication & Authorization: The domain verifies user/computer credentials and determines access rights to specific resources.
* Scalability: A single domain can host nearly two billion objects, meeting the needs of most organizations.

📋 Trust Relationships
Trusts allow users in one domain to access resources in another. By default, domains in the same forest have two-way transitive trusts.

* Parent and Child: Automatically created, two-way transitive trust between a parent domain (e.g., contoso.com) and its child (e.g., seattle.contoso.com).
* Tree-Root: Automatically created, two-way transitive trust when a new domain tree is added to an existing forest.
* Forest Trust: A transitive trust that allows two entirely separate forests to share resources.
* Shortcut Trust: A non-transitive trust manually created to speed up authentication between two distant domains in a forest.
* External Trust: A non-transitive trust for connecting to legacy NT 4.0 domains or specific domains in another forest.
* Realm Trust: Connects AD DS to a non-Windows Kerberos v5 directory service.

Tip: Use Transitive trusts for broad access (If A trusts B and B trusts C, then A trusts C). Use Non-transitive trusts to strictly limit access between two specific points.

### Organizational Units (OUs) and Containers
An Organizational Unit (OU) is a specialized container within an AD DS domain used to organize objects like users, groups, and computers into a logical, manageable hierarchy.

📋 Core Concepts of OUs
* Purpose of OUs
OUs are created for two primary administrative reasons:
* Group Policy Application: You can link Group Policy Objects (GPOs) directly to an OU. Settings in that GPO automatically apply to all objects inside that OU.
* Delegation of Control: You can assign specific management permissions to a user or group for a particular OU, such as allowing a "Help Desk" group to reset passwords only for the "Sales" OU.

* OU Hierarchy & Design
* Logical Representation: OUs typically mirror an organization's structure, such as by department (HR, IT) or geography (New York, London).
* Nesting: OUs can be placed inside other OUs to create a multi-level hierarchy.
* Best Practice: It is recommended to stay under 10 levels deep to keep the structure manageable; most organizations use 5 or fewer.

📋 Default Containers and OUs
AD DS includes several built-in containers that store system objects. Unlike OUs, you cannot link GPOs to these generic containers.

* Domain Controllers OU: The only OU created by default. It holds the computer accounts for all Domain Controllers.
* Users Container: The default location for new user accounts, guest accounts, and default groups.
* Computers Container: The default location for new computer accounts created in the domain.
* Managed Service Accounts: The default location for managed service accounts (MSAs).
* Foreign Security Principals: Stores trusted objects from domains outside the local forest.

* Hidden "Advanced" Containers
When "Advanced Features" is enabled, these system-level containers become visible:
* LostAndFound: Holds orphaned objects created during replication conflicts.
* System: Contains built-in system settings.
* Program Data: Stores AD data for Microsoft applications like AD FS.
* TPM Devices: Stores recovery information for Trusted Platform Module devices.

Design Tip: Since you cannot link GPOs to the default "Users" or "Computers" containers, always create your own custom OU hierarchy to effectively manage your active accounts.

###  AD DS Management Tools
Managing an Active Directory environment involves using a variety of graphical and command-line interfaces to control objects, security policies, and network topology.

📋 Primary Management Interfaces
* Active Directory Administrative Center (ADAC): The modern, task-oriented GUI based on Windows PowerShell. It is the intended successor to older management snap-ins and allows for multi-domain management, Recycle Bin recovery, and Fine-Grained Password Policy creation.

* Windows Admin Center (WAC): A modern, web-based management platform. It is ideal for remote server management from any browser.
* Constraint: It is highly recommended not to install WAC directly on an AD DS domain controller for security reasons.

📋 Traditional and Specialized Tools
* Remote Server Administration Tools (RSAT): A suite of tools, including the classic "Active Directory Users and Computers" (ADUC), that allows IT pros to manage Windows Server roles from a workstation.
* Active Directory Users and Computers (ADUC): The legacy Microsoft Management Console (MMC) snap-in used for managing most common resources like users, groups, and computers.
* Active Directory Sites and Services: Manages replication, network topology, and site-specific services.

* Active Directory Domains and Trusts: Configures and maintains trust relationships at the domain and forest functional levels.
* Active Directory Schema Snap-in: Used to modify the definitions of AD DS attributes and object classes (this is hidden by default and requires manual registration).
* Active Directory Module for Windows PowerShell: One of the most critical management components, as ADAC and Server Manager are built on these cmdlets.

Pro Tip: Within the Active Directory Administrative Center, you can use the PowerShell History Viewer to see the exact code used to perform GUI actions, which is a great way to learn automation.


## Manage AD DS domain controllers and FSMO roles (Lab)

https://learn.microsoft.com/en-us/training/modules/manage-active-directory-domain-services-flexible-single-master-operation-roles/

## Implement Group Policy Objects

## Manage advanced features of AD DS

## Implement and manage Active Directory Certificate Services
