# =================================================================================
# SCRIPT NAME: Stop-Azure-MySQL-Flexible-Server.ps1
# VERSION: 1.0.2
# DESCRIPTION: 
# Connects via Managed Identity and Stops (Deallocates) an Azure MySQL Flexible Server.
# Use this to save compute costs on databases not needed 24/7.
#
# REQUIRED MODULES: 
# - Az.Accounts
# - Az.MySql (Required for Flexible Server commands)
#
# REQUIRED ROLES: 'Contributor' or 'Owner' on the MySQL Resource (or RG).
# =================================================================================

# ---------------------------------------------------------------------------------
# 1. PRE-FLIGHT CHECKS
# ---------------------------------------------------------------------------------
Write-Output "--- STARTING SYSTEM CHECK: Version 1.0.2 ---"

if (-not (Get-Module -ListAvailable -Name Az.MySql)) {
    Write-Error "CRITICAL: The 'Az.MySql' module is missing. Please add it to your Automation Account Modules."
    return
}

# ---------------------------------------------------------------------------------
# 2. HARDCODED SETTINGS
# ---------------------------------------------------------------------------------
$ClientId       = "xxxxxxxxxxxxxxxxxxxx" # ID of 'name-managedidentity'
$TenantId       = "xxxxxxxxxxxxxxxxxxxx" 
$SubscriptionId = "xxxxxxxxxxxxxxxxxxxx" 

# Target MySQL Flexible Server Details
$DBServerName   = "mysql-dev-server" 
$RG             = "RG-UKCHAOS-0009"

# ---------------------------------------------------------------------------------
# 3. AUTHENTICATION (User-Assigned Identity)
# ---------------------------------------------------------------------------------
Write-Output "Attempting connection for name-managedidentity..."

try {
    Connect-AzAccount -Identity `
                      -AccountId $ClientId `
                      -TenantId $TenantId `
                      -SubscriptionId $SubscriptionId -ErrorAction Stop

    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
    Write-Output "SUCCESS: Authenticated as $((Get-AzContext).Account.Id)"
}
catch {
    Write-Error "AUTHENTICATION FAILED: $($_.Exception.Message)"
    return
}

# ---------------------------------------------------------------------------------
# 4. RESOURCE DISCOVERY & STATUS CHECK
# ---------------------------------------------------------------------------------
Write-Output "Checking status of MySQL Flexible Server: $DBServerName"

try {
    $dbStatus = Get-AzMySqlFlexibleServer -ResourceGroupName $RG -Name $DBServerName -ErrorAction Stop
    
    # Check current state (Ready, Stopped, Updating, Dropping, etc.)
    Write-Output "Current Server State: $($dbStatus.State)"

    if ($dbStatus.State -eq "Ready") {
        Write-Output "Server is ACTIVE. Initiating Stop command..."
        
        # Stops the server and deallocates compute (Storage billing continues)
        Stop-AzMySqlFlexibleServer -ResourceGroupName $RG -Name $DBServerName -Confirm:$false
        
        Write-Output "SUCCESS: Stop command sent. State will move to 'Stopped' shortly."
    } 
    elseif ($dbStatus.State -eq "Stopped") {
        Write-Output "NOTICE: Server is already in 'Stopped' state. No action taken."
    } 
    else {
        Write-Warning "NOTICE: Server is in '$($dbStatus.State)' state. Stop command skipped to avoid conflict."
    }
}
catch {
    Write-Error "DISCOVERY FAILED: Could not find or access the MySQL server."
    Write-Error "Error Detail: $($_.Exception.Message)"
}

Write-Output "--- SCRIPT COMPLETE ---"