# Azure Linux VM Biicep deploy

## How to deploy

https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=CLI

Modifications

* This will happen when the subnet is declared as a child resource. 
* It is instead recommended to create all the subnets in the array property inside of the vnet, like you are doing with the first subnet in the above code sample:

https://github.com/Azure/bicep/issues/4653

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
    }
  }
}

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
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }

    ]
  }
}

// And had to update reference subnet id on the NetworkInterface
// From

subnet: {
            id: subnet.id
          }

// To

subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName, subnetName)
          }

```

## Login

## Learn

Bash for Beginners

https://learn.microsoft.com/en-us/shows/bash-for-beginners/

Learn the ways of Linux-fu, for free.

https://linuxjourney.com/



