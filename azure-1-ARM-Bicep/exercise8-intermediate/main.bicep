// Create a Bicep template that contains an Azure Cosmos DB account

param cosmosDBAccountName string = 'toy-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
// Add a database
param cosmosDBDatabaseThroughput int = 400

var cosmosDBDatabaseName = 'FlightTest'

// Add a container

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

resource cosmosDBDatabse 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2020-04-01' = {
  parent:cosmosDBAccount
  name: cosmosDBDatabaseName
  properties: {
    options: {
      throughput:cosmosDBDatabaseThroughput
    }
    resource: {
      id: cosmosDBDatabaseName
    }
  }
}


