// Create a Bicep template that contains an Azure Cosmos DB account

param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
param cosmosDBDatabaseThroughput int = 400
param location string = resourceGroup().location
// Add a database
var cosmosDBDatabaseName = 'FlightTest'
// Add a container
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerPartionKey = '/droneId'

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
    resource: {
      id: cosmosDBDatabaseName
    }
    options: {
      throughput:cosmosDBDatabaseThroughput
    }
   
  }
  // We used a short resource type, containers, because Bicep understands that it belongs under the parent resource type. 
  // Bicep knows that the fully qualified resource type is Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers. 
  // We haven't specified an API version, so Bicep uses the version from the parent resource, 2020-04-01.
  resource container 'containers' = {
    name: cosmosDBContainerName
    properties: {
      options: {}
      resource: {
        id: cosmosDBContainerName
        partitionKey:{
          kind:'Hash'
          paths:[
            cosmosDBContainerPartionKey
          ]
        }
      }
    }
  }
}


