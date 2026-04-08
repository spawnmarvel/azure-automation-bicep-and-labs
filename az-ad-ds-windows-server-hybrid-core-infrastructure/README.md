# Install Active directory


## 1. The "Cloud-Only" Hybrid Lab

You can simulate an on-premises data center by creating a specific Virtual Machine in Azure to act as your "Local Server."

Step 1: Create an Azure VM (Windows Server 2025).

Step 2: Treat this VM as if it is sitting in your office. Do not use Azure-specific tools to manage it at first.

Environment

* Rg-ukshybridlab
* vmhybrid01
* Windows (Windows Server 2025 Datacenter)
* Standard B2ms (2 vcpus, 8 GiB memory)

## Step 2: Install the Active Directory Domain Services role manually.

- Do the Active Diretory Domain Service
- README_cloud-only-hybrid-Lab_3_mslearn-ad.md

Step 4: Practice the "Hybrid" connection: Install Azure Arc on that VM to "project" it into the Azure Portal.



## Step 3. Practice These "Big 6" Hands-on Skills

If you can perform these five tasks without looking at a guide, you will likely pass the lab portion of the exam:

* Configuring Hybrid DNS (so your cloud VMs can find your local servers).

* DNS Forwarding: Configure conditional forwarders so your Azure VNET can resolve .local domain names.

* Group Policy (GPO): Create a policy in "On-Prem" AD and ensure it applies to a member server.

* * Will be coverd in AD DS

* Azure Arc Onboarding: Use a script to bring a non-Azure server into Azure management.

* * https://learn.microsoft.com/en-us/azure/azure-arc/overview

* Azure File Sync: Set up a Sync Group and observe how local files "tier" to the cloud to save space.

* * https://learn.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction

* Windows Admin Center: Install the gateway and manage a server remotely through a web browser.


And also:

Since Identity makes up 30–35% of the AZ-800, you have to be able to do more than just "explain" it. You need to know the exact tools and steps.

You need to do Active Directory (AD DS) labs.