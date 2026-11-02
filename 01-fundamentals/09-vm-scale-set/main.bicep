@description('Name of the virtual machine scale set.')
param vmssName string

@description('Azure region for the virtual machine scale set.')
param location string = resourceGroup().location

@description('Virtual machine size used by each scale set instance.')
param vmSize string

@description('Initial number of virtual machine instances.')
@minValue(1)
param instanceCount int = 2

@description('Linux administrator username.')
param adminUsername string

@description('OpenSSH public key for the administrator. Do not provide a private key.')
param adminSshPublicKey string

@description('Name of the existing virtual network in the deployment resource group.')
param virtualNetworkName string

@description('Name of the existing subnet for the scale set instances.')
param subnetName string

@description('Publisher of the operating system image.')
param imagePublisher string = 'Canonical'

@description('Ubuntu image offer.')
param imageOffer string = '0001-com-ubuntu-server-noble'

@description('Ubuntu image SKU.')
param imageSku string = '24_04-lts-gen2'

@description('Image version; latest selects the newest available version.')
param imageVersion string = 'latest'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: virtualNetwork
  name: subnetName
}

resource virtualMachineScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2024-07-01' = {
  name: vmssName
  location: location
  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    orchestrationMode: 'Uniform'
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: vmssName
        adminUsername: adminUsername
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: {
            publicKeys: [
              {
                path: '/home/${adminUsername}/.ssh/authorized_keys'
                keyData: adminSshPublicKey
              }
            ]
          }
        }
      }
      storageProfile: {
        imageReference: {
          publisher: imagePublisher
          offer: imageOffer
          sku: imageSku
          version: imageVersion
        }
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'primary-nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'primary-ipconfig'
                  properties: {
                    subnet: {
                      id: subnet.id
                    }
                    primary: true
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

output vmssId string = virtualMachineScaleSet.id