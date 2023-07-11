# using resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' existing in main_autoshutdown.bicep
simpleVmName="simpleLinuxVM-13392"
resourceGroup="Rg-iac-linux-fu-0982"
vmLocal=$(az vm list --resource-group $resourceGroup --query [].name)
echo $vmLocal
echo "vmLocal returns ]simpleLinuxVM-13392 and  in git bash"
echo "vmLocal returns [ "simpleLinuxVM-28678" ]  in azure portal bash"

# az deployment group create --name main_autoshutdown --resource-group $resourceGroup --template-file main_autoshutdown.bicep --parameters vmName="$simpleVmName" emailRecipient="kleivane80@gmail.com" # --what-if
# az deployment group create --name main_autoshutdown --resource-group $resourceGroup --template-file main_autoshutdown.bicep --parameters vmName="$VmLocal" emailRecipient="kleivane80@gmail.com" # --what-if
# Please provide string value for 'vmName' (? for help):
az deployment group create --name main_autoshutdown --resource-group $resourceGroup --template-file main_autoshutdown.bicep --parameters emailRecipient="kleivane80@gmail.com" # --what-if