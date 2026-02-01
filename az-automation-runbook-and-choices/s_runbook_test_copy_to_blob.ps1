# =================================================================================
# 1. HARDCODED SETTINGS
# =================================================================================
$ClientId           = "YOUR-CLIENT-ID" 
$TenantId           = "YOUR-TENANT-ID" 
$SubscriptionId     = "YOUR-SUB-ID" 
$StorageAccountName = "jeklrunbooklogs"
$ContainerName      = "vm-logs-linux-updates"

##### Script version 1.4

# =================================================================================
# 2. AUTHENTICATION (Consistent with Main Script)
# =================================================================================
Write-Output "--- STARTING UPLOAD TEST: Version 1.4 ---"
Write-Output "Authenticating via Managed Identity..."

Connect-AzAccount -Identity `
                  -AccountId $ClientId `
                  -TenantId $TenantId `
                  -SubscriptionId $SubscriptionId -ErrorAction Stop

Set-AzContext -SubscriptionId $SubscriptionId | Out-Null

# =================================================================================
# 3. STORAGE CONTEXT & UPLOAD
# =================================================================================
Write-Output "Connecting to Storage Account: $StorageAccountName"

# Get the Storage Context using the authenticated account
$Ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -UseConnectedAccount

# Create dummy content for the test file
$VMName    = "TestVM-01"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$FileName  = "ManualTest_v1.4_$($VMName)_$($Timestamp).log"

$DummyContent = @"
=======================================
STORAGE UPLOAD TEST
Script Version: 1.4
Date: $(Get-Date)
ClientID: $ClientId
Status: Testing storage upload logic only
=======================================
This is a single-file upload test. 
If this file appears in the container, 
the authentication and storage context are 100% correct.
"@

# Save the file to the temporary sandbox path on the Automation worker
$TempPath = Join-Path $env:TEMP $FileName
$DummyContent | Out-File -FilePath $TempPath -Encoding utf8

# Upload the file to the Container
Write-Output "Uploading $FileName to container $ContainerName..."

try {
    Set-AzStorageBlobContent -Context $Ctx `
                             -Container $ContainerName `
                             -Blob $FileName `
                             -File $TempPath `
                             -Force -ErrorAction Stop
                             
    Write-Output "SUCCESS: File '$FileName' uploaded successfully."
}
catch {
    Write-Error "UPLOAD FAILED: Check if Container Name '$ContainerName' exists and Identity has 'Storage Blob Data Contributor' role."
    Write-Error "Error Detail: $($_.Exception.Message)"
}
finally {
    # Clean up the temporary local file
    if (Test-Path $TempPath) { 
        Remove-Item $TempPath 
        Write-Output "Local temp file removed."
    }
}

Write-Output "--- TEST COMPLETE: Version 1.4 ---"