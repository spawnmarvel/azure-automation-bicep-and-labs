# Az Storage Account

## Fileshare

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