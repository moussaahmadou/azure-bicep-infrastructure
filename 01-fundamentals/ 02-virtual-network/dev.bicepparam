using './main.bicep'

param virtualNetworkName = 'vnet-sukul'
param location = 'westeurope'
param addressPrefix = '10.0.0.0/16'
param subnets = [
  {
    name: 'Subnet-1'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'Subnet-2'
    addressPrefix: '10.0.1.0/24'
  }
]
