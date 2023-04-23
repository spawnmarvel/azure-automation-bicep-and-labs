// Deploys a storage account
// Linter rule - no hardcoded locations
//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-no-hardcoded-location

param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylaunchstorage0041x'
  location: location
  tags:{
    Infrastructure: 'IAC'
  }
  sku:{
    name:'Standard_LRS'
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Cool'
  }
}
// Properties for storage account
// https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name:'toy-product-launch-plan-starter0041'
  location:location
  tags:{
    Infrastructure: 'IAC'
  }
  sku:{
    name:'F1'
  }
}
resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name:'toy-product-launch00041'
  location:location
  tags:{
    Infrastructure: 'IAC'
  }
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}
