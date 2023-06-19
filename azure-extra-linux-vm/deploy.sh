#!/bin/bash


now=$(date)
echo $now

resourceGroup='Rg-iac-linux-fu-0982'
location='uksouth'
tags='Environment=Qa'

az group create --resource-group $resourceGroup --location $location --tags $tags


