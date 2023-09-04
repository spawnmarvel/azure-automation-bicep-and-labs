#!/bin/bash



logInformation() {
    logFile='deploylog.txt'
    echo $1 >> $logFile
}

now=$(date)
echo $now
logInformation $now

simpleVmName="simpleLinuxVM-$RANDOM"
resourceGroup='Rg-iac-linux-fu-0989'
location='uksouth'
tags='Environment=Qa'

fileName='keyvault.txt'
readarray myArray < $fileName
adminU=${myArray[0]}
adminP=${myArray[1]}

echo $adminU
echo $simpleVmName

logInformation $resourceGroup
logInformation $adminU
logInformation $simpleVmName

# https://github.com/Azure/azure-cli/issues/25710
# az config set bicep.use_binary_from_path=False

az group create --location $location --name $resourceGroup --tags $tags
az deployment group create --name mainDep --resource-group $resourceGroup --template-file main_1_NoDataDisk.bicep --parameters vmName="$simpleVmName" adminUsername="$adminU" # --what-if



