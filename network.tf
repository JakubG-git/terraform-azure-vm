# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "kubeVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "kubeSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Kube_ports"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["6443", "2379-2380", "10250", "10251", "10252", "30000-32767"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_public_ip" "first_vm_ip" {
  name                = "firstVmIp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}


resource "azurerm_public_ip" "second_vm_ip" {
  name                = "secondVmIp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "third_vm_ip" {
  name                = "thirdVmIp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}


# Create network interface
resource "azurerm_network_interface" "first_vm_nic" {
  name                = "firstVmNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "fistVmNicConf"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.first_vm_ip.id
  }
}

# Create network interface
resource "azurerm_network_interface" "second_vm_nic" {
  name                = "secondVmNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "seconfVmNicConf"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.second_vm_ip.id
  }
}
# Create network interface
resource "azurerm_network_interface" "third_vm_nic" {
  name                = "thirdVmNic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "thirdVmNicConf"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.third_vm_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "firstVm" {
  network_interface_id      = azurerm_network_interface.first_vm_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "secondVm" {
  network_interface_id      = azurerm_network_interface.second_vm_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "thirdVm" {
  network_interface_id      = azurerm_network_interface.third_vm_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}