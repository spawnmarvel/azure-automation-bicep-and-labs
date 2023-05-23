// Create a Bicep template that contains an Azure Cosmos DB account

param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
param cosmosDBDatabaseThroughput int = 400
param location string = resourceGroup().location
// Add diagnostics settings for storage account
param storageAccountName string
// Add a database
var cosmosDBDatabaseName = 'FlightTest'
// Add a container
var cosmosDBContainerName = 'FlightTests'
var cosmosDBContainerPartionKey = '/droneId'
// Add diagnostics settings for Azure Cosmos DB
var logAnalyticsWorkspaceName = 'ToyLogs'
var cosmosDBAccountDignosticsSettingsName = 'route-logs-to-log-analytics'
var storageAccountBlobDiagnosticSettingsName = 'route-logs-to-log-analytics'

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

// Notice that this resource definition uses the existing keyword, and that you're purposely omitting 
// other properties that you'd normally specify if you were deploying the Log Analytics workspace through this Bicep template.
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' existing = {
  name: logAnalyticsWorkspaceName
}

resource cosmosDBAccountDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope:cosmosDBAccount
  name: cosmosDBAccountDignosticsSettingsName
  properties:{
    workspaceId:logAnalyticsWorkspace.id
    logs:[
      {
        category:'DataPlaneRequests'
        enabled:true
      }
    ]
  }
}

// You need to update your Bicep template to reference the storage account you created in the previous step.
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name:storageAccountName
  resource blobservice 'blobservices' existing = {
    name: 'default'
  }
}

resource storageAccountBlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope:storageAccount::blobservice
  name:storageAccountBlobDiagnosticSettingsName
  properties:{
    workspaceId:logAnalyticsWorkspace.id
    logs:[
      {
        category:'StorageRead'
        enabled:true
      }
      {
        category:'StorageWrite'
        enabled:true
      }
      {
        category:'StorageDelete'
        enabled:true
      }
    ]
  }
}
