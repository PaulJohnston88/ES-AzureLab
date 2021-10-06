# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.66.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "b7190f8a-860a-428c-a303-7231b1eb2f60"
  tenant_id       = "5702f542-8ed2-4422-a818-5a1f3515837a"
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "e0583bb4-bb6c-44b8-9b39-72b0d4a1a6eb"
  tenant_id       = "5702f542-8ed2-4422-a818-5a1f3515837a"
  features {}
}