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

@description('The ip adr range for all vnets to use')
// This example uses the same address space for all the virtual networks. 
// Ordinarily, when you create multiple virtual networks, you would give them different address spaces in the event that you need to connect them together.
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('The name and and ip adr range for each subnet in the vnet')
param subnets array = [
  { 
    name:'frontend'
    ipAddressRange:'10.10.5.0/24'
  }
  {
    name:'backend'
    ipAddressRange:'10.10.10.0/24'
  }
]

var subnetProperties = [for subnet in subnets: {
  name:subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

module databases 'modules/database.bicep' = [for location in locations: {
  // Notice that the module declaration loops over all the values in the locations array parameter
  name:'database-${location}'
  params:{
    location:location
    sqlServerAdministratorLogin:sqlServerAdministratorLogin
    sqlServerAdministratorPassword:sqlServerAdministratorPassword
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-08-01' = [for location in locations: {
  name:'teddy-${location}'
  location:location
  properties:{
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
      ]
    }
    subnets:subnetProperties
  }
}]

output serverInfo array = [for i in range(0, length(locations)): {
  name:databases[i].outputs.serverName
  location:databases[i].outputs.location
  fullyQualifiedDomainName:databases[i].outputs.serverFullyQualifiedDomainName
}]
