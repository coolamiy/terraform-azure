provider "azurerm" {
  features {}

}

resource "azurerm_resource_group" "amitvm" {
  name     = "example-resources"
  location = "East US"
}
module "linuxservers" {
  source                        = "Azure/compute/azurerm"
  resource_group_name           = azurerm_resource_group.amitvm.name
  vm_hostname                   = "amitlinuxvm"
  nb_public_ip                  = 2
  remote_port                   = "22"
  nb_instances                  = 2
  vm_os_publisher               = "Canonical"
  vm_os_offer                   = "UbuntuServer"
  vm_os_sku                     = "18.04-LTS"
  vnet_subnet_id                = module.network.vnet_subnets[0]
  boot_diagnostics              = false
  delete_os_disk_on_termination = true
  nb_data_disk                  = 0
  data_disk_size_gb             = 64
  data_sa_type                  = "Premium_LRS"
  enable_ssh_key                = true
  ssh_key                       = "authorized_keys"
  vm_size                       = "Standard_B1ls"
  admin_username                = "azureadmin"
  admin_password                = "Test1234!!"
  public_ip_dns                 = ["amitlinuxvm-1", "amitlinuxvm-2"]
  tags = {
    environment = "dev"
  }

  enable_accelerated_networking = false
}
module "network" {
  source              = "Azure/network/azurerm"
  version             = "3.0.1"
  resource_group_name = azurerm_resource_group.amitvm.name
  subnet_prefixes     = ["10.0.1.0/24"]

}

output "linux_vm_private_ips" {
  value = module.linuxservers.network_interface_private_ip
}

output "linux_vm_public_dns" {
  value = module.linuxservers.public_ip_dns_name
}

output "Linux_vm_public_ip_addresses" {
  value = module.linuxservers.public_ip_address
}

output "linux_vm_public_id" {
  value = module.linuxservers.public_ip_id
}
