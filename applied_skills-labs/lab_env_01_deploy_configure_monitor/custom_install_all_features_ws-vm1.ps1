
# login and run this on server

$featureName = 'Web-Server'   # IIS
$feature = Get-WindowsFeature -Name $featureName

# Function to append to the log file
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logFile = "c:\temp\bicep_install_log.txt"
    Add-Content -Path $logFile -Value $logEntry
}

Write-Log "Start automation deploy"

if ($feature.Installed) {
    Write-Log "$($feature.DisplayName) is already installed."
}
else {
    Write-Log "$($feature.DisplayName) is not installed."
    Install-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools
}

try {
    
    # take a backup first
    Copy-Item "c:\inetpub\wwwroot\index.html" -Destination "c:\inetpub\wwwroot\index_bck.html"
    # we need to set set dir since we will run wget from that dir to make a new index.html
    Set-Location -Path "c:\inetpub\wwwroot\"
    # lets change the default iis page, use raw file
    Wget https://raw.githubusercontent.com/spawnmarvel/azure-administrator-grinding/refs/heads/main/applied-skills/lab_env_01_deploy_configure_monitor/index.html -OutFile index.html

    Write-Log "index.html changed"
    
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Log "index.html was not changed $($_.Exception.Message)"
}
