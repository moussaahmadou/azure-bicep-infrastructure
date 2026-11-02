using './main.bicep'

param vmssName = 'vmss-sukul-dev'
param location = 'westeurope'
param vmSize = 'Standard_B2s'
param instanceCount = 2
param adminUsername = 'azureadmin'

// Replace this value with your OpenSSH public key; never use your private key.
param adminSshPublicKey = 'REPLACE_WITH_YOUR_SSH_PUBLIC_KEY'

// These resources must already exist in the deployment resource group.
param virtualNetworkName = 'vnet-sukul'
param subnetName = 'Subnet-2'

param imagePublisher = 'Canonical'
param imageOffer = '0001-com-ubuntu-server-noble'
param imageSku = '24_04-lts-gen2'
param imageVersion = 'latest'
