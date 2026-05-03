# Install Active Directory

1. The "Cloud-Only" Hybrid Lab

You can simulate an on-premises data center by creating a specific Virtual Machine in Azure to act as your "Local Server."

Step 1: Create an Azure VM (Windows Server 2025).

Step 2: Treat this VM as if it is sitting in your office. Do not use Azure-specific tools to manage it at first.

Environment

* Rg-ukshybridlab
* vmhybrid01
* Windows (Windows Server 2025 Datacenter)
* Standard B2ms (2 vcpus, 8 GiB memory)

Step 3: Install the Active Directory Domain Services role manually.

In the Azure Portal, the term "Dynamic" or "Static" is hidden inside the IP configuration settings. Since your DC is on 192.168.3.7, you must lock it now so it never changes, as AD will break if Azure's DHCP assigns a new address later.

In the portal go to network settings, NIC, go to settings and ip configuration and set ip to static.

![static](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/static.png)

Since your hostname is set and your IP is now Static in the portal, follow this exact sequence:

## Step A: The Software (Inside the VM) Install-WindowsFeature -Name AD-Domain-Services

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

## Step B: The Promotion (Inside the VM) Promote this server to a domain controller

1. In Server Manager, click the Yellow Warning Flag > Promote this server to a domain controller.

![promote](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/promote.png)

2. Select Add a new forest.
3. Root Domain Name: lab.local (or whatever you prefer).
4. Functional Level: Choose Windows Server 2025.
5. Type your DSRM Password (keep this safe!). Thatswhatwedo104 (it is imsdal promoted user)
6. Click through the defaults and click Install. The server will reboot.

![boot](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/boot.png)

This error is very common when building a lab. It happens because Windows has a "pending" operation (like the role installation itself or a background update) that requires a fresh boot before it allows the deeper system changes needed for a Domain Controller.

1. Restart the VM Now
Even if you think you haven't changed anything, Windows Server 2025 often triggers background prerequisite updates when the AD DS role is added. Restart vmhybrid01 and wait 2 minutes for all services to start.

2. Login and check for Pending Updates

![update](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/update.png)

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

![ad_install](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/ad_install.png)

Post-Install Verification Checklist

Log in with your original admin user


Once the server reboots (which will take longer than usual because it is building the NTDS database), log in as LAB\Administrator and check these three things to ensure your AZ-800 lab is healthy:

This confirms your setup is technically correct. Your provisioned user was "promoted" along with the server. Here is the breakdown of why you see those specific paths—this is actually a prime AZ-800 troubleshooting topic regarding the difference between Builtin and Users.


![new_admin](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/new_admin.png)


## Step C: The Azure "Bridge" (In the Portal) use domain controller vm as DNS server

This is the step most people forget.

1. Go to the Virtual Network (VNet) where 192.168.3.x exists.
2. On the left, click DNS Servers.
3. Select Custom.
4. Enter 192.168.3.7.
5. Click Save.


![vnet](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/vnet.png)

Why Step C is the most important for AZ-800:
By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.


One Final Warning (The Azure DNS Loop)
After you click Save in the Portal:

1. Azure doesn't update the VM immediately. The VM only picks up this change when its DHCP lease renews or it reboots.

2. The "Forwarder" Requirement: Now that your VNet is pointing to your DC for DNS, your DC is responsible for resolving the internet.

3. Action: In your VM, open the DNS Manager (dnsmgmt.msc).

4. Right-click your Server Name > Properties > Forwarders.

