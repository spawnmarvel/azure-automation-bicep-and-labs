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


Then we have it mounted

![connect](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/connect1.png)

https://learn.microsoft.com/en-us/azure/storage/files/create-classic-file-share?tabs=azure-portal

https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-windows

## Access storage account

The path is

```cmd
\\dmz07staccount.file.core.windows.net\dmz07staccountfileshare01

```

Access it

![access it](https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-104-storage-account/images/accessit.png)

## Robocopy

```cmd
# cmd Cp folders empty
robocopy D:\History D:\HistoryClean /e /xf *
```

```cmd
# Cp Files, folders and sec
robocopy \\WM01\f$\datacatalog e:\datacatalog /e /r:1 /w:5 /sec /secfix /timfix /log:"F:\robo_log.log" /np
robocopy e:\datacatalog \\WM01\f$\datacatalog /e /r:1 /w:5 /sec /secfix /timfix /log:"F:\robo_log.log" /np

```