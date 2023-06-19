#!/bin/bash


now=$(date)
echo $now

resourceGroup='Rg-iac-linux-fu-0982'
location='uksouth'
tags='Environment=Qa'

fileName='keyvault.txt'
readarray myArray < $fileName
echo ${myArray[0]}
echo ${myArray[1]}

# https://github.com/Azure/azure-cli/issues/25710
az config set bicep.use_binary_from_path=False

az group create --location $location --name $resourceGroup --tags $tags
az deployment group create --name mainDep --resource-group $resourceGroup --template-file main.bicep


