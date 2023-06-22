# Azure Linux 

## List of Basic SSH Commands

| SSH cmds  | Description | Example
|---------- |------------ | ------------------------------
| help      | help pwd    | help pwd
| ls        | Show directory contents (list the names of files) | -a, list all + hidden, -l list all + size
| cd        | Change dir  | cd ./folder
| mkdir     | Make dir    |  mkdir folder
| touch     | New file    | touch file.txt
| rm        | Remove a file | rmi-f, force
| cat       | Show content of file |  cat keyvault.txt
| pwd       | Show current dir |
| cp        | Copy file/folder | source destination
| mv        | Move file/folder | source destination
| grep      | Search for a phrase in file/lines |
| find      | Search files and dirs |
| nano      | Text editor |
| history   | Show last 50 cmds |
| clear     | Clear terminal |
| tar       | Create and unpack compressed archives |
| wget      | Download files from internet |
| du        | Get file size |
| less      | Display the contents of a file one page at a time |
| more      | Loads the entire file at once |
| curl      | Download or upload data using protocols such as FTP, SFTP, HTTP and HTTPS |
| top       | Monitor running processes and the resources (such as memory) they are currently using |
| which     | Identify and report the location of the provided executable |
| sudo apt update && sudo apt upgrade -y | Make sure all current packages are up to date |
| apt list --installed| Get installed packages |
| sudo ufw | Use iptables or ufw to open ports | sudo ufw allow 1022/tcp
| sudo ufw status | list ufw rules |

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






