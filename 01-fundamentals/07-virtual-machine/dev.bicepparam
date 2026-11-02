using './main.bicep'

param vmName = 'vm-sukul-dev'
param location = 'westeurope'
param computerName = 'vm-sukul-dev'
param vmSize = 'Standard_B2s'
param adminUsername = 'azureadmin'

// Replace this value with your OpenSSH public key; never use your private key.
param adminSshPublicKey = 'REPLACE_WITH_YOUR_SSH_PUBLIC_KEY'

// Replace the subscription, resource group, and name with those of the existing NIC.
param networkInterfaceId = '/subscriptions/<subscription-id>/resourceGroups/rg-sukul-dev/providers/Microsoft.Network/networkInterfaces/nic-vm-sukul-dev'

param imagePublisher = 'Canonical'
param imageOffer = '0001-com-ubuntu-server-noble'
param imageSku = '24_04-lts-gen2'
param imageVersion = 'latest'
