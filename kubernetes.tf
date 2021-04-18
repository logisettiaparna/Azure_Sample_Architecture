# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks1"
  location            = var.dce-rg-location
  resource_group_name = var.dce-rg-name
  dns_prefix          = "${var.prefix}-aks1-dns"
  kubernetes_version  = "1.19.6"

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 4
    os_disk_size_gb     = 30
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "app" = "commercial"
  }
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
