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

Log in with your original admin user


Once the server reboots (which will take longer than usual because it is building the NTDS database), log in as LAB\Administrator and check these three things to ensure your AZ-800 lab is healthy:

This confirms your setup is technically correct. Your provisioned user was "promoted" along with the server. Here is the breakdown of why you see those specific paths—this is actually a prime AZ-800 troubleshooting topic regarding the difference between Builtin and Users.


![new_admin](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/new_admin.png)


Step C: The Azure "Bridge" (In the Portal)
This is the step most people forget.

1. Go to the Virtual Network (VNet) where 192.168.3.x exists.
2. On the left, click DNS Servers.
3. Select Custom.
4. Enter 192.168.3.7.
5. Click Save.


![vnet](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/vnet.png)

Why Step C is the most important for AZ-800:
By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.


One Final Warning (The Azure DNS Loop)
After you click Save in the Portal:

1. Azure doesn't update the VM immediately. The VM only picks up this change when its DHCP lease renews or it reboots.

2. The "Forwarder" Requirement: Now that your VNet is pointing to your DC for DNS, your DC is responsible for resolving the internet.

3. Action: In your VM, open the DNS Manager (dnsmgmt.msc).

4. Right-click your Server Name > Properties > Forwarders.

5. Ensure it points to 168.63.129.16 (Azure's internal recursive resolver) or 8.8.8.8. This ensures your DC can still download Windows Updates and talk to Azure services.

![dns forward](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-800-admistering-windows-server-hybrid-core-infrastructure/images/dns_forward.png)


In your specific lab scenario, you are absolutely correct: if you only ever connect to your other VMs using their IP addresses (like 192.168.3.10), they will continue to function exactly as they do now.

However, since you're prepping for the AZ-800, you need to be aware of the "silent" consequences. When you switch that Azure VNet setting to Custom, you are changing the "Source of Truth" for those VMs.


1. The Linux Connectivity Test
On your Linux VM, you can use dig or nslookup. These tools will tell you if the Linux machine is actually talking to your Windows DC for its DNS queries.

Test 1: Check the AD Domain Resolution

```bash
dig @192.168.3.7 lab.local

```

log

```log
dig @192.168.3.7 lab.local

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> @192.168.3.7 lab.local
; (1 server found)
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24907
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;lab.local.                     IN      A

;; ANSWER SECTION:
lab.local.              600     IN      A       192.168.3.7

;; Query time: 1 msec
;; SERVER: 192.168.3.7#53(192.168.3.7) (UDP)
;; WHEN: Fri Feb 27 13:38:27 UTC 2026
;; MSG SIZE  rcvd: 54
```

That dig output is a beautiful sight. It confirms three critical things for your lab:

1. Connectivity: Your Linux VM can talk to the Windows DC over Port 53.
2. Authority: The aa flag (Authoritative Answer) means your DC is confidently claiming it owns the lab.local zone.
3. Resolution: It correctly mapped lab.local to the IP 192.168.3.7.

One Critical Fix for Linux Internet Access
Since your Linux machines are now going to ask 192.168.3.7 for everything (including google.com or Ubuntu update mirrors), you must ensure the Windows DC knows how to "pass the ball."

If you haven't done this yet, do it now on vmhybrid01:

1. Open DNS Manager.

2. Right-click vmhybrid01 > Properties > Forwarders.

3. Add 168.63.129.16 (Azure's DNS).

Test from Linux: Run dig @192.168.3.7 google.com. If you get an IP back, your Linux VMs will have seamless internet access once you finalize "Step C."

```bash
dig @192.168.3.7 google.com
```

log
```log
 dig @192.168.3.7 google.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> @192.168.3.7 google.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51510
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             281     IN      A       142.251.30.102
google.com.             281     IN      A       142.251.30.101
google.com.             281     IN      A       142.251.30.100
google.com.             281     IN      A       142.251.30.139
google.com.             281     IN      A       142.251.30.113
google.com.             281     IN      A       142.251.30.138

;; Query time: 4 msec
;; SERVER: 192.168.3.7#53(192.168.3.7) (UDP)
;; WHEN: Fri Feb 27 13:40:26 UTC 2026
;; MSG SIZE  rcvd: 135
````

Perfect. You are officially 100% ready.

Since you finished Step C a while ago, your infrastructure is officially "locked in." The Linux machines are already talking to the Windows DC, and the Windows DC is talking to the internet.

In the eyes of the AZ-800, you have moved past the Infrastructure phase and are now in the Hybrid Management phase.

What is actually happening right now?
Even if you haven't touched the Linux VMs since changing the portal settings, they have likely already "checked in" with the Azure DHCP server and silently swapped their DNS settings to point to 192.168.3.7.

You can confirm this on any Linux machine by running:

```bash
resolvectl status | grep "DNS Servers"
# DNS Servers: 192.168.3.7
```
