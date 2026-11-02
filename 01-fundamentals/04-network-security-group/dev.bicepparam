using './main.bicep'

param nsgName = 'nsg-sukul'
param location = 'westeurope'
param securityRules = [
  {
    name: 'allow-https-in'
    description: 'Allow HTTPS traffic to the web application'
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
