# Create virtual machine
resource "azurerm_linux_virtual_machine" "first_vm" {
  name                  = "firstVm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.first_vm_nic.id]
  size                  = "Standard_E2s_v3"

  os_disk {
    name                 = "myOsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "cp-vm1"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  

}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "second_vm" {
  name                  = "secondVm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.second_vm_nic.id]
  size                  = "Standard_B2ms"

  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "worker-vm2"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "third_vm" {
  name                  = "thirdVm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.third_vm_nic.id]
  size                  = "Standard_B2ms"

  os_disk {
    name                 = "myOsDisk3"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "worker-vm3"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

}


resource "azurerm_virtual_machine_extension" "cp" {
  name = "cp-scrpit"
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id = azurerm_linux_virtual_machine.first_vm.id

  protected_settings  = <<PROT
    {
        "script": "${base64encode(file(var.base_script))}"
    }
    PROT

}

resource "azurerm_virtual_machine_extension" "worker1" {
  name = "worker1-scrpit"
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id = azurerm_linux_virtual_machine.second_vm.id

  protected_settings  = <<PROT
    {
        "script": "${base64encode(file(var.base_script))}"
    }
    PROT

}


resource "azurerm_virtual_machine_extension" "worker2" {
  name = "worker2-scrpit"
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id = azurerm_linux_virtual_machine.third_vm.id

  protected_settings  = <<PROT
    {
        "script": "${base64encode(file(var.base_script))}"
    }
    PROT

}