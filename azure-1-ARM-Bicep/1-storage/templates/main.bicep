// Deploys a storage account
// Linter rule - no hardcoded locations
//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-no-hardcoded-location

param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylanchstorage0041'
  location: location
  sku:{
    name:'Standard_LRS'
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Cool'
  }
}
