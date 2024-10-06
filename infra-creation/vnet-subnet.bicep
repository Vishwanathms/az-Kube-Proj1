@description('The name of the virtual network')
param vnetName string = 'myVNet'

@description('The address space for the virtual network')
param vnetAddressSpace string = '10.0.0.0/16'

@description('The name of the subnet')
param subnetName string = 'mySubnet'

@description('The address prefix for the subnet')
param subnetPrefix string = '10.0.1.0/24'

@description('The location for the virtual network')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
