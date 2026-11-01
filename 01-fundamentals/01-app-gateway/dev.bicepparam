using './main.bicep'

param appGatewayName = 'agw-sukul-dev'
param location = 'westeurope'
param virtualNetworkName = 'vnet-sukul'
param gatewaySubnetName = 'snet-app-gateway'
param publicIpName = 'pip-agw-sukul-dev'

// Remplacez cette adresse par l'IP privée d'un backend HTTP existant et joignable.
param backendAddresses = [
  '10.0.1.4'
]

param frontendPort = 80
param backendPort = 80
