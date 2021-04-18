# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app

resource "azurerm_storage_account" "function_sa" {
  name                     = "${var.prefix}storageaccount"
  resource_group_name      = var.dce-rg-name
  location                 = var.dce-rg-location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    "app" = "commercial"
  }
}

resource "azurerm_app_service_plan" "function_sp" {
  name                = "${var.prefix}-app-service-plan"
  location            = var.dce-rg-location
  resource_group_name = var.dce-rg-name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    "app" = "commercial"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "${var.prefix}-function-app"
  location                   = var.dce-rg-location
  resource_group_name        = var.dce-rg-name
  app_service_plan_id        = azurerm_app_service_plan.function_sp.id
  storage_account_name       = azurerm_storage_account.function_sa.name
  storage_account_access_key = azurerm_storage_account.function_sa.primary_access_key
  https_only                 = true
  version                    = "~3"
  os_type                    = "linux"

  site_config {
    linux_fx_version          = "PYTHON|3.8"
    use_32_bit_worker_process = false
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "EventHubConnectionString"      = azurerm_eventhub_namespace.event_hub.default_primary_connection_string
    "AzureCosmosDBConnectionString" = azurerm_cosmosdb_account.db.connection_strings.0
  }

  tags = {
    "app" = "commercial"
  }
}
