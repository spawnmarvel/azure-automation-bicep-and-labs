// Create a Bicep template that contains an Azure Cosmos DB account

param cosmosDBAccountName string = 'toy-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: cosmosDBAccountName
  location:location
  properties: {
    databaseAccountOfferType: 'Standard' 
    locations:  [{
      locationName:location
    }]
  }
}
