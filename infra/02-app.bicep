targetScope = 'resourceGroup'

param location string = resourceGroup().location
param appName string
param envName string

param image string            // z.B. myacr.azurecr.io/spring-aca:abcd123
param acrServer string        // z.B. myacr.azurecr.io
param acrUsername string
@secure()
param acrPassword string

param targetPort int = 8080

resource env 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: envName
}

resource app 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  properties: {
    managedEnvironmentId: env.id
    configuration: {
      ingress: {
        external: true
        targetPort: targetPort
        transport: 'auto'
      }
      secrets: [
        {
          name: 'acr-pwd'
          value: acrPassword
        }
      ]
      registries: [
        {
          server: acrServer
          username: acrUsername
          passwordSecretRef: 'acr-pwd'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'app'
          image: image
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}

output fqdn string = app.properties.configuration.ingress.fqdn
