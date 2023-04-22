resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylanchstorage0041'
  location: 'uk south'
  sku:{
    name:'Standard_LRS'
  }
  kind:'StorageV2'
  properties:{
    accessTier:'Hot'
  }
}
