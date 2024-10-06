@description('Name of the Azure Container Registry')
param acrName string = 'myconvishwa290924'

@description('Location for the Azure Container Registry')
param location string = resourceGroup().location

@description('SKU of the Azure Container Registry (Basic, Standard, Premium)')
param acrSku string = 'Standard'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrLoginServer string = acr.properties.loginServer
output acrAdminUsername string = acr.properties.adminUserEnabled ? listCredentials(acr.id, '2023-01-01').username : null
output acrAdminPassword string = acr.properties.adminUserEnabled ? listCredentials(acr.id, '2023-01-01').passwords[0].value : null
