terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Use the latest stable version
    }
  }
}


provider "azurerm" {
  features {}
  subscription_id = "12100be1-d71d-4710-8cf2-d85c7a999be1"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "notepad-app-rg111"
  location = "Canada Central"
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "notepad-cosmosdb11"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

# App Service Plan for Backend
resource "azurerm_app_service_plan" "backend_plan" {
  name                = "notepad-backend-plan11"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "backend" {
  name                = "notepad-backend11"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.backend_plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    MONGO_URI = azurerm_cosmosdb_account.cosmosdb.primary_mongodb_connection_string
    CORS_ORIGIN    = "https://notepad-frontend1.azurewebsites.net"
    PORT           = "4000"

   }
}
# Create a Web App for the Frontend
resource "azurerm_linux_web_app" "frontend" {
  name                = "notepad-frontend11"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_app_service_plan.backend_plan.id

  site_config {
    http2_enabled    = true
    websockets_enabled = true

 
}

  app_settings = {
    REACT_APP_API_URL = "https://notepad-backend1.azurewebsites.net"
  }
}
# Output URLs
output "frontend_url" {
  value = azurerm_linux_web_app.frontend.default_hostname

}
output "web_app_name" {
  value = azurerm_linux_web_app.frontend.name
}

output "mongodb_uri" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_mongodb_connection_string
  sensitive = true

}

