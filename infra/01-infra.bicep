targetScope = 'resourceGroup'

param location string = resourceGroup().location
param acrName string
param envName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: { name: 'Basic' }
  properties: {
    adminUserEnabled: true
  }
}

resource env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: envName
  location: location
  properties: {}
}

output acrLoginServer string = acr.properties.loginServer
output envId string = env.id
