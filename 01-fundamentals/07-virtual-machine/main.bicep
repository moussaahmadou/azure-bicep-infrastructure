@description('Name of the virtual machine.')
param vmName string

@description('Azure region for the virtual machine.')
param location string = resourceGroup().location

@description('Computer name used by the guest operating system.')
param computerName string = vmName

@description('Size of the virtual machine.')
param vmSize string

@description('Linux administrator username.')
param adminUsername string

@description('OpenSSH public key for the administrator. Do not provide a private key.')
param adminSshPublicKey string

@description('Full resource ID of the existing network interface.')
param networkInterfaceId string

@description('Publisher of the operating system image.')
param imagePublisher string = 'Canonical'

@description('Ubuntu image offer.')
param imageOffer string = '0001-com-ubuntu-server-noble'

@description('Ubuntu image SKU.')
param imageSku string = '24_04-lts-gen2'

@description('Image version; latest selects the newest available version.')
param imageVersion string = 'latest'

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
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
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceId
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
