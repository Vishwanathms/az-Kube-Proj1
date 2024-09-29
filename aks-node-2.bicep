@description('Name of the AKS cluster')
param aksClusterName string = 'myAKSCluster'

@description('Kubernetes version for the AKS cluster')
param kubernetesVersion string = '1.28.0'

@description('Node count for the AKS cluster')
param nodeCount int = 2

@description('Name of the VM size for the AKS nodes')
param nodeVmSize string = 'Standard_DS2_v2'

@description('ID of the existing Virtual Network')
param vnetId string

@description('Name of the existing Subnet within the VNet')
param subnetName string

@description('Location of the resources')
param location string = resourceGroup().location

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-07-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: aksClusterName
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        vnetSubnetId: '${vnetId}/subnets/${subnetName}'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '10.0.0.0/24'

    }
  }
}

output aksClusterFqdn string = aksCluster.properties.fqdn
output aksClusterIdentityPrincipalId string = aksCluster.identity.principalId
