output "vm_public_ip" {
  description = "The public IP address of the Azure virtual machine."
  value       = azurerm_public_ip.cp_azure_public_ip.ip_address
}
