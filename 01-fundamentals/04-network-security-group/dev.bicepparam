using './main.bicep'

param nsgName = 'nsg-sukul'
param location = 'westeurope'
param securityRules = [
  {
    name: 'allow-https-in'
    description: 'Autoriser HTTPS vers l application web'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
  }
]
