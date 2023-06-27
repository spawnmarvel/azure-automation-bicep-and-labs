# Azure Linux 

## Install Azure CLI on Windows

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli



## VSC Terminal Shell Integration

By default, the shell integration script should automatically activate on supported shells launched from VS Code.

https://code.visualstudio.com/docs/terminal/shell-integration

## Bash it, Git BASH

Git for Windows provides a BASH emulation used to run Git from the command line. *NIX users should feel right at home, as the BASH emulation behaves just like the "git" command in LINUX and UNIX environments.

https://gitforwindows.org/

## Bash quick reference

Page1

![Quick 1 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/page1.jpg)

Page 2
![Quick 2 ](https://github.com/spawnmarvel/azure-automation/blob/main/images/page2.jpg)

https://github.com/spawnmarvel/quickguides/blob/main/bash/bash.quickref.pdf

References

Linux Shell Scripting Tutorial - A Beginner's handbook
http://www.cyberciti.biz/nixcraft/linux/docs/uniqlinuxfeat
ures/lsst/
BASH Programming Introduction, Mike G
http://www.tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html
Advanced BASH Scripting Guide, Mendel Cooper
http://tldp.org/LDP/abs/html/



## Azure CLI

```bash

az --version

az upgrade --yes

````


## List of Basic SSH Commands Linux (ubuntu 20.04)

| SSH cmds  | Description | Example
|---------- |------------ | ------------------------------
| help      | help pwd    | help pwd
| whatis    | Find what a command is used for  | whatis ls
| ls        | Show directory contents (list the names of files) | -a, list all + hidden, -l list all + size
| cd        | Change dir  | cd ./folder
| mkdir     | Make dir    |  mkdir folder1
| touch     | New file    | touch file.txt
| rm        | Remove a file | rm file1
| rmdir     | Remove a directory | rmdir folder1
| cat       | Show content of file (redirect to var, content=$(cat data.conf)) |  cat data.conf
| pwd       | Show current dir: example - > | /home/user
| cp        | Copy file use if for backup, source destination | cp data.conf data.conf_bck
| cp -r     | Copy folder, In order to copy a directory on Linux, you have to execute the “cp” command with the “-R” option for recursive and specify the source and destination directories to be copied.  | cp -r folder1 folder2
| mv        | Move/rename file | source destination
| grep      | Search for a string within an output |
| find      | Search files and dirs |
| nano      | Text editor |
| head      | return specified num of lines from top |
| tail      | return specified num of lines from bottom |
| less      | Display the contents of a file one page at a time |
| more      | Loads the entire file at once |
| diff      | find diff between two files |
| cmp       | check if two files are identical |
| comm      | combines diff and cmp |
| sort      | sort content of file while outputting  |
| history   | Show last 50 cmds |
| clear     | Clear terminal |
| echo      | Print | var="Hodor", echo $var
| man       | Access manual pages for all Linux commands |
| uname     | command to get basic information about the OS |
| whoami    | Get the active username |
| export    | export env var |
| zip       | |
| unzip     | |
| ssh       | Secure Shell command | ssh user@ipaddress
| service   | start stop service |
| ps        | display active proc |
| top       | View active processes live with their system usage |
| kill and killall | Kill active processes by process ID or name | 
| df        | Display disk filesystem information |
| mount     | Mount file systems |
| chmod     | Command to change file permissions |
| chown     | Command for granting ownership of files or folders|
| ifconfig  | Display network interfaces and IP addresses  |
| traceroute | Trace all the network hops to reach the destination |
| tar       | Create and unpack compressed archives |
| wget      | Download files from internet |
| du        | Get file size |
| curl      | Download or upload data using protocols such as FTP, SFTP, HTTP and HTTPS |
| sudo apt update| use the apt package management tools to update your local package index |
| sudo apt update && sudo apt upgrade -y | Make sure all current packages are up to date |
| apt list --installed| Get installed packages |
| sudo | which is an acronym for superuser do or substitute user do, is a command that runs an elevated prompt without a need to change your identity. |
| sudo -i     | A simple way to switch to an interactive session as a root user is the following |
| su     | on the other hand, is an acronym for switch user or substitute user. You are basically switching to a particular user and you need the password for the user you are switching to. |
| su - | you are switching to root and you need the root password. |
| su - bryant | switch to the bryant user account including bryant's path and environment variables, use the (-) switch |
| sudo ufw enable | By default, when UFW is enabled, it blocks external access to all ports on the server |
| sudo ufw | Use iptables or ufw to open ports | sudo ufw allow 1022/tcp<br/>sudo ufw allow 'Nginx HTTPS'
| sudo ufw status | list ufw rules |
| iptables | Base firewall for all other firewall utilities to interface with |
| apt, pacman, yum, rpm | Package managers depending on the distro |
| whereis  | Locate the binary, source, and manual pages for a command |
| which     | Identify and report the location of the provided executable |
| useradd and usermod | Add new user or change existing users data |
| passwd | Create or update passwords for existing users|
| git --version | Git is likely already installed in your Ubuntu 22.04 server.| # else: sudo apt update, sudo apt install git, git --version

### https://www.digitalocean.com/community/tutorials/linux-commands

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

# Sudo
sudo ./myScript.sh

# When we write functions and shell scripts, in which arguments are passed in to be processed, 
# the arguments will be passed int numerically-named variables, e.g. $1, $2, $3
myScript.sh Hello World 42

# The variable reference, $0, will expand to the current script's name, e.g. my_script.sh

```


## Bash variables and command substitution

```bash
# Variables
var_a="Hello World" # (notice no space)

# Referencing the value of a variable
echo $var_a

# Failure to dereference
echo '$var_a'
$var_a
echo "$var_a"
Hello World

```

Valid variable names
* Should start with either an alphabetical letter or an underscore
* hey, x9, THESQL_STRING, _secret


The internal field separator
* The global variable IFS is what Bash uses to split a string of expanded into separate words
* By default, the IFS variable is set to three characters: newline, space, and the tab. If you echo $IFS, you won't see anything because those characters

http://www.compciv.org/topics/bash/variables-and-substitution/
 
## Linux disks and path/folder information
| The "thing mentioned"     | Description | Example
| -------------------------| ----------- | -------
|/dev/sda | The OS disk is labeled,/dev/sda. OS disk should not be used for applications or data. For applications and data, use data disks | https://learn.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-disks *
|/dev/sdb | Temporary disks use a solid-state drive that is located on the same Azure host as the VM. Temp disks are highly performant and may be used for operations such as temporary data processing.| mountpoint of /mnt *
|/dec/sdc | Data disk(s) | Attach disk at VM creation or Attach disk to existing VM, Prepare data disks, Mount and /etc/fstab
|Linux drive letter | Applications and users should not care what SCSI device letter a particular storage gets, because those sdX letters can change and are expected to change. Instead, the storage should be addressed by some unique and permanent property, such as the LUN WWID or filesystem UUID.| https://access.redhat.com/discussions/6004221

## Initial Server Setup with Ubuntu 20.04 TODO

* Step 1 — Logging in as root
* Step 2 — Creating a New User
* Step 3 — Granting Administrative Privileges
* Step 4 — Setting Up a Basic Firewall
* Step 5 — Enabling External Access for Your Regular User


https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04

## Linux on Azure MS Learn

This comprehensive learning path reviews deployment and management of Linux on Azure. Learn about cloud computing concepts, Linux IaaS and PaaS solutions and benefits and Azure cloud services.

Discover how to migrate and extend your Linux-based workloads on Azure with improved scalability, security, and privacy.

```bash
az login --tenant 6dae3ddb-0cf5-4fa6-a49c-c32ae6589d1f

```

https://github.com/spawnmarvel/azure-automation/blob/main/azure-extra-linux-vm/READMELinuxOnAzure.md

## Learn to use Bash with the Azure CLI (quick guide)

Azure CLI reference commands can execute in several different shell environments, but Microsoft Docs primarily use the Bash environment. If you are new to Bash and also the Azure CLI, you will find this article a great place to begin your learning journey. Work through this article much like you would a tutorial, and you'll soon be using the Azure CLI in a Bash environment with ease.

* Query results as JSON dictionaries or arrays
* Format output as JSON, table, or TSV
* Query, filter, and format single and multiple values
* Use if/exists/then and case syntax
* Use for loops
* Use grep, sed, paste, and bc commands
* Populate and use shell and environment variables


https://learn.microsoft.com/en-us/cli/azure/azure-cli-learn-bash


## Reference az deployment create (Manage Azure Resource Manager template deployment at subscription scope)

https://learn.microsoft.com/en-us/cli/azure/deployment?view=azure-cli-latest#az-deployment-create


## MS Tutorials for Linux TODO

https://github.com/spawnmarvel/azure-automation/blob/main/azure-extra-linux-vm/READMEQuickstartsLinuxMS.md

## Bash for Beginners TODO

https://learn.microsoft.com/en-us/shows/bash-for-beginners/

Bash for Beginners GitHub Repository

https://github.com/microsoft/bash-for-beginners?wt.mc_id=youtube_S-1076_video_reactor

## Examples bash from Bash for Beginners tutorial above (quick guide)

https://github.com/spawnmarvel/azure-automation/tree/main/azure-extra-linux-vm/bash-for-beginners-ms


## Learn the ways of Linux-fu, for free. TODO

https://linuxjourney.com/






