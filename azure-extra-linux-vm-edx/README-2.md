## Module 2: Introduction to Linux Commands

Overview of Common Linux Shell Commands =

* A shell is a powerful user interface for Unix-like operating systems. It can interpret commands
and run other programs.
* Default bash (only used in this course)

```bash

# Some common shell commands for getting information
whoami
id
uname
ps
top
df
man
date

# Some common shell commands for working with files include:
cp
mv
rm
touch
chmod
wc
grep

# Very common shell commands for navigating and working with directories include:
ls
find
pwd
mkdir
cd
rmdir

# For printing file contents or strings, common commands include:
cat
more
head
tail
echo

# Shell commands related to file compression and archiving applications include:
tar
zip
unzip

# Networking applications include the following:
hostname
ping
ifconfig
curl
wget

```

In this video, you learned that:
* A shell is an interactive user interface for running commands, a scripting language, and
an interactive language.
* Shell commands are used for navigating and working with files and directories.
* Shell commands can be used for file compression.
* The curl and wget commands, respectively, can be used to display and download files from
URLs.
* The echo command prints string or variable values.
* The cat and tail commands are used to display file contents.

Informational Commands = 

User information
```bash

# John Doe
whoami

# 501
id -u

#johndoe
id -u -n

# MINGW64_NT-10.0-19045 , OS
uname

# OS and version
uname -S -R

# more details
uname -v

# disk /home dir - human readble
df -h ~

# all files
df -h

# current running pro
ps

# all proc and time
ps -e

# system health , top 3
top -n 3

# print
echo

# Strictly speaking, you don't need to add quotes around a string with spaces for echo to work as expected,
# but it's considered best practice to include quotes.
# Using echo with a quoted string returns the quoted contents, “Learning Linux is fun!"

echo "hello"

# path
echo $PATH

# display dt
date

# Format controls are indicated with the % symbol.
# In this case, “percent j” and “percent Y” output
# the numerical day of the year and the year itself, respectively.
date "+%j day of %Y"
097 day of 2023

# more format
date "+It s%A, the %j day of %Y"

# view the manual and parameters for command
man

man id

man top

man echo

```

* Get user information with the "whoami" and "id" commands,
* Get operating system information using the “uname” command,
* Check system disk usage using the "df" command,
* Monitor processes and resource usage with “ps" and "top",
* Print string or variable value using "echo",
* Print and extract information about the date with the “date" command,
* And read the manual for any command using “man”.

Reading: Getting Help for Linux Commands =

Hands-on Lab: Informational Commands =

File and Directory Navigation Commands =

File and Directory Management Commands =

Hands-on Lab:  Navigating and Managing Files and Directories =

Reading: Security - Managing File Permissions and Ownership =

Hands-on Lab: Access Control Commands =

Practice Quiz: Informational, Navigational and Management Commands =

Viewing File Content =

Useful Commands for Wrangling Text Files =

File Archiving and Compression Commands =

Hands-on Lab: Wrangling Text Files at the Command Line =

Reading (Optional): A Brief Introduction to Networking =

Networking Commands =

Hands-on Lab: Working with Networking Commands =

File Archiving and Compression Commands =

Hands-on Lab: Archiving and Compressing Files =

Practice Quiz: Text Files, Networking & Archiving Commands =

Summary & Highlights =

Cheat Sheet: Introduction to Linux Commands =

Practice Quiz: Linux Commands =

Graded Quiz: Linux Commands = Done


