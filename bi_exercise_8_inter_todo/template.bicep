param virtualMachines_ToyTruckServer8_name string = 'ToyTruckServer8'
param disks_ToyTruckServer8_OsDisk_1_5b099894259841e2ba422126fdf53561_externalid string = '/subscriptions/my-subscription-12345/resourceGroups/Rg-iac-00102/providers/Microsoft.Compute/disks/ToyTruckServer8_OsDisk_1_5b099894259841e2ba422126fdf53561'
param networkInterfaces_toytruckserver8680_externalid string = '/subscriptions/my-subscription-12345/resourceGroups/Rg-iac-00102/providers/Microsoft.Network/networkInterfaces/toytruckserver8680'

resource virtualMachines_ToyTruckServer8_name_resource 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: virtualMachines_ToyTruckServer8_name
  location: 'uksouth'
  tags: {
    CostCenter: 'Private'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_ToyTruckServer8_name}_OsDisk_1_5b099894259841e2ba422126fdf53561'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_ToyTruckServer8_OsDisk_1_5b099894259841e2ba422126fdf53561_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_ToyTruckServer8_name
      adminUsername: 'Prime'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_toytruckserver8680_externalid
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
