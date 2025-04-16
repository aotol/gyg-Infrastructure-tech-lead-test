param location string = resourceGroup().location
param sqlAdmin string = 'adminuser'
@secure()
param sqlPassword string

// API Management
resource apim 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: 'gyg-apim'
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    publisherEmail: 'admin@gyg.com'
    publisherName: 'GYG Company'
  }
}

// App Service Plan (For Function Apps)
resource appPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'gyg-app-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'functionapp'
}

// Azure Function App for API
resource functionApi 'Microsoft.Web/sites@2022-03-01' = {
  name: 'function-api'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appPlan.id
  }
}

// Azure Function App for DB
resource functionDb 'Microsoft.Web/sites@2022-03-01' = {
  name: 'function-db'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appPlan.id
  }
}

// Azure SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: gyg-sql-server'
  location: location
  properties: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlPassword
  }
}

// Azure SQL DB
resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: gyg-sql-server/gyg-db'
  location: location
  dependsOn: [sqlServer]
}

// Event Grid Topic
resource eventTopic 'Microsoft.EventGrid/topics@2022-06-15' = {
  name: gyg-topic'
  location: location
}

// Logic App (combined publisher + subscriber as placeholder)
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'main-logic-app'
  location: location
}

// Azure Monitor Logs (Log Analytics Workspace)
resource logs 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'log-workspace'
  location: location
}
