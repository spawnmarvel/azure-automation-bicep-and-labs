# MS Tutorials for Linux

https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-bicep?tabs=CLI


![Linux tutorials ](https://github.com/spawnmarvel/azure-automation/blob/main/images/linux_tutorials.jpg)

Just follow next steps

![Next step ](https://github.com/spawnmarvel/azure-automation/blob/main/images/next_steps.jpg)

## Quickstart: Create an Ubuntu Linux virtual machine using a Bicep file

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=CLI

### Modifications, since the template was not made for redeploy when resources existed.

* i.e default template was deployed, tried to change SKU, but it prompted error about vnet elready existing
* * This will happen when the subnet is declared as a child resource. 
* *  It is instead recommended to create all the subnets in the array property inside of the vnet, like you are doing with the first subnet in the above code sample:
* * https://github.com/Azure/bicep/issues/4653

``` bash
// Not able to redeploy due to hardcode subnet
// Edit from

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    [...]

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

//To
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    // 1. It is instead recommended to create all the subnets in the array property inside of the vnet, like you are doing with the first subnet in the above code sample:
    // 1. https://github.com/Azure/bicep/issues/4653
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      [...]

// And had to update reference subnet id on the NetworkInterface
// From
subnet: {
            id: subnet.id
          }

// To
subnet: {
             // 1.2 And had to update reference subnet id on the NetworkInterface
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnetName)
          }

```
### Add a data disk

``` bash
  // 2. Add a data disk start
 dataDisks:[
        {
          diskSizeGB:8
          lun:0
          createOption:'Empty'
          name:'${vmName}-dataDiskLun0'
        }
      ]
     // 2. Add a datadisk end
```

* Place in existing vnet in a different rg

## Login,  view outputs from deployments in main

* output adminUsername string = adminUsername
* output hostname string = publicIPAddress.properties.dnsSettings.fqdn
* output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'

![Output ](https://github.com/spawnmarvel/azure-automation/blob/main/images/linux_output.jpg)


```bash
ssh user@serverip
```


## Attach an new data disk

1. Use the portal to attach a data disk to a Linux VM
https://learn.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal?tabs=ubuntu

### Find the disk

We attached it above with Bicep, now find the disk, prepare it, mount and verify it.

``` bash
# 1 Find the disk
lsblk

sda       8:0    0   30G  0 disk
sdb       8:16   0   16G  0 disk
sdc       8:32   0    8G  0 disk


# 1.1 
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

sda     0:0:0:0      30G
├─sda1             29.9G /
├─sda14               4M
└─sda15             106M /boot/efi
sdb     0:0:0:1      16G
└─sdb1               16G /mnt
sdc     1:0:0:0       8G


# In this example, the disk that was added was sdc. It's a LUN 0 and is 8GB.

# 3 Prepare a new empty disk (Important If you are using an existing disk that contains data, skip to mounting the disk. The following instructions will delete data on the disk.)
# The following example uses parted on /dev/sdc, which is where the first data disk will typically be on most VMs. 
# Replace sdc with the correct option for your disk. We're also formatting it using the XFS filesystem.
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1

// 4 Mount the disk
sudo mkdir /datadrive
sudo mount /dev/sdc1 /datadrive

# 5 Verify mount
lsblk

[...]
sdc       8:32   0    8G  0 disk
└─sdc1    8:33   0    8G  0 part /datadrive

# 6 To ensure that the drive is remounted automatically after a reboot, it must be added to the /etc/fstab file.
#  It's also highly recommended that the UUID (Universally Unique Identifier) is used in /etc/fstab to refer to the drive rather than just the device name (such as, /dev/sdc1)
#  To find the UUID of the new drive, use the blkid utility:
sudo blkid

[...]
/dev/sdc1: UUID="5fb6228d-e3d4-4666-a291-8c311bbe6c7f" TYPE="xfs" PARTLABEL="xfspart" PARTUUID="a149db51-bd45-4ad7-876a-39b140b19ee1"

# Next, open the /etc/fstab file in a text editor. 
// Add a line to the end of the file, using the UUID value for the /dev/sdc1 device that was created in the previous steps, and the mountpoint of /datadrive. 
sudo nano /etc/fstab

UUID=5fb6228d-e3d4-4666-a291-8c311bbe6c7f   /datadrive   xfs   defaults,nofail   1   2
# CTRL + X and Y

# 7 Verify mount
lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

# Enter drive
cd /datadrive
pwd

# Display Usage in Megabytes and Gigabytes
df -h

```

## Tutorial: Create and Manage Linux VMs with the Azure CLI


* Create and connect to a VM
* Select and use VM images
* View and use specific VM sizes
* Resize a VM
* View and understand VM state

```bash

rgName='Rg-az-quickstarts-001'
az group create --name $rgName --location uksouth

# Create virtual machine

az vm create \
    --resource-group $rgName \
    --name vmhodor0045 \
    --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
    --size Standard_B2ms \
    --admin-username azureuser \
    --generate-ssh-keys

# Take note of the publicIpAddress, this address can be used to access the virtual machine.
# Connect to VM
ssh azureuser@ip-address

# Understand VM images
# To see a list of the most commonly used images, use the az vm image list command.
az vm image list --output table

# A full list can be seen by adding the --all parameter. The image list can also be filtered by --publisher or –-offer. In this example, 
# the list is filtered for all images, published by Canonical, with an offer that matches UbuntuServer.
az vm image list --offer UbuntuServer --publisher Canonical --all --output table


```
NOTE:
Canonical has changed the Offer names they use for the most recent versions. Before Ubuntu 20.04, the Offer name is UbuntuServer. For Ubuntu 20.04 the Offer name is 0001-com-ubuntu-server-focal and for Ubuntu 22.04 it's 0001-com-ubuntu-server-jammy.

Understand VM sizes

```bash
# Find available VM sizes
az vm list-sizes --location eastus2 --output table


# Create VM with specific size
rgName='Rg-az-quickstarts-001'

az vm create \
    --resource-group $rgName \
    --name vmhodor0045 \
    --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
    --size Standard_B2ms \
    --admin-username azureuser \
    --generate-ssh-keys

# After a VM has been deployed, it can be resized to increase or decrease resource allocation. 
# You can view the current of size of a VM with az vm show:
rgName='Rg-az-quickstarts-001'
az vm show --resource-group $rgName --name vmhodor0045 --query hardwareProfile.vmSize

"Standard_B2ms"

{
  "additionalCapabilities": null,
  "applicationProfile": null,
  "availabilitySet": null,
  "billingProfile": null,
  "capacityReservation": null,
  "diagnosticsProfile": null,
  "evictionPolicy": null,
  "extendedLocation": null,
  "extensionsTimeBudget": null,
  "hardwareProfile": {
    "vmSize": "Standard_B2ms",
    "vmSizeProperties": null


# Before resizing a VM, check if the desired size is available on the current Azure cluster. The az vm list-vm-resize-options command returns the list of sizes.
rgName='Rg-az-quickstarts-001'
az vm list-vm-resize-options --resource-group $rgName --name vmhodor0045 --query [].name

# If the desired size is available, the VM can be resized from a powered-on state, however it is rebooted during the operation. 
# Use the az vm resize command to perform the resize.
rgName='Rg-az-quickstarts-001'
az vm resize --resource-group $rgName --name vmhodor0045 --size Standard_B4ms

# If the desired size is not on the current cluster, the VM needs to be deallocated before the resize operation can occur. Use the az vm deallocate command to stop and deallocate the VM. Note, when the VM is powered back on, any data on the temp disk may be removed. 


```

VM power states

* Starting, Running, Stopping, Stopped.
* 
* Deallocating, Indicates that the virtual machine is being deallocated.
* Deallocated, Indicates that the virtual machine is removed from the hypervisor but still available in the control plane. Virtual machines in the Deallocated state do not incur compute charges.
* -, Indicates that the power state of the virtual machine is unknown.

```bash
# Find the power state
rgName='Rg-az-quickstarts-001'
vmName='vmhodor0045'
az vm get-instance-view \
    --name $vmName \
    --resource-group $rgName \
    --query instanceView.statuses[1] --output table

Code                Level    DisplayStatus
------------------  -------  ---------------
PowerState/running  Info     VM running

```

Management tasks

```bash

# Get IP address
rgName='Rg-az-quickstarts-001'
vmName='vmhodor0045'
az vm list-ip-addresses --resource-group $rgName --name $vmName --output table

# Stop virtual machine
az vm stop --resource-group $rgName --name $vmName

About to power off the specified VM...
It will continue to be billed. To deallocate a VM, run: az vm deallocate.

# Dealloctaed virtual machine
az vm deallocate --resource-group $rgName --name $vmName

# Start virtual machine
az vm start --resource-group $rgName --name $vmName

# Deleting a resource group also deletes all resources in the resource group, like the VM, virtual network, and disk. 
az group delete --name $rgName --no-wait --yes


```
https://learn.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm


## Tutorial - Manage Azure disks with the Azure CLI

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-disks

