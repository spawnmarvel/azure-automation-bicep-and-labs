# The "Cloud-Only" Hybrid Lab

1. The "Cloud-Only" Hybrid Lab

You can simulate an on-premises data center by creating a specific Virtual Machine in Azure to act as your "Local Server."

* Step 1: Create an Azure VM (Windows Server 2022).
* Step 2: Treat this VM as if it is sitting in your office. Do not use Azure-specific tools to manage it at first.
* Step 3: Install the Active Directory Domain Services role manually.
* Step 4: Practice the "Hybrid" connection: Install Azure Arc on that VM to "project" it into the Azure Portal.

2. The GitHub "Official" Labs

Microsoft maintains a public repository of the exact labs used in their official instructor-led courses. These are the "gold standard" for practice.

Where to find them: MicrosoftLearning/AZ-800 on GitHub.

* https://github.com/MicrosoftLearning/AZ-800-Administering-Windows-Server-Hybrid-Core-Infrastructure

What's inside: It contains step-by-step .md files that walk you through complex tasks like:

* Implementing Azure File Sync (connecting local files to Azure).

* Configuring Hybrid DNS (so your cloud VMs can find your local servers).

* Setting up Azure AD Connect to sync users.

3. Practice These "Big 5" Hands-on Skills

If you can perform these five tasks without looking at a guide, you will likely pass the lab portion of the exam:

* Group Policy (GPO): Create a policy in "On-Prem" AD and ensure it applies to a member server.

* Azure Arc Onboarding: Use a script to bring a non-Azure server into Azure management.

* Azure File Sync: Set up a Sync Group and observe how local files "tier" to the cloud to save space.

* Windows Admin Center: Install the gateway and manage a server remotely through a web browser.

* DNS Forwarding: Configure conditional forwarders so your Azure VNET can resolve .local domain names.

And also:

Since Identity makes up 30–35% of the AZ-800, you have to be able to do more than just "explain" it. You need to know the exact tools and steps.

You need to do Active Directory (AD DS) labs.