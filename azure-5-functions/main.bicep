// Microsoft.Storage/storageAccounts: create an Azure Storage account, which is required by Functions.
// Microsoft.Web/serverfarms: create a serverless Consumption hosting plan for the function app.
// Microsoft.Web/sites: create a function app.
// microsoft.insights/components: create an Application Insights instance for monitoring.

@description('Name of function app')
param appName string = 'fnapp-${uniqueString(resourceGroup().id)}'

@description('Storage account types')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Location for resources')
param location string = resourceGroup().location

@description('The language worker runtime to load on the function app')
@allowed([
  'python'
  'powershell'
])
param runtime string = 'powershell'

var functionAppName = appName
var hostingPlanName = appName
var applicationInsightsName = appName
var storageAccountName = '${uniqueString(resourceGroup().id)}azfunctions'
var functionWorkerRuntime = runtime

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
  properties:{
    supportsHttpsTrafficOnly:true
    defaultToOAuthAuthentication:true
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: hostingPlanName
  location: location
  sku:{
    name:'Y1'
    tier:'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind:'functionapp'
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    serverFarmId:hostingPlan.id
    siteConfig:{
      appSettings:[
        {
          name:'AzureWebJobsStorage'
          value:'DefaultEndpointProtocol=https;AccountName=${storageAccountName};Endpointsuffix=${environment().suffixes.storage};Accountkey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name:'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value:'DefaultEndpointProtocol=https;AccountName=${storageAccountName};Endpointsuffix=${environment().suffixes.storage};Accountkey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name:'WEBSITE_CONTENTSHARE'
          value:toLower(functionAppName)
        }
        {
          name:'FUNCTION_EXTENSION_VERSION'
          value:'~4'
        }
        {
          name:'APPINSIGHT_INTRUMENTATIONKEY'
          value:applicationInsight.properties.InstrumentationKey
        }
        {
          name:'FUNCTION_WORKER_RUNTIME'
          value:functionWorkerRuntime
        }
      ]
      ftpsState:'FtpsOnly'
      minTlsVersion:'1.2'
    }
  }
}

resource applicationInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
  }
}
