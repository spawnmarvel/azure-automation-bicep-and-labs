@description('The Azure region')
param location string = resourceGroup().location

@description('The type of env, this must be prod or nonprod')
@allowed([
  'prod'
  'nonprod'
])
param environmentType string
