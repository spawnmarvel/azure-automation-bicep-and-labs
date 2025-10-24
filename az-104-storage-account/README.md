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

We now have 2 foldders and 100 files in Bck1.

![100 files](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/100files.png)


## Robocopy

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

```cmd
# Cp Files, folders and sec
robocopy \\WM01\f$\datacatalog e:\datacatalog /e /r:1 /w:5 /sec /secfix /timfix /log:"F:\robo_log.log" /np
robocopy e:\datacatalog \\WM01\f$\datacatalog /e /r:1 /w:5 /sec /secfix /timfix /log:"F:\robo_log.log" /np

```