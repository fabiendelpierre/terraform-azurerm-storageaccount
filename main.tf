resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.base_name}sa${random_string.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
  min_tls_version          = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      queue_properties,
      resource_group_name,
      location,
      account_tier,
      account_kind,
      is_hns_enabled
    ]
  }

  tags = var.tags
}

resource "azurerm_storage_account_network_rules" "main" {
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_name = azurerm_storage_account.main.name

  default_action             = var.network_acl_default_action
  ip_rules                   = var.network_acl_default_action == "Deny" ? var.authorized_cidrs : []
  virtual_network_subnet_ids = var.network_acl_default_action == "Deny" ? var.authorized_subnet_ids : []
  bypass                     = var.network_acl_bypass
}

resource "azurerm_storage_container" "main" {
  name                 = "${var.base_name}-vault-snapshots"
  storage_account_name = azurerm_storage_account.main.name

  metadata = var.tags
}