# App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "frogtech-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            =  "S1"
}



# Private Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "frogtech-private-webapp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}

  https_only = true
  public_network_access_enabled = false
}




# Private DNS
resource "azurerm_private_dns_zone" "webapp_dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke_dns_link" {
  name                  = "spoke-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.webapp_dns.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub_dns_link" {
  name                  = "hub-dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.webapp_dns.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  resource_group_name   = azurerm_resource_group.rg.name
  registration_enabled  = false
}
resource "azurerm_private_endpoint" "webapp_pe" {
  name                = "webapp-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.spoke_private.id

  private_service_connection {
    name                           = "webapp-priv-conn"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "webapp-dns-zone-group"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.webapp_dns.id
    ]
  }
}

