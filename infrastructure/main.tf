# Simple Terraform configuration for eShop Azure deployment
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-eshop-${random_string.suffix.result}"
  location = "East US"
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-eshop-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "B1"
  os_type             = "Linux"
}

# Web App
resource "azurerm_linux_web_app" "eshop" {
  name                = "app-eshop-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  
  site_config {
    always_on = false
    
    application_stack {
      dotnet_version = "8.0"
    }
  }
  
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "ASPNETCORE_ENVIRONMENT"              = "Production"
  }
}

# Outputs
output "web_app_url" {
  value = "https://${azurerm_linux_web_app.eshop.default_hostname}"
}

output "web_app_name" {
  value = azurerm_linux_web_app.eshop.name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}