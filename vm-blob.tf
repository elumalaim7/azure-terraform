resource "azurerm_storage_account" "tfblob" {
  name                     = "${var.resource.prefix}blobacct"
  resource_group_name      = azurerm_resource_group.tfrg.name
  location                 = var.resource.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.resource.tag
  }
}

resource "azurerm_storage_container" "tfblob" {
  name                  = "docs"
  storage_account_name  = azurerm_storage_account.tfblob.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "tfblob" {
  name = "hello.txt"

  storage_account_name   = azurerm_storage_account.tfblob.name
  storage_container_name = azurerm_storage_container.tfblob.name

  type   = "Block"
  source = "./blob/hello.txt"
}