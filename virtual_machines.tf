/* resource "azurerm_resource_group" "rg-weu-servers-001" {
  name     = "pjpfe-rg-weu-svrs-001"
  location = "west europe"
}

resource "azurerm_resource_group" "rg-neu-servers-001" {
  name     = "pjpfe-rg-neu-svrs-001"
  location = "north europe"
}

resource "azurerm_network_interface" "nic-weu-appsvr-001" {
  name                = "pjpfe-nic-weu-appsvr-001"
  location            = azurerm_resource_group.rg-weu-servers-001.location
  resource_group_name = azurerm_resource_group.rg-weu-servers-001.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.weuvnet001subnet001.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm-weu-appsvr-001" {
  name                = "weuappsvr-001"
  resource_group_name = azurerm_resource_group.rg-weu-servers-001.name
  location            = azurerm_resource_group.rg-weu-servers-001.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic-weu-appsvr-001.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
} */