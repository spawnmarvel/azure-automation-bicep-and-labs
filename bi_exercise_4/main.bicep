
// Because this is the template that you intend to deploy for your toy websites, it's a little more specific. 
// The App Service plan name is defined as a variable. The SKU parameter has a default value that makes sense for the toy launch website.

@description('The az region for deployments')
// Normally, you would create resources in the same location as the resource group by using the resourceGroup().location property. 
param location string = resourceGroup().location

@description('The name of the app service app')
param appServiceAppName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('The name of the app service plan SKU')
param appServicePlanSkuName string = 'F1'

@description('Indicates wheter a CND should be deployed')
param deployCDN bool = true

var appServicePlanName = 'toy-product-launch-plan'

module app 'modules/app.bicep' = {
  name: 'toy-launch-app'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}

module cnd 'modules/cdn.bicep' = if(deployCDN) {
  name: 'toy-launch-cnd'
  params: {
    httpsOnly: true
    originHostName:app.outputs.appServiceHostName 
  }
}
@description('The host name to use to access the website.')
output webSiteHostName string = deployCDN ? cnd.outputs.endpointHostName: app.outputs.appServiceHostName
