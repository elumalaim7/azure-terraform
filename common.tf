# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.azure.subscription_id
  client_id       = var.azure.client_id
  client_secret   = var.azure.client_secret
  tenant_id       = var.azure.tenant_id

  # use latest
  #version         = 2.1

  features {}
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "tfrg" {
  name     = "${var.resource.prefix}-rg"
  location = var.resource.location

  tags = {
    environment = var.resource.tag
  }
}

# Create virtual network
resource "azurerm_virtual_network" "tfvnet" {
  name                = "${var.resource.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource.location
  resource_group_name = azurerm_resource_group.tfrg.name

  tags = {
    environment = var.resource.tag
  }
}

resource "azurerm_subnet" "tfnatvnet" {
  name                 = "app-natnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "tfwebvnet" {
  name                 = "web-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "tfappvnet" {
  name                 = "app-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "tfjboxvnet" {
  name                 = "jbox-subnet"
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  resource_group_name  = azurerm_resource_group.tfrg.name
  address_prefixes     = ["10.0.3.0/24"]
}

/*
# UDR
resource "azurerm_subnet_route_table_association" "tfappvnet" {
  subnet_id            = azurerm_subnet.tfappvnet.id
  route_table_id       = azurerm_route_table.nattable.id
}

resource "azurerm_route_table" "nattable" {
  name                = "${var.resource.prefix}-natroutetable"
  location            = var.resource.location
  resource_group_name = azurerm_resource_group.tfrg.name

  route {
    name                   = "natrule1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.10"
  }
}
*/
# ASG
resource "azurerm_application_security_group" "tfwebasg" {
  name                = "tf-webasg"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
}

resource "azurerm_application_security_group" "tfjboxasg" {
  name                = "tf-jboxasg"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
}

resource "azurerm_application_security_group" "tfappasg" {
  name                = "tf-appasg"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
}
