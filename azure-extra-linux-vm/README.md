# Azure Linux Ubuntu

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

## Learn the ways of Linux-fu, for free.

1. Filesystem Hierarchy

| Path     | Description
|----------| -----------------------------------------------
| /        | - The root directory of the entire filesystem hierarchy, everything is nestled under this directory.
| /bin -   | Essential ready-to-run programs (binaries), includes the most basic commands such as ls and cp.
| /boot -  | Contains kernel boot loader files.
| /dev -   | Device files.
| /etc -   | Core system configuration directory, should hold only configuration files and not any binaries.
| /home -  | Personal directories for users, holds your documents, files, settings, etc.
| /lib -   | Holds library files that binaries can use.
| /media - | Used as an attachment point for removable media like USB drives.
| /mnt -   | Temporarily mounted filesystems.
| /opt -   | Optional application software packages.
| /proc -  | Information about currently running processes.
| /root -  | The root user's home directory.
| /run -   | Information about the running system since the last boot.
| /sbin -  | Contains essential system binaries, usually can only be ran by root.
| /srv -   | Site-specific data which are served by the system.
| /tmp -   | Storage for temporary files
| /usr -   | This is unfortunately named, most often it does not contain user files in the sense of a home folder. This is meant for user installed software and utilities, however that is not to say you can't add personal directories in there. Inside this directory are sub-directories for /usr/bin, /usr/local, etc.
| /var -  | Variable directory, it's used for system logging, user tracking, caches, etc. Basically anything that is subject to change all the time.

ref https://linuxjourney.com/lesson/filesystem-hierarchy

https://linuxjourney.com/

Unix philosphy

