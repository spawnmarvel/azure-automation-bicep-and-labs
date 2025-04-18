@description('The location of rgs')
param location string = resourceGroup().location

@description('The type of env')
@allowed([
  'Production'
  'Test'
])
param environmentType string

@description('A unique suffix for names')
@maxLength(13)
param resouceNameSuffix string = uniqueString(resourceGroup().id)

@description('The admin login user name for sql server')
param sqlAdministratorLogin string

@secure()
@description('The admin password for sql server')
param sqlAdministratorPassword string

@description('The tags to apply')
param tags object = {
  CostCenter: 'Marketing'
  DataClassification: 'Public'
  Owner: 'WebSiteTeam'
  Environment: 'Production'
}

// Define the names for resources

var appServiceAppName = 'website${resouceNameSuffix}'
var appServicePlanName = 'AppServicePlan'
var sqlServerName = 'sqlServer${resouceNameSuffix}'
var sqlDataBaseName = 'ToyCompanyWebsite'
var managedIdetityName = 'WebSite'
var applicationInsightsName = 'AppInsights'
var storageAccountName = 'toywebsite${resouceNameSuffix}'
var blobContainerNames = [
  'productspcs'
  'productmanuals'
]

@description('Define the skus for each comp based on env')
var environmentConfigurationMap = {
  Production: {
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    storageAccount: {
      sku: 'Standard_LRS'
    }
  }
  sqlDataBase: {
    sku: {
      name: 'S1'
      tier: 'Stadard'
    }
  }

  Test: {
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    storageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
    sqlDataBase: {
      sku: {
        name: 'Basic'
      }
    }
  }
}

@description('The role definition ID of the built in Azure \'Contributor\' role')
var contributorRoleDefinitionId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var storageAccountConnectionString = 'DefaultEndPointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'


resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  tags:tags
  properties:{
    administratorLogin:sqlAdministratorLogin
    administratorLoginPassword:sqlAdministratorPassword
    version:'12.0'
  }
}

resource sqlDataBase 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  parent:sqlServer
  name:sqlDataBaseName
  location:location
  sku: environmentConfigurationMap[environmentType].sqlDatabase.sku
  tags:tags
}

resource sqlFireWallRuleAllowAllAzureIPs 'Microsoft.Sql/servers/firewallRules@2014-04-01' = {
  parent:sqlServer
  name:'AllowAllAzureIPs'
  properties:{
    endIpAddress:'0.0.0.0'
    startIpAddress:'0.0.0.0'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name:appServicePlanName
  location:location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
  tags:tags
}

resource appServiceApp 'Microsoft.Web/sites@2020-06-01' = {
  name:appServiceAppName
  location:location
  tags:tags
  properties:{
    serverFarmId:appServicePlan.id
    siteConfig:{
      appSettings:[
        {
          name:'APPINSIGHTS_INSTRUMENTATIONKEY'
          value:applicationInsights.properties.InstrumentationKey
        }
        {
          name:'StorageAccountConnectionString'
          value:storageAccountConnectionString
        }
      ]
    }
  }
  identity:{
    type:'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {} // this format is required when working with user-assigned managed identites
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: environmentConfigurationMap[environmentType].storageAccount.sku
  kind:'StorageV2'
  properties:{
    accessTier:'Hot'
  }
  
  resource blobService 'blobServices' existing = {
    name: 'default'

    resource containers 'containers' = [for blobContainerName in blobContainerNames : {
      name:blobContainerName
    }]
  }
}

@description('A user-assigned managed identity that is used by the app service app to communicate with a storage account')
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name:managedIdetityName
  location:location
  tags:tags
}

@description('Grant the \'Contributor\' role to the user-assigned managed identity, at the scope of the resource group ')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(contributorRoleDefinitionId, resourceGroup().id) // Create a guide based on the role definition ID and scope (resource group). This will return the same guid every time the template is deployed to the same resource group
  properties:{
    principalType:'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Autorization/roleDefinitions', contributorRoleDefinitionId)
    principalId:managedIdentity.properties.principalId
    description:'Grant the "Contributor" role to the user-assigned managed identity so it can access the storage account.'
  }
   
  }


resource applicationInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  tags:tags
  properties:{
    Application_Type:'web'
  }
}
