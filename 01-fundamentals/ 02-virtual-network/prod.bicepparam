using './main.bicep'

param virtualNetworkName = 'vnet-sukul-prod'
param location = 'westeurope'
param addressPrefix = '10.1.0.0/16'
param subnets = [
  {
    name: 'AzureFirewallSubnet'
    addressPrefix: '10.1.0.0/26'
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: '10.1.0.64/26'
  }
  {
    name: 'snet-app-gateway'
    addressPrefix: '10.1.1.0/24'
  }
  {
    name: 'snet-app'
    addressPrefix: '10.1.2.0/24'
  }
  {
    name: 'snet-database'
    addressPrefix: '10.1.3.0/24'
  }
  {
    name: 'snet-test'
    addressPrefix: '10.1.4.0/24'
  }
]
