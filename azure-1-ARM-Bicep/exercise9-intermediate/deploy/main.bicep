@description('The Azure region')
param location string = resourceGroup().location

@description('The type of env, this must be prod or nonprod')
@allowed([
  'prod'
  'nonprod'
])
param environmentType string

@description('The name of the App Service app. This must be globally unique')
param appServiceAppName string = 'toyweb-${uniqueString(resourceGroup().id)}'

module appService 'modules/app-service.bicep' = {
  name: 'app-service'
  params: {
    appServiceAppName: appServiceAppName
    environmentType: environmentType
    location: location
  }
}
