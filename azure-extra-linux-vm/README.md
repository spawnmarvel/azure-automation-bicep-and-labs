# Azure Linux VM Bicep deploy

## How to deploy

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=CLI

### Modifications, since the template was not made for redeploy when resources existed.

* i.e default template was deployed, tried to change SKU, but it prompted error about vnet elready existing
* * This will happen when the subnet is declared as a child resource. 
* *  It is instead recommended to create all the subnets in the array property inside of the vnet, like you are doing with the first subnet in the above code sample:
* * https://github.com/Azure/bicep/issues/4653

```
// Not able to redeploy due to hardcode subnet
// Edit from

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    [...]

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

//To
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    // 1. It is instead recommended to create all the subnets in the array property inside of the vnet, like you are doing with the first subnet in the above code sample:
    // 1. https://github.com/Azure/bicep/issues/4653
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      [...]

// And had to update reference subnet id on the NetworkInterface
// From
subnet: {
            id: subnet.id
          }

// To
subnet: {
             // 1.2 And had to update reference subnet id on the NetworkInterface
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnetName)
          }

```
* Add a data disk

```
  // 2. Add a data disk start
 dataDisks:[
        {
          diskSizeGB:8
          lun:0
          createOption:'Empty'
          name:'${vmName}-dataDiskLun0'
        }
      ]
     // 2. Add a datadisk end
```

* Place in existing vnet in a different rg

## Login view outputs

```
output adminUsername string = adminUsername
output hostname string = publicIPAddress.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${adminUsername}@${publicIPAddress.properties.dnsSettings.fqdn}'
```

ssh user@ip-orname@something

![Output ](https://github.com/spawnmarvel/azure-automation/blob/main/images/linux_output.jpg)

## Learn

Bash for Beginners

https://learn.microsoft.com/en-us/shows/bash-for-beginners/

Learn the ways of Linux-fu, for free.

https://linuxjourney.com/



