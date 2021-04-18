# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database


resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.prefix}-cosmos-db"
  location            = var.dce-rg-location
  resource_group_name = var.dce-rg-name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = var.dce-rg-location
    failover_priority = 0
  }

  tags = {
    "app" = "commercial"
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "audit"
  resource_group_name = azurerm_cosmosdb_account.db.resource_group_name
  account_name        = azurerm_cosmosdb_account.db.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "table" {
  name                  = "requests"
  resource_group_name   = azurerm_cosmosdb_account.db.resource_group_name
  account_name          = azurerm_cosmosdb_account.db.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = "/cid"
  partition_key_version = 1
  throughput            = 400
}
