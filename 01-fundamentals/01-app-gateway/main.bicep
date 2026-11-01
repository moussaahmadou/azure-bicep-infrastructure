@description('Nom de la passerelle Application Gateway.')
param appGatewayName string

@description('Région Azure de la passerelle et de son adresse IP publique.')
param location string = resourceGroup().location

@description('Nom du réseau virtuel qui contient le sous-réseau dédié à la passerelle.')
param virtualNetworkName string

@description('Nom du sous-réseau dédié à Application Gateway.')
param gatewaySubnetName string

@description('Nom de l’adresse IP publique Standard créée pour la passerelle.')
param publicIpName string

@description('Adresses IPv4 privées des serveurs HTTP du pool backend.')
param backendAddresses array

@description('Port HTTP exposé par le listener.')
param frontendPort int = 80

@description('Port HTTP utilisé pour joindre les serveurs backend.')
param backendPort int = 80

// Le réseau et le sous-réseau doivent exister avant le déploiement de la passerelle.
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
}

resource gatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: virtualNetwork
  name: gatewaySubnetName
}

// Application Gateway v2 requiert une adresse IP publique Standard et statique.
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2024-05-01' = {
  name: appGatewayName
  location: location
  properties: {
    // Le mode v2 ajuste la capacité entre 0 et 2 instances selon le trafic.
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 2
    }
    enableHttp2: true
    gatewayIPConfigurations: [
      {
        name: 'gateway-ip-configuration'
        properties: {
          subnet: {
            id: gatewaySubnet.id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'frontend-public'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'frontend-port'
        properties: {
          port: frontendPort
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backend-pool'
        properties: {
          backendAddresses: [
            for address in backendAddresses: {
              ipAddress: address
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'backend-http-settings'
        properties: {
          port: backendPort
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 30
        }
      }
    ]
    httpListeners: [
      {
        name: 'listener-http'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, 'frontend-public')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, 'frontend-port')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'routing-rule'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, 'listener-http')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, 'backend-pool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, 'backend-http-settings')
          }
        }
      }
    ]
  }
}
