# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry

resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}cr"
  resource_group_name      = var.dce-rg-name
  location                 = var.dce-rg-location
  sku                      = "Basic"
  admin_enabled            = true

  tags = {
      "app" = "commercial"
  }
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
}