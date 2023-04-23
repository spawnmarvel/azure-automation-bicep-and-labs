// Deploys a storage account
// Linter rule - no hardcoded locations
//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-no-hardcoded-location

// params
param location string = resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// vars
var appServicePlanName = 'toy-product-launch-plan'
// For the storageAccountSkuName variable, if the environmentType parameter is set to prod, then use the Standard_GRS SKU. Otherwise, use the Standard_LRS SKU.
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS': 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'nonprod') ? 'P2V3':'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  tags:{
    Infrastructure: 'IAC'
  }
  sku:{
    name:storageAccountSkuName
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Cool'
  }
}
// Properties for storage account
// https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name:appServicePlanName
  location:location
  tags:{
    Infrastructure: 'IAC'
  }
  sku:{
    name:appServicePlanSkuName
  }
}


resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name:appServiceAppName
  location:location
  tags:{
    Infrastructure: 'IAC'
  }
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}
