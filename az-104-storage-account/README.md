# Az Storage Account

## Storage account and Fileshare

We use Rg-ukdmzwindows-0007 and create a fileshare for dmzwindows07.

Storage account:
* dmz07staccount

File share name
* dmz07staccountfileshare01
* Access Tier Hot
* Protocol
* SMB
* Quota 20 GB

URL:
* https://dmz07staccount.file.core.windows.net/dmz07staccountfileshare01


Then we have it mounted using stroage account key.

![connect](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/connect1.png)

https://learn.microsoft.com/en-us/azure/storage/files/create-classic-file-share?tabs=azure-portal

https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-windows

## Access storage account

The path is:

```cmd
\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01

```

Access it with URL and we are in.

![access it](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/accessit.png)

It is empty now lets do some copy.

Create a folder with some subfolders and add 100 txt files.

```ps1
# 1. Define the target path
$targetPath = "C:\BackupLocalhost\Bck1" # Change this to your desired path!

# 2. Ensure the directory exists
if (-not (Test-Path -Path $targetPath -PathType Container)) {
    Write-Host "Creating directory: $targetPath"
    New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
}

# 3. Loop from 1 to 100 to create the files
foreach ($i in 1..100) {
    # Construct the file name (e.g., file1.txt)
    $fileName = "file$i.txt"
    $fullPath = Join-Path -Path $targetPath -ChildPath $fileName

    # Get the current date/time
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Define the content
    $content = "Filename: $fileName`r`nDate: $date" # `r`n is for a Windows-style newline

    # Create the file and add the content
    Set-Content -Path $fullPath -Value $content -Force
}

Write-Host "Successfully created 100 files in $targetPath."
```

We now have 2 folders and 100 files in Bck1.

![100 files](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/100files.png)


## Robocopy 2 fileshare



```cmd
robocopy <source> <destination> [<file>[ ...]] [<options>]
```

* /e	Copies subdirectories. This option automatically includes empty directories.
* /xf <filename>[ ...] Excludes files that match the specified names or paths. Wildcard characters (* and ?) are supported.

https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

Lets first just copy the folders excluding the files:

```cmd
# cmd copy only folders not files
robocopy D:\History D:\HistoryClean /e /xf *

robocopy C:\BackupLocalhost \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost /e /xf *
```

We now got the 3 folders.

![3 folders](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/3folders.png)


* /e	Copies subdirectories. This option automatically includes empty directories.
* /r:<n>	Specifies the number of retries on failed copies. The default value of n is 1,000,000 (one million retries).
* /w:<n>	Specifies the wait time between retries, in seconds. The default value of n is 30 (wait time 30 seconds).
* /sec	Copies files with security (equivalent to /copy:DATS).
* /timfix	Fixes file times on all files, even skipped ones.
* /log:<logfile>	Writes the status output to the log file (overwrites the existing log file).
* /np	Specifies to not display the progress of the copying operation (the number of files or directories copied so far).

https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

Lets copy all the files also.

```cmd
# Cp Files, folders and sec
robocopy \\WM01\f$\datacatalog e:\datacatalog /e /r:1 /w:5 /sec /secfix /timfix /log:"F:\robo_log.log" /np

robocopy C:\BackupLocalhost \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost /e /r:1 /w:5 /sec /secfix /timfix /log:"C:\robo_bck.log" /np

```
![copy files](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/copyfiles.png)

## Robocopy 2 vm

Lets make a new folder and a new file in that folder.

Copy the folder from storage account to vm

```cmd
robocopy \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost C:\BackupLocalhost /e /xf *

```
Log

```log
-------------------------------------------------------------------------------
   ROBOCOPY     ::     Robust File Copy for Windows
-------------------------------------------------------------------------------

  Started : Saturday, October 25, 2025 1:52:49 AM
   Source = \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\
     Dest : C:\BackupLocalhost\

    Files : *.*

Exc Files : *

  Options : *.* /S /E /DCOPY:DA /COPY:DAT /R:1000000 /W:30

------------------------------------------------------------------------------

                           0    \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\
                         100    \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\Bck1\
                           0    \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\Bck2\
          New Dir          1    \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\bck3\

------------------------------------------------------------------------------

               Total    Copied   Skipped  Mismatch    FAILED    Extras
    Dirs :         4         1         3         0         0         0
   Files :       101         0       101         0         0         0
   Bytes :     4.7 k         0     4.7 k         0         0         0
   Times :   0:00:00   0:00:00                       0:00:00   0:00:00
   Ended : Saturday, October 25, 2025 1:52:49 AM


```

Copy the file from storage account to vm

```cmd
robocopy \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost C:\BackupLocalhost /e /r:1 /w:5 /sec /secfix /timfix /log:"C:\robo_bck.log" /np
```

Log

```log

-------------------------------------------------------------------------------
   ROBOCOPY     ::     Robust File Copy for Windows                              
-------------------------------------------------------------------------------

  Started : Saturday, October 25, 2025 1:54:06 AM
   Source = \\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\
     Dest : C:\BackupLocalhost\

    Files : *.*
	    
  Options : *.* /S /E /DCOPY:DA /COPY:DATS /SECFIX /TIMFIX /NP /R:1 /W:5 

------------------------------------------------------------------------------

	                   0	\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\
	                 100	\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\Bck1\
	                   0	\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\Bck2\
	                   1	\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01\BackupLocalhost\bck3\
	    New File  		       0	file1.txt

------------------------------------------------------------------------------

               Total    Copied   Skipped  Mismatch    FAILED    Extras
    Dirs :         4         0         4         0         0         0
   Files :       101         1       100         0         0         0
   Bytes :     4.7 k         0     4.7 k         0         0         0
   Times :   0:00:01   0:00:01                       0:00:00   0:00:00
   Ended : Saturday, October 25, 2025 1:54:08 AM


```
