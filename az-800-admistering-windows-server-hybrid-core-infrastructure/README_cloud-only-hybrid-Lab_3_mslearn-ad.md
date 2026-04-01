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
🔹 Logical Components (The Design)
🔹 Partition: A specific segment of the database (e.g., Schema, Configuration, or Domain) that stores specialized data.
🔹 Schema: The master set of rules and definitions that determine what types of objects can be created and what info they can store.
🔹 Domain: The core administrative boundary; a container for users, computers, and groups.
🔹 Domain Tree: A group of domains linked together in a hierarchy sharing a common root and DNS namespace.
🔹 Forest: The top-level container; a collection of one or more trees that share a single schema and global catalog.
🔹 Organizational Unit (OU): A sub-container used to organize objects and, crucially, to link Group Policy Objects (GPOs) and delegate admin rights.
🔹 Container: A default storage folder for objects; unlike an OU, you cannot link Group Policies to a container.

🔹 Physical Components (The Infrastructure)
🔹 Domain Controller (DC): The physical or virtual server that hosts the database and handles authentication requests.
🔹 Data Store: The actual file (Ntds.dit) and log files stored on the disk (usually in C:\Windows\NTDS).
🔹 Global Catalog Server: A specialized DC that keeps a "summary" of every object in the forest to make cross-domain searching faster.
🔹 Read-Only Domain Controller (RODC): A restricted, non-writable version of a DC used in locations where physical security is a concern.
🔹 Site: A group of well-connected computers representing a physical location (like a branch office) to manage network traffic.
🔹 Subnet: A range of IP addresses mapped to a Site to help the system understand where a computer is physically located on the network.

### Active Directory Objects: Users, Groups, and Computers
In AD DS, resources and identities are managed as objects. These are the digital representations of the people, services, and hardware that interact with your network.

📋 Core Object Types
🔹 User Objects
🔹 Standard User Accounts: Required for any person needing network access. Contains a username, password, and group memberships.
🔹 Managed Service Account (MSA): Used specifically for applications/services. It simplifies management by automatically handling password rotations.
🔹 Group Managed Service Account (gMSA): An extension of MSAs that allows multiple servers (like a web farm) to use the same managed account with automatic password syncing.
🔹 Delegated Managed Service Account (dMSA): A new Windows Server 2025 feature that binds authentication to specific device identities, preventing credential harvesting from compromised accounts.

🔹 Group Objects
Groups are used to manage permissions efficiently. Instead of assigning rights to 100 individuals, you assign them to one group.

Group Types:
🔹 Security Groups: Used to assign permissions to resources (files, printers, etc.) via Access Control Lists (ACLs).
🔹 Distribution Groups: Used solely for email lists; they are not security-enabled and cannot be used for permissions.

Group Scopes:
| Scope | Membership Source | Where it can be used |
| :--- | :--- | :--- |
| Local | Anywhere in the forest | Only on the specific local computer. |
| Domain-Local | Anywhere in the forest | Anywhere within the local domain. |
| Global | Only the local domain | Anywhere in the entire forest. |
| Universal | Anywhere in the forest | Anywhere in the entire forest. |

🔹 Computer Objects
Computers are considered "Security Principals," much like users.
🔹 Authentication: Computers have their own hidden passwords that AD changes automatically; they must authenticate to the domain to function.
🔹 Management: Like users, computers can be members of groups and receive settings via Group Policy.
🔹 Containers vs. OUs: By default, new computers land in the CN=Computers container. However, you cannot link Group Policies to a container, so it is best practice to move them into an Organizational Unit (OU).

Best Practice Tip: Always create custom OUs for your computers rather than leaving them in the default "Computers" container. This allows you to apply specific security policies (GPOs) to your machines.

## Manage AD DS domain controllers and FSMO roles

## Implement Group Policy Objects

## Manage advanced features of AD DS

## Implement and manage Active Directory Certificate Services
