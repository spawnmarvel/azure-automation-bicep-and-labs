#!/bin/bash



logInformation() {
    logFile='deploylog.txt'
    echo $1 >> $logFile
}

now=$(date)
echo $now
logInformation $now

simpleVmName="Vm-$RANDOM"
resourceGroup='Rg-iac-linux-fu-0990'
location='uksouth'
tags='Environment=Qa'

fileName='keyvault.txt'
readarray myArray < $fileName
adminU=${myArray[0]}
adminP=${myArray[1]}
vnet='vnet01'
subnet='default01'

echo $adminU
echo $simpleVmName

logInformation $resourceGroup
logInformation $adminU
logInformation $simpleVmName

# https://github.com/Azure/azure-cli/issues/25710
# az config set bicep.use_binary_from_path=False

az group create --location $location --name $resourceGroup --tags $tags
# Deploy all in on rg
# az deployment group create --name mainDep --resource-group $resourceGroup --template-file main_1_NoDataDisk.bicep --parameters vmName="$simpleVmName" adminUsername="$adminU" # --what-if

# Deploy to existing vnet
az deployment group create --name mainDep --resource-group $resourceGroup --template-file main_1_2_NoDDExistVnet.bicep \
 --parameters vmName="$simpleVmName" adminUsername="$adminU" virtualNetworkName="$vnet" subnetName="$subnet" # --what-if



