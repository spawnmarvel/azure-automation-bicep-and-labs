# Azure Linux VM Bicep deploy

## How to deploy (with Powershell)

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

## Bash it, Git BASH

Git for Windows provides a BASH emulation used to run Git from the command line. *NIX users should feel right at home, as the BASH emulation behaves just like the "git" command in LINUX and UNIX environments.

https://gitforwindows.org/


```bash
ssh user@serverip
```

![Git Bash ](https://github.com/spawnmarvel/azure-automation/blob/main/images/git_bash.jpg)

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

## List of Basic SSH Commands

| SSH cmds  | Description | Example
|---------- |------------ | ------------------------------
| help      | help pwd    | help pwd
| ls        | Show directory contents (list the names of files) | -a, list all + hidden, -l list all + size
| cd        | Change dir  | 
| mkdir     | Make dir    | 
| touch     | New file    |
| rm        | Remove a file | rmi-f, force
| cat       | Show content of file |  cat keyvault.txt
| pwd       | Show current dir |
| cp        | Copy file/folder | source destination
| mv        | Move file/folder | source destination
| grep      | Search for a phrase in file/lines |
| find      | Search files and dirs
| nano      | Text editor
| history   | Show last 50 cmds
| clear     | Clear terminal
| tar       | Create and unpack compressed archives
| wget      | Download files from internet
| du        | Get file size
| less      | Display the contents of a file one page at a time
| more      | Loads the entire file at once
| curl      | Download or upload data using protocols such as FTP, SFTP, HTTP and HTTPS
| top       | Monitor running processes and the resources (such as memory) they are currently using
| which     | Identify and report the location of the provided executable

## Script

1. touch myScript.sh

2. nano myScript.sh

```bash

#!/bin/bash

echo "Start script"

sleep 3

echo "End script"

```

3. Run it
```bash

# Run it 1
bash myScript.sh
# Run it 2, Permission denied
./myScript.sh
# Get permission
ls -l
# -rw-r--r-- no execute, add it
chmod +x myScript.sh
# Get permission
ls -l
# -rwxr-xr-r- 
# Run it 3
./myScript.sh

# When we write functions and shell scripts, in which arguments are passed in to be processed, 
# the arguments will be passed int numerically-named variables, e.g. $1, $2, $3
myScript.sh Hello World 42

# The variable reference, $0, will expand to the current script's name, e.g. my_script.sh

```


## Bash variables and command substitution

```bash
# Variables
* var_a="Hello World" (notice no space)

¤ Referencing the value of a variable
echo $var_a

# Failure to dereference
echo "$var_a"
Hello World

echo '$var_a'
$var_a

```

Valid variable names
* Should start with either an alphabetical letter or an underscore
* hey, x9, THESQL_STRING, _secret


The internal field separator
* The global variable IFS is what Bash uses to split a string of expanded into separate words
* By default, the IFS variable is set to three characters: newline, space, and the tab. If you echo $IFS, you won't see anything because those characters

http://www.compciv.org/topics/bash/variables-and-substitution/


## Linux on Azure MS Learn

```bash
az login --tenant 6dae3ddb-0cf5-4fa6-a49c-c32ae6589d1f

```

https://github.com/spawnmarvel/azure-automation/blob/main/azure-extra-linux-vm/READMELinuxOnAzure.md

## Learn to use Bash with the Azure CLI (quick guide)

* Query results as JSON dictionaries or arrays
* Format output as JSON, table, or TSV
* Query, filter, and format single and multiple values
* Use if/exists/then and case syntax
* Use for loops
* Use grep, sed, paste, and bc commands
* Populate and use shell and environment variables


https://learn.microsoft.com/en-us/cli/azure/azure-cli-learn-bash


## az deployment

https://learn.microsoft.com/en-us/cli/azure/deployment?view=azure-cli-latest#az-deployment-create

## Bash for Beginners

https://learn.microsoft.com/en-us/shows/bash-for-beginners/

Bash for Beginners GitHub Repository

https://github.com/microsoft/bash-for-beginners?wt.mc_id=youtube_S-1076_video_reactor




```bash
## comment
ls

```

Learn the ways of Linux-fu, for free.

https://linuxjourney.com/



