

// This file deploys an Azure App Service plan and an app. 
// Notice that the module is fairly generic. It doesn't include any assumptions about the names of resources, or the App Service plan's SKU. 
// This makes it easy to reuse the module for different deployments.

@description('The az region for deployment')
param location string

@description('The name of the app service app')
param appServiceAppName string

@description('The name if the app service plan')
param appServicePlanName string

@description('The name of the app service plan SKU')
param appServicePlanSkuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name:appServicePlanName
  location:location
  sku:{
    name:appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name:appServiceAppName
  location:location
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}

@description('The default host name of the app service app')
output appServiceHostName string = appServiceApp.properties.defaultHostName