![Unix ](https://github.com/spawnmarvel/azure-automation/blob/main/images/unix.jpg)
ref https://bash.cyberciti.biz/guide/Unix_philosophy

## Azure CLI
How to install the Azure CLI

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

## Azure Linux joined to domain login with account

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli

Powershell (using az cli)

```bash
az --version

```

Log in to a Linux virtual machine in Azure by using Azure AD and OpenSSH

https://learn.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-linux#configure-role-assignments-for-the-vm


Add IAM on the VM
* IAM->Virtual Machine Administrator Login, Reader, Desktop Virtualization Power On Off Contributor
* For username@domain.com

```bash

az extension add --name ssh
az extension show --name ssh

# login as username@domain.com
az login --tenant  TENANT-ID

az account set --subscription "SUBSSCRIPTION-NAME-VIEW-VM"

az ssh vm -n vmName -g resourceGroupName

# You can now run sudo as username@domain.com

sudo mysql -u root -p

```

Upgrade AZ CLI
```bash

az --version

az upgrade --yes

```


## List of Basic SSH Commands Linux (ubuntu 20.04)

| SSH cmds  | Description | Example
|---------- |------------ | ------------------------------
| help      | help pwd    | help pwd
| whatis    | Find what a command is used for  | whatis ls
| sudo apt update| use the apt package management tools to update your local package index |
| sudo apt update && sudo apt upgrade -y | Make sure all current packages are up to date <br/> apt is the command that is being recommended by the Linux distributions. | https://itsfoss.com/apt-vs-apt-get-difference/
| apt list --installed| Get installed packages |
| apt (pacman, yum, rpm) | Package managers depending on the distro |
| sudo apt install, remove, purge zip | When using the “remove” option, Ubuntu can leave files behind while uninstalling a package. To work around this apt offers another option, the “purge” option. | sudo apt remove zip
| sudo apt autoremove | If you want to clean up your Ubuntu system by uninstalling unused packages, then apt offers an option called “autoremove“.   | Use 'sudo apt autoremove' to remove it.
| whereis   | Locate the binary, source, and manual pages for a command | whereis wget,  whereis traceroute
| which     | Identify and report the location of the provided executable | which wget, which traceroute
| reboot    |  | sudo shutdown -r now
| ls        | Show directory contents (list the names of files) | -a (list all + hidden), -l (list all + size)
| lsblk     | Show disks | lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
| cd        | Change dir  | cd ./folder
| cd /      | Get to root directory  | (bin  boot  dev  etc  home  lib  lib32  lib64  libx32  lost+found  media  mnt  opt  proc  root  run  sbin  snap  srv  sys  tmp  usr  var)
| mkdir     | Make dir    |  mkdir folder1
| touch     | New file    | touch file.txt
| rm        | Remove a file | rm file1
| rmdir     | Remove a directory, if empty | rmdir folder1
| rm -r     | To remove a directory and all its contents, including any subdirectories and files | rm -r folder
| cat       | Show content of file (redirect to var, content=$(cat data.conf)) |  cat data.conf
| pwd       | Show current dir: example - > | /home/user
| cp        | Copy file use if for backup, source destination | cp data.conf data.conf_bck
| cp -r     | Copy folder, In order to copy a directory on Linux, you have to execute the “cp” command with the “-R” option for recursive and specify the source and destination directories to be copied.  | cp -r folder1 folder2
| mv        | Move file, the difference is that cp will keep the old file(s) while mv won't, source destination | mv data.conf backup/
| grep      | Search for a string within an output | cat data.conf 'pipe' grep "uid"
| find      | Search files and dirs | find . -name data.conf
| nano      | Text editor | nano data.conf
| head      | return specified num of lines from top | head -n 2 data.conf
| tail      | return specified num of lines from bottom, -f follow | tail -f data.conf
| less      | Display the contents of a file one page at a time, exit with q | less data.conf
| more      | Loads the entire file at once, enter for more | more data.conf
| diff      | find diff between two files | diff data.conf data.conf_bck
| cmp       | check if two files are identical | cmp data.conf data.conf_identical
| comm      | combines diff and cmp | comm data.conf data.conf_bck
| sort      | sort (lines) content of file while outputting  |  cat names.txt Xavier,Jim, Anna, Bob <br/> sort names.txt, Anna, Bob, Jim, Xavier
| history   | Show last 50 cmds |
| clear     | Clear terminal |
| echo      | Print | var="Hodor", echo $var
| man       | Access manual pages for all Linux commands | man ls
| uname     | command to get basic information about the OS | uname -a
| hostnamectl | find os name and version | Operating System: Ubuntu 22.04.2 LTS, Kernel: Linux 5.15.0-1040-azur
| whoami    | Get the active username |
| export    | The export command is specially used when exporting environment variables in runtime | export dbCon="MySql:1245", echo $dbCon
| tar       | The tar command in Linux is used to create and extract archived files, -cvf compress, -xvf extract | tar -cvf compFolder.tar folder <br/> tar -xvf compFolder.ta
| zip       | sudo apt install zip | zip -r folder.zip folder1
| unzip     | sudo apt install unzip | unzip folder.zip, unzip folder.zip -d destinationfolder
| ssh       | Secure Shell command | ssh user@ipaddress
| service   | start stop service | service ssh stop
| ps        | display active proc |
| ps -aux    | display all active proc | ps -aux 'pipe' less
| top       | View active processes live with their system usage |
| kill and killall | Kill active processes by process ID or name | 
| df        | Display disk filesystem information,  -h parameter to make the data human-readable. | df -h
| mount     | Mount file systems | https://github.com/spawnmarvel/azure-automation/blob/main/azure-extra-linux-vm/READMEQuickstartsLinuxMS.md
| chmod     | Command to change file permissions, get permission ls - l, -rw-rw-r-- | chmod +x file, -rwxrwxr-x
| chown     | Command for granting ownership of files or folders, command allows you to change the user and/or group ownership of a given file, directory, or symbolic link. <br/> get permission and owner, ls -l| chown user-or-userid file1
| ifconfig  | Display network interfaces and IP addresses  | sudo apt install net-tools, eth0:inet private ipaddress
| traceroute | Trace all the network hops to reach the destination, sudo apt install traceroute | traceroute www.google.com
| telnet    | Check connection | telnet ip-address port
| nc        | The nc (or netcat) utility is used for just about anything under the sun involving TCP, UDP, or UNIX-domain sockets. | nc -zvw10 ip-address 3306
| wget      | Download files from internet, GNU Wget is a command-line utility for downloading files from the web. With Wget, you can download files using HTTP, HTTPS, and FTP protocols. <br/> wget --version, sudo apt install wget | wget https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.3/zabbix_agent-6.0.3-linux-4.12-ppc64le-static.tar.gz
| du        | Get file size, -h human readble | du -h zabbix_agent-6.0.3-linux-4.12-ppc64le-static.tar.gz
| curl      | Download or upload data using protocols such as FTP, SFTP, HTTP and HTTPS. |  curl www.google.com
| sudo | which is an acronym for superuser do or substitute user do, is a command that runs an elevated prompt without a need to change your identity. |
| sudo -i     | A simple way to switch to an interactive session as a root user is the following | root$vmName
| su     | on the other hand, is an acronym for switch user or substitute user. You are basically switching to a particular user and you need the password for the user you are switching to. |
| su - bryant | switch to the bryant user account including bryant's path and environment variables, use the (-) switch |
| sudo ufw enable | By default, when UFW is enabled, it blocks external access to all ports on the server |
| sudo ufw | Use iptables or ufw to open ports | sudo ufw allow 1022/tcp<br/>sudo ufw allow 'Nginx HTTPS'
| sudo ufw status | list ufw rules |
| iptables | Base firewall for all other firewall utilities to interface with. List: | sudo iptables -L
| useradd and usermod | Add new user or change existing users data <br/> When executed without any option, useradd creates a new user account using the default settings specified in the /etc/default/useradd file. -M, --no-create-home | sudo useradd -m soloman <br/> /home/soloman
| passwd   | To be able to log in as the newly created user, you need to set the user password. The command adds an entry to the /etc/passwd, /etc/shadow, /etc/group and /etc/gshadow files. | sudo passwd soloman
| passwd | Create or update passwords for existing users|
| git --version | Git is likely already installed in your Ubuntu 22.04 server.| # else: sudo apt update, sudo apt install git, git --version
| mariadb client| app server | sudo apt install mariadb-client
| mariadb       | db server | sudo apt install mariadb-server mariadb-client<br/>sudo systemctl enable --now mariadb <br/>systemctl status mariadb <br/>sudo mysql_secure_installation
| mysql/mariadb | https://linux.how2shout.com/how-to-install-wordpress-on-ubuntu-22-04-lts-server/ | mysql -u USERNAME -h localhost-IP -p db_mydatabase (enter password) <br> sudo mysql -u root -p
| IPV6, IPV4    | allow remote, /etc/mysql/mariadb.cnf | [mysqld] bind-address = ::, [mysqld] bind-address = 0.0.0.0
| crontab       | -e, edit, -l display, -v last time edited (must install it) | crontab -e




### https://www.digitalocean.com/community/tutorials/linux-commands

## Script bash, permission and run it


1. touch myScript.sh

2. nano myScript.sh

3. which bash, /bin/bash

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
sudo chmod +x myScript.sh
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
![Vicuna ](https://github.com/spawnmarvel/azure-automation/blob/main/images/vicuna.jpg)


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


## Setting Up Environment Variables on Ubuntu

```bash
# To view all the environment variables
printenv
# or
env

# Setting Environment Variables Temporarily
export MY_VAR="GOT"
printenv MY_VAR

# Setting Environment Variables Permanently
# For system-wide environment variables, edit the /etc/environment file.
sudo nano /etc/environment
MY_VAR="GOT"
# Save and exit the file. For the changes to take effect, either reboot the system or run:
source /etc/environment

# Verify it
printenv
MY_VAR=GOT

# Do a reboot and to be sure and verify it
sudo shutdown -r now
printenv
MY_VAR=GOT
```

![Env var](https://github.com/spawnmarvel/azure-automation/blob/main/images/envvar1.jpg)
https://tecadmin.net/setting-up-environment-variables-on-ubuntu/

 
## Linux disks and path/folder information
| The "thing mentioned"     | Description | Example
| -------------------------| ----------- | -------
|/dev/sda | The OS disk is labeled,/dev/sda. OS disk should not be used for applications or data. For applications and data, use data disks | https://learn.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-disks *
|/dev/sdb | Temporary disks use a solid-state drive that is located on the same Azure host as the VM. Temp disks are highly performant and may be used for operations such as temporary data processing.| mountpoint of /mnt *
|/dec/sdc | Data disk(s) | Attach disk at VM creation or Attach disk to existing VM, Prepare data disks, Mount and /etc/fstab
|Linux drive letter | Applications and users should not care what SCSI device letter a particular storage gets, because those sdX letters can change and are expected to change. Instead, the storage should be addressed by some unique and permanent property, such as the LUN WWID or filesystem UUID.| https://access.redhat.com/discussions/6004221

## Initial Server Setup with Ubuntu 20.04

* Step 1 — Logging in as root

The root user is the administrative user in a Linux environment that has very broad privileges.

The next step is setting up a new user account with reduced privileges for day-to-day use.

Once you are logged in as root, you’ll be able to add the new user account. In the future, we’ll log in with this new account instead of root.

* Step 2 — Creating a New User

```bash
# become root
sudo -i
adduser username
# or
sudo adduser username
# list user
getent passwd username

```
* Step 3 — Granting Administrative Privileges

To avoid having to log out of our normal user and log back in as the root account, we can set up what is known as superuser or root privileges for our normal account. 

This will allow our normal user to run commands with administrative privileges by putting the word sudo before the command.

```bash
# become root
sudo -i
usermod -aG sudo username
# Now, when logged in as your regular user, you can type sudo before commands to run them with superuser privileges.

# change to user
su - username

# apt install
apt install zip
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
sudo apt install zip

```
* Step 4 — Setting Up a Basic Firewall, UFW, or Uncomplicated Firewall

(
    
    Note: ufw by default is initially disabled. 

    ref https://ubuntu.com/server/docs/security-firewall#:~:text=ufw%20%2D%20Uncomplicated%20Firewall,by%20default%20is%20initially%20disabled

    Note: using IPV6

    ref https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04

)

```bash
# Applications can register their profiles with UFW upon installation. These profiles allow UFW to manage these applications by name.
sudo ufw app list
Available applications:
  OpenSSH

# We need to make sure that the firewall allows SSH connections so that we can log back in next time. We can allow these connections by typing:
sudo ufw allow OpenSSH
Rules updated
Rules updated (v6)

# Afterwards, we can enable the firewall by typing:
sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

#
sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)

```
As the firewall is currently blocking all connections except for SSH, if you install and configure additional services, you will need to adjust the firewall settings to allow traffic in.

You can learn some common UFW operations in our https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands


* Step 5 — Enabling External Access for Your Regular User

```bash
# Now that we have a regular user for daily use, we need to make sure we can SSH into the account directly.

# 1. If you logged in to your root account using a password, then password authentication is enabled for SSH. 

ssh username@ip-address

# Remember, if you need to run a command with administrative privileges, type sudo before it like this:
sudo command_to_run

# 2. If you logged in to your root account using SSH keys, then password authentication is disabled for SSH. You will need to add a copy of your local public key to the new user’s ~/.ssh/authorized_keys file to log in successfully.

```

https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04

## Linux on Azure MS Learn

This comprehensive learning path reviews deployment and management of Linux on Azure. Learn about cloud computing concepts, Linux IaaS and PaaS solutions and benefits and Azure cloud services.

Discover how to migrate and extend your Linux-based workloads on Azure with improved scalability, security, and privacy.

```bash
az login --tenant TENANT-ID-HERE

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


## Python with cron

Install cron and make it roll :large_blue_circle:
```bash
sudo apt install cron
sudo systemctl enable cron
Synchronizing state of cron.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable cron
```
* Cron jobs are recorded and managed in a special file known as a crontab. Each user profile on the system can have their own crontab where they can schedule jobs, which is stored under /var/spool/cron/crontabs/.
* To schedule a job, open up your crontab for editing and add a task written in the form of a cron expression. The syntax for cron expressions can be broken down into two elements: the schedule and the command to run.
* https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804

script
```python
import time
from datetime import datetime as dt
import logging
import os
import signal
import sys

logging.basicConfig(filename='app.log', filemode='a', format='%(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logging.info('Starting...') # all logging will be logged to app.log
CUR = dt.now()
print(str(CUR), " Starting Cron job") # this will be logged to cron log
MAIN_PID = None

def handler(signum, frame):
    msg = "signal "+ str(signum)
    logging.info(msg)
    exit(1)

signal.signal(signal.SIGINT, handler)

def test_loop():
    rool= True
    count=0
    while (rool):
        count = count +1
        cur_tmp = dt.now()
        logging.info("Python count is " + str(cur_tmp))
        time.sleep(10)
        if count > 2:
            rool=False


if __name__ == "__main__":
    MAIN_PID = os.getpid()
    logging.info(str(MAIN_PID))
    test_loop()
    logging.info("Stopping....")
    cur_tmp = dt.now()
    print(str(cur_tmp), " Ending Cron job") # this will be logged to cron log
    exit(main())
```

Script
* /home/imsdal/run_loop.py
* Run the script with python3 run_loop.py
* cron log, >> /home/imsdal/cronoutput.log


Set up as cron jobb

```bash
crontab -e
# This will ask you which editor choose from. I used nano since it is my favorite editor, 1 = nano.
# Choose 1-4 [1]: 1
* * * * * python3 /home/imsdal/run_loop.py >> /home/imsdal/cronoutput.log
crontab: installing new crontab
# So the first 5 stars you can mention the minute, hour, day and month etc. with command to be executed. 
# Let’s create a cronjob that run every minute with out python script.
```

Let's view the outpu of each log file

```bash
cat cronoutput.log

tail -f cronoutput.log
```

```log
2023-07-19 23:08:01.284403  Starting Cron job
2023-07-19 23:08:31.315305  Ending Cron job
2023-07-19 23:09:01.424502  Starting Cron job
2023-07-19 23:09:31.455406  Ending Cron job
2023-07-19 23:10:01.554321  Starting Cron job
2023-07-19 23:10:31.585370  Ending Cron job
```

```bash
cat app.log

tail -f app.log
```

```log
root - INFO - Starting...
root - INFO - 7642
root - INFO - Python count is 2023-07-19 23:08:01.284480
root - INFO - Python count is 2023-07-19 23:08:11.294639
root - INFO - Python count is 2023-07-19 23:08:21.304883
root - INFO - Stopping....
root - INFO - Starting...
root - INFO - 7659
root - INFO - Python count is 2023-07-19 23:09:01.424580
root - INFO - Python count is 2023-07-19 23:09:11.434688
root - INFO - Python count is 2023-07-19 23:09:21.444931
root - INFO - Stopping....
root - INFO - Starting...
root - INFO - 7668
root - INFO - Python count is 2023-07-19 23:10:01.554397
root - INFO - Python count is 2023-07-19 23:10:11.564552
root - INFO - Python count is 2023-07-19 23:10:21.574867
root - INFO - Stopping....
root - INFO - Starting...
root - INFO - 7679
root - INFO - Python count is 2023-07-19 23:11:01.683514
```


## MS Tutorials for Linux

All done:

https://github.com/spawnmarvel/azure-automation/blob/main/azure-extra-linux-vm/READMEQuickstartsLinuxMS.md







