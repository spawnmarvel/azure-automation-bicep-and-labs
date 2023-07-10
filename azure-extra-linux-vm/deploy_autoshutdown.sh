


simpleVmName="simpleLinuxVM-13392"
resourceGroup="Rg-iac-linux-fu-0982"
vmLocal=$(az vm list --resource-group $resourceGroup --query [].name)
echo $vmLocal
az deployment group create --name main_autoshutdown --resource-group $resourceGroup --template-file main_autoshutdown.bicep --parameters vmName="$simpleVmName" emailRecipient="kleivane80@gmail.com" # --what-if
# az deployment group create --name main_autoshutdown --resource-group $resourceGroup --template-file main_autoshutdown.bicep --parameters vmName="$VmLocal" emailRecipient="kleivane80@gmail.com" # --what-if