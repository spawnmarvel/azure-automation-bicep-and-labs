# Install Active Directory

1. The "Cloud-Only" Hybrid Lab

You can simulate an on-premises data center by creating a specific Virtual Machine in Azure to act as your "Local Server."

* Step 1: Create an Azure VM (Windows Server 2025).
* Step 2: Treat this VM as if it is sitting in your office. Do not use Azure-specific tools to manage it at first.

Environment

* Rg-ukshybridlab
* vmhybrid01
* Windows (Windows Server 2025 Datacenter)
* Standard B2ms (2 vcpus, 8 GiB memory)

Step 3: Install the Active Directory Domain Services role manually.

In the Azure Portal, the term "Dynamic" or "Static" is hidden inside the IP configuration settings. Since your DC is on 192.168.3.7, you must lock it now so it never changes, as AD will break if Azure's DHCP assigns a new address later.

In the portal go to network settings, NIC, go to settings and ip configuration and set ip to static.

![static](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/static.png)

Since your hostname is set and your IP is now Static in the portal, follow this exact sequence:

Step A: The Software (Inside the VM)

Login to server

```ps1
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
```

Log

```log
Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {Active Directory Domain Services, Group P...
```

Step B: The Promotion (Inside the VM)

1. In Server Manager, click the Yellow Warning Flag > Promote this server to a domain controller.

![promote](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/promote.png)

2. Select Add a new forest.
3. Root Domain Name: lab.local (or whatever you prefer).
4. Functional Level: Choose Windows Server 2025.
5. Type your DSRM Password (keep this safe!). Thatswhatwedo104
6. Click through the defaults and click Install. The server will reboot.

![boot](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/boot.png)

This error is very common when building a lab. It happens because Windows has a "pending" operation (like the role installation itself or a background update) that requires a fresh boot before it allows the deeper system changes needed for a Domain Controller.

1. Restart the VM Now
Even if you think you haven't changed anything, Windows Server 2025 often triggers background prerequisite updates when the AD DS role is added. Restart vmhybrid01 and wait 2 minutes for all services to start.

2. Login and check for Pending Updates

![update](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/update.png)

Final Step: Re-running the Promotion

```ps1
# This command promotes your server to a new forest named 'lab.local'
# It will prompt you for the DSRM password twice.
Import-Module ADDSDeployment
Install-ADDSForest `
    -DomainName "lab.local" `
    -DomainNetbiosName "LAB" `
    -ForestMode "Win2025" `
    -DomainMode "Win2025" `
    -InstallDns:$true `
    -NoRebootOnCompletion:$false

```

![ad_install](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/ad_install.png)

Post-Install Verification Checklist

Once the server reboots (which will take longer than usual because it is building the NTDS database), log in as LAB\Administrator and check these three things to ensure your AZ-800 lab is healthy:

1. The "Active Directory" Tools: Go to Tools in Server Manager and verify you can open Active Directory Users and Computers.
2. DNS Loopback: Check your IPv4 settings. It should now automatically be set to 127.0.0.1.

3. The Firewall Profile: Because you are on Windows Server 2025, verify your firewall says "Domain Profile is Active". There is a known 2025 bug where it sometimes stays on "Public." If it is on Public, run this:

Restart-NetAdapter *


Step C: The Azure "Bridge" (In the Portal)
This is the step most people forget.

1. Go to the Virtual Network (VNet) where 192.168.3.x exists.
2. On the left, click DNS Servers.
3. Select Custom.
4. Enter 192.168.3.7.
5. Click Save.

Why Step C is the most important for AZ-800:
By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.




