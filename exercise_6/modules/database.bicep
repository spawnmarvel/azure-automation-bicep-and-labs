@description('The region for deployment')
param location string

@secure()
@description('The admin login password for sql server')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator password for sql server')
param sqlServerAdministratorPassword string

@description('The name and tier of the sql database SKU')
param sqlDatabaseSku object = {
  name:'Standard'
  tier:'Standard'

} 

@description('The name of the env, this must be dev or prod')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The name of the audit storage account SKU')
param auditStorageAccountSkuName string = 'standard_LRS'


var sqlServerName = 'teddy${location}-${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'

// Notice that you're creating a variable called auditingEnabled, which you'll use as the condition for deploying the auditing resources.
var auditingEnabled = environmentName == 'Production'
// take(). Storage account names have a maximum length of 24 characters, so this function trims the end off the string to ensure that the name is valid.
var auditStorageAccountName = take('bearaudit${location}${uniqueString(resourceGroup().id)}',24)

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name:sqlServerName
  location:location
  properties: {
    administratorLogin:sqlServerAdministratorLogin
    administratorLoginPassword:sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  // reference to instance above
  parent:sqlServer
  name:sqlDatabaseName
  location:location
  sku:sqlDatabaseSku
}

// Notice that the definitions for the storage account include the if keyword, which specifies a deployment condition.
resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = if(auditingEnabled) {
  name:auditStorageAccountName
  location:location
  sku:{
    name:auditStorageAccountSkuName
  }
  kind:'StorageV2'
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = if(auditingEnabled) {
  parent:sqlServer
  name:'default'
  properties:{
    state:'Enabled'
    storageEndpoint:environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey:environmentName == 'Production' ? auditStorageAccount.listkeys().keys[0].value : ''
  }

}

output serverName string = sqlServer.name
output location string = location
output serverFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName


