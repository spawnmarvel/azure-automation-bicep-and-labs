// https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/6-exercise-create-use-parameter-files?pivots=powershell
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
param appServicePlanSku object = {
  name:'F1'
  tier:'Free'
}
@description('The region for deployment')
param location string = resourceGroup().location

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name:appServicePlanName
  location:location
  sku:{
    name:appServicePlanSku.name
    tier:appServicePlanSku.tier
    capacity:appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name:appServiceAppName
  location:location
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}
