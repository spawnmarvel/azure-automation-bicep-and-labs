@description('The az regions for deployments')
param locations array = [
  'westeurope'
  'uksouth'
]

@secure()
@description('The administrator login username for sql server')
param sqlServerAdministratorLogin string


@secure()
@description('The administrator login password for sql server')
param sqlServerAdministratorPassword string

module database 'modules/database.bicep' = [for location in locations: {
  // Notice that the module declaration loops over all the values in the locations array parameter
  name:'database-${location}'
  params:{
    location:location
    sqlServerAdministratorLogin:sqlServerAdministratorLogin
    sqlServerAdministratorPassword:sqlServerAdministratorPassword
  }
}]
