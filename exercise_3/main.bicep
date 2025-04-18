@description('The name of environment')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of solution')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The num of app service plan instance')
@minValue(1)
@maxValue(5)
param appServicePlanInstanceCount int = 1

@description('The name of tier of the app service plan SKU')
param appServicePlanSku object

@description('The region for deployment')
param location string = resourceGroup().location

// Add new parameters
@secure()
@description('The admin login uname for the sql server')
param sqlServerAdministratorLogin string

@secure()
@description('The admin login passw for the sql server')
param sqlServerAdministratorPassword string

@description('The name and tier of the sql db sku')
param sqlDataBaseSku object



var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'

// Add new variables
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'

// app service plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name:appServicePlanName
  location:location
  sku:{
    name:appServicePlanSku.name
    tier:appServicePlanSku.tier
    capacity:appServicePlanInstanceCount
  }
}

// web app
resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name:appServiceAppName
  location:location
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}

// Add SQL server and database resources

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name:sqlServerName
  location:location
  properties: {
    administratorLogin:sqlServerAdministratorLogin
    administratorLoginPassword:sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent:sqlServer
  name:sqlDatabaseName
  location:location
  sku:{
    name:sqlDataBaseSku.name
    tier:sqlDataBaseSku.tier
  }
}
