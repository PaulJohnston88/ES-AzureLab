/*  resource "azurerm_resource_group" "rg-weu-connectivity" {
   provider = azurerm.connectivity
   name     = "pjpfe-rg-weu-con-001"
   location = "west europe"
 }

 resource "azurerm_resource_group" "rg-neu-connectivity" {
   provider = azurerm.connectivity
   name     = "pjpfe-rg-neu-con-001"
   location = "north europe"
 } 
 
 resource "azurerm_virtual_network" "weuvnet001" {
   provider            = azurerm.connectivity
   name                = "pjpfe-vnet-weu-lz-001"
   address_space       = ["192.10.0.0/16"]
   location            = azurerm_resource_group.rg-weu-connectivity.location
   resource_group_name = azurerm_resource_group.rg-weu-connectivity.name
 }

 resource "azurerm_subnet" "weuvnet001subnet001" {
   provider             = azurerm.connectivity
   name                 = "pjpfe-subnet-weu-core-001"
   resource_group_name  = azurerm_resource_group.rg-weu-connectivity.name
   virtual_network_name = azurerm_virtual_network.weuvnet001.name
   address_prefixes     = ["192.10.1.0/24"]
 }

 resource "azurerm_virtual_network" "neuvnet001" {
   provider            = azurerm.connectivity
   name                = "pjpfe-vnet-neu-lz-001"
   address_space       = ["10.10.0.0/16"]
   location            = azurerm_resource_group.rg-neu-connectivity.location
   resource_group_name = azurerm_resource_group.rg-neu-connectivity.name
 }

 resource "azurerm_subnet" "neuvnet001subnet001" {
   provider             = azurerm.connectivity
   name                 = "pjpfe-subnet-neu-core-001"
   resource_group_name  = azurerm_resource_group.rg-neu-connectivity.name
   virtual_network_name = azurerm_virtual_network.neuvnet001.name
   address_prefixes     = ["10.10.1.0/24"]
 }

 resource "azurerm_virtual_wan" "vwan" {
  provider            = azurerm.connectivity
  name                = "pjpfe-vwan-001"
  resource_group_name = azurerm_resource_group.rg-weu-connectivity.name
  location            = azurerm_resource_group.rg-weu-connectivity.location

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_virtual_hub" "vwanhubweu" {
  provider = azurerm.connectivity
  name                = "pjpfe-vwan-hub-weu-001"
  resource_group_name = azurerm_resource_group.rg-weu-connectivity.name
  location            = azurerm_resource_group.rg-weu-connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "192.168.0.0/23"
}

resource "azurerm_virtual_hub" "vwanhubneu" {
  provider = azurerm.connectivity
  name                = "pjpfe-vwan-hub-neu-001"
  resource_group_name = azurerm_resource_group.rg-neu-connectivity.name
  location            = azurerm_resource_group.rg-neu-connectivity.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.254.0.0/23"
}

resource "azurerm_virtual_hub_connection" "weuvhubcon" {
  provider = azurerm.connectivity
  name                      = "pjpfe-weuvhub-lzvnet-001"
  virtual_hub_id            = azurerm_virtual_hub.vwanhubweu.id
  remote_virtual_network_id = azurerm_virtual_network.weuvnet001.id
}

resource "azurerm_virtual_hub_connection" "neuvhubcon" {
  provider = azurerm.connectivity
  name                      = "pjpfe-neuvhub-appvnet-001"
  virtual_hub_id            = azurerm_virtual_hub.vwanhubneu.id
  remote_virtual_network_id = azurerm_virtual_network.neuvnet001.id
}

resource "azurerm_firewall" "weuvhubfw" {
  provider = azurerm.connectivity
  name = "pjpfe-weu-vhub-fw-001"
  location = azurerm_resource_group.rg-weu-connectivity.location
  resource_group_name = azurerm_resource_group.rg-weu-connectivity.name
  sku_name = "AZFW_Hub"
  sku_tier = "Standard"
  threat_intel_mode = ""
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.vwanhubweu.id
  }
}

resource "azurerm_firewall" "neuvhubfw" {
  provider = azurerm.connectivity
  name = "pjpfe-neu-vhub-fw-001"
  location = azurerm_resource_group.rg-neu-connectivity.location
  resource_group_name = azurerm_resource_group.rg-neu-connectivity.name
  sku_name = "AZFW_Hub"
  sku_tier = "Standard"
  threat_intel_mode = ""
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.vwanhubneu.id
  }
}  */