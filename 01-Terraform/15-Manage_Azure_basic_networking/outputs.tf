output "webapp_default_hostname" {
  description = "The hostname of the private Web App"
  value       = azurerm_linux_web_app.webapp.default_hostname
}

output "vm_public_ip" {
  description = "Public IP of the Hub VM"
  value       = azurerm_public_ip.vm_ip.ip_address
}
