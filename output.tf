output "files_endpoint" {
  value = trimsuffix(trimprefix(azurerm_storage_account.main.primary_file_endpoint, "https://"), "/")
}

output "primary_access_key" {
  value     = azurerm_storage_account.main.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value     = azurerm_storage_account.main.secondary_access_key
  sensitive = true
}

output "primary_connection_string" {
  value = azurerm_storage_account.main.primary_connection_string
}

output "secondary_connection_string" {
  value = azurerm_storage_account.main.secondary_connection_string
}