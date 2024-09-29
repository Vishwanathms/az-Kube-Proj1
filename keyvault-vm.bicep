@description('Name of the Virtual Machine')
param vmName string = 'myVM'

@description('Administrator username for the Virtual Machine')
param adminUsername string = 'adminUser'

@description('Administrator password for the Virtual Machine')
@secure()
param adminPassword string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Size of the Virtual Machine')
param vmSize string = 'Standard_B1s'

@description('ID of the existing Virtual Network')
param vnetId string

@description('Name of the existing Subnet')
param subnetName string

@description('Name of the Key Vault')
param keyVaultName string = 'kvvishwa290924'

@description('Public IP Allocation Method (Static/Dynamic)')
param publicIpAllocationMethod string = 'Dynamic'

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: '${vmName}-publicIP'
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          subnet: {
            id: '${vnetId}/subnets/${subnetName}'
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-11-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: subscription().tenantId
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
            'delete'
          ]
        }
      }
    ]
    enabledForDeployment: true
    enabledForTemplateDeployment: true
  }
}

resource vmAdminUsernameSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = {
  parent: keyVault
  name: 'vmAdminUsername'
  properties: {
    value: adminUsername
  }
}

resource vmAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2022-11-01' = {
  parent: keyVault
  name: 'vmAdminPassword'
  properties: {
    value: adminPassword
  }
}

output vmPublicIP string = publicIP.properties.ipAddress
output keyVaultUri string = keyVault.properties.vaultUri
