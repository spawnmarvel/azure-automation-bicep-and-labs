# 1 Deploy an Azure function for Powershell, fnapposcq57ms7loje
# 2 Create a key vault, Kv-uks-0082. After provisioning, Settings->Access configuration->Azure role based access control.
# 3 Enable system identity or verify it on the function and add function app as Key vault secrets officer:
# 3.1 Function app->Settings->Identity->System assigned = On
# 3.2 Key vault->IAM->Add role assigment->Managed identity->Selet managed identities->fnapposcq57ms7loje
# 4 Verify managed identity in in profile.json, add Az module to requirements.psd1
# 4.1 Function app->Functions->App Files, profile.ps1 = if ($env:MSI_SECRET) , requirements.psd1, uncomment 'Az' = '9.*' and save. Restart the function app
# 5 Create an HTTP trigger with Authorization level: Function
# 5.1 Stop, starte the function, it should install az module
# 2023-05-09T18:30:13Z   [Warning]   The first managed dependency download is in progress, function execution will continue when it's done. Depending on the content of requirements.psd1, this can take a few minutes.
# Test it again after a few minutes.

# 5.2 Add Code 1 for test az module 

# Code 1 for HttpTrigger1 extra

# You can now run all ps1 az commands 
Start-VM -Name TestVM




