param nsgName string
param location string = resourceGroup().location

@description('Règles de sécurité à configurer sur le NSG')
param securityRules array

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      for rule in securityRules: {
        name: rule.name
        properties: {
          description: rule.description
          protocol: rule.protocol
          sourcePortRange: rule.sourcePortRange
          destinationPortRange: rule.destinationPortRange
          sourceAddressPrefix: rule.sourceAddressPrefix
          destinationAddressPrefix: rule.destinationAddressPrefix
          access: rule.access
          priority: rule.priority
          direction: rule.direction
        }
      }
    ]
  }
}
