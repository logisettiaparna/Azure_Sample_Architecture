# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub

resource "azurerm_eventhub_namespace" "event_hub" {
  name                = "${var.prefix}-event-hub-namespace"
  location            = var.dce-rg-location
  resource_group_name = var.dce-rg-name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    "app" = "commercial"
  }
}

resource "azurerm_eventhub" "ingress" {
  name                = "ingress"
  namespace_name      = azurerm_eventhub_namespace.event_hub.name
  resource_group_name = var.dce-rg-name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub" "egress" {
  name                = "egress"
  namespace_name      = azurerm_eventhub_namespace.event_hub.name
  resource_group_name = var.dce-rg-name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub" "process" {
  name                = "process"
  namespace_name      = azurerm_eventhub_namespace.event_hub.name
  resource_group_name = var.dce-rg-name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub" "aggregate" {
  name                = "aggregate"
  namespace_name      = azurerm_eventhub_namespace.event_hub.name
  resource_group_name = var.dce-rg-name
  partition_count     = 1
  message_retention   = 1
}

output "event_hub_namespace_name" {
  value = azurerm_eventhub_namespace.event_hub.name
}

output "event_hub_namespace_primary_key" {
  value = azurerm_eventhub_namespace.event_hub.default_primary_key
}

output "event_hub_primary_connection_string" {
  value = azurerm_eventhub_namespace.event_hub.default_primary_connection_string
}