5. Ensure it points to 168.63.129.16 (Azure's internal recursive resolver) or 8.8.8.8. This ensures your DC can still download Windows Updates and talk to Azure services.

![dns forward](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/dns_forward.png)


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

## Step D: Domain controller forward VM's Internet Access

One Critical Fix for Linux Internet Access.

Since your Linux machines are now going to ask 192.168.3.7 for everything (including google.com or Ubuntu update mirrors), you must ensure the Windows DC knows how to "pass the ball."

If you haven't done this yet, do it now on vmhybrid01:

1. Open DNS Manager.

2. Right-click vmhybrid01 > Properties > Forwarders.

3. Add 168.63.129.16 (Azure's DNS).

Test from Linux: Run dig @192.168.3.7 google.com. If you get an IP back, your Linux VMs will have seamless internet access since you did Step C.

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

Since the "plumbing" is finished and your Linux machines are successfully talking to your Windows Server 2025 DC, we can move into the actual administration phase.

### Why "Ready" for DNS doesn't mean "Ready" for APT

In networking, successful name resolution is only the first half of the equation. Here is why apt update still fails even though dig succeeds:

🔵 DNS (The Map): vmchaos03 asks 192.168.3.7, "Where is Google?" The DC answers, "It's at 142.250.140.102." This works because the path to your DC is internal (Private IP to Private IP).

🔴 Routing (The Road): vmchaos03 then tries to send a request to 142.250.140.102. Since it has no Public IP or NAT Gateway, the Azure fabric sees a private-only VM trying to talk to a public-only address and drops the packet at the edge.

The Status of your Hybrid Environment

You have successfully achieved the Hybrid Identity/Infrastructure goal of the AZ-800:

🔵 Active Directory Integration: Your Linux nodes are respecting the Windows DC as the source of truth for DNS.

🔵 Internal Connectivity: VNet peering or local routing is allowing the VMs to talk to the DC at 192.168.3.7.

🔴 Missing Internet Egress: Because you are keeping vmchaos03 private, it is technically "secure by isolation," which prevents standard apt operations.

## Extra section: The HTTP Proxy Method for outbund private vms (apt)

Instead of moving files manually, you can install a lightweight proxy (like Squid for Windows or even using WinGate) on your DC. Once that is running, you simply tell the Linux VM to "tunnel" its apt requests through the DC.

WinGate8.5.9.4883-USE.exe

Administrator and none

![wingate](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/wingate.png)

Step 1: Install the WWW Proxy Service

Select WWW Proxy Service from that list.

Click Next >.

Name the Service: You can leave it as "WWW Proxy Server."

Important - Change the Port: When the wizard asks for the port, change it from 80 to 3128. This avoids the conflict with IIS on your Domain Controller.

Bindings: Ensure it is bound to your internal IP address (192.168.3.7).

start the service

![wingate_service](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/wingate_service.png)

Final Firewall Check (On the DC)
Before moving to the Linux terminal, ensure the Windows Firewall is allowing traffic on that new port. Run this in PowerShell as Administrator:

```ps1
New-NetFirewallRule -DisplayName "WinGate Proxy 3128" -Direction Inbound -LocalPort 3128 -Protocol TCP -Action Allow
```



On vmchaos03, you would create a proxy configuration file:

```bash
# test proxy
nc -zv 192.168.3.7 3128
Connection to 192.168.3.7 3128 port [tcp/*] succeeded!

# Add the proxy configuration for apt
echo 'Acquire::http::Proxy "http://192.168.3.7:3128";' | sudo tee /etc/apt/apt.conf.d/99proxy
echo 'Acquire::https::Proxy "http://192.168.3.7:3128";' | sudo tee -a /etc/apt/apt.conf.d/99proxy

# update
sudo apt update
sudo apt upgrade

```

* Result: When you run sudo apt update, the VM asks the DC to fetch the files for it.

* Security: Your VM stays private, and you can log exactly what the VM is downloading on the DC.

🔵 Summary of the Data Path

vmchaos03 -> (Outbound from Linux)

Windows DC -> (Inbound to Port 3128 - Allowed by your rule)

WinGate Service -> Processes request

Windows DC -> (Outbound to Internet - Allowed by default)

By using WinGate and a strictly configured firewall, you have created a one-way exit for your private VM, not an entrance for hackers.

![wingate_10_vms](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/images/wingate_10_vms.png)

## Extra section: Network gateway and port proxy for inbound private vms

Since your Windows Server (vmhybrid01) has a public IP and sits in the same network as your private Linux box (docker03getmirrortest), you can use it as a ***Network Gateway***.

NSG outbound for offline vm docker03getmirrortest is internet deny and it has no public IP, so we cannot reach it.

* Just private, 172.64.0.5

![deny_internet](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/deny_internet.png)

1. The "Signpost" Command (Windows)
On your Windows Server 2025, open PowerShell as Administrator and run this command:

```ps1
# Add the new one on Port 10934
# Run this on your Windows Server to create a dedicated lane for the Linux traffic:
netsh interface portproxy add v4tov4 listenport=10934 listenaddress=0.0.0.0 connectport=10933 connectaddress=172.64.0.5
```
* listenport=10934: The port Octopus will call, we up one port since we already have at tentacle for vmhybrid01
* listenaddress=0.0.0.0: Tells Windows to listen on all its IPs (including the public one).
* connectaddress: This is the internal/private IP of your Linux machine.

2. Open the Windows Firewall

```ps1
New-NetFirewallRule -DisplayName "Octopus Linux Forwarding" -Direction Inbound -LocalPort 10934 -Protocol TCP -Action Allow
```

Add NSG also for vmhybrid01 for inbound 10934 since we already have a tenatcle for vmhybrid01, we must use a different port for docker03getmirrortes.


### netsh interface

The netsh interface command provides a comprehensive set of tools for configuring and managing network interfaces in Windows.

```ps1
netsh interface [6to4 | clat | dump | fl48 | fl68 | help | httpstunnel | ipv4 | ipv6 | isatap | portproxy | set | show | tcp | teredo | udp | ?]
```
v4tov4

* Adds a proxy rule to listen on an IPv4 address and port, forwarding incoming TCP connections to another IPv4 address and port.


https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-interface

## Tools

dsa.msc — Active Directory Users and Computers (The classic tool for users, groups, and OUs).

dsac.exe — Active Directory Administrative Center (The modern "Blue" UI; it has the Recycle Bin and PowerShell History).

gpmc.msc — Group Policy Management Console (Where you manage the rules).

dnsmgmt.msc - DNS Manager


## Now go to README 3 MS Learn Active Directory Domain Services




