#-----------------------------
# Create a Resource Group
#-----------------------------
resource "azurerm_resource_group" "cp_azure_rg" {
    name = "Prisca-Azure-Lab"
    location = var.azure_location
}

#-----------------------------
# Virtual Network
#-----------------------------
resource "azurerm_virtual_network" "cp_azure_vn" {
    name = "cp-azure-vn"
    resource_group_name = azurerm_resource_group.cp_azure_rg.id
    location = var.azure_location
    address_space = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "cp_azure_subnet" {
  name                 = "cp-azure-subnet"
  resource_group_name  = azurerm_resource_group.cp_azure_rg.name
  virtual_network_name = azurerm_virtual_network.cp_azure_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "cp_azure_public_ip" {
  name                = "cp-azure-public-ip"
  resource_group_name = azurerm_resource_group.cp_azure_rg.name
  location            = azurerm_virtual_network.cp_azure_vn.location
  allocation_method   = "Static"
}

# Security Group
resource "azurerm_network_security_group" "cp_azure_ssh_nsg" {
  name                = "cp-azure-ssh-nsg"
  location            = azurerm_virtual_network.cp_azure_vn.location
  resource_group_name = azurerm_resource_group.cp_azure_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "AllowWebHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "cp_azure_nic" {
  name                = "cp-azure-nic"
  location            = azurerm_virtual_network.cp_azure_vn.location
  resource_group_name = azurerm_resource_group.cp_azure_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cp_azure_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cp_azure_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "cp_azure_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.cp_azure_nic.id
  network_security_group_id = azurerm_network_security_group.cp_azure_ssh_nsg.id
}

#-----------------------------
# Create a Virtual Machine
#-----------------------------
resource "azurerm_linux_virtual_machine" "cp_azure_vm" {
  name                = "cp-azure-vm"
  resource_group_name = azurerm_resource_group.cp_azure_rg.name
  location            = azurerm_virtual_network.cp_azure_vn.location
  size                = "Standard_D4_v5"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.cp_azure_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}