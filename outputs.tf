output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "cp_ip_address" {
  value = azurerm_linux_virtual_machine.first_vm.public_ip_address
}

output "worker1_ip_address" {
  value = azurerm_linux_virtual_machine.second_vm.public_ip_address
}

output "worker2_ip_address" {
  value = azurerm_linux_virtual_machine.third_vm.public_ip_address
}
