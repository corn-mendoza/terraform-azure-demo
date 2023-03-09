provider "azurerm" {
  features {    
  }

}

resource "azurerm_resource_group" "azurerg" {
  name     = "terraform-demo-rg"
  location = "centralus"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.azurerg.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["islandterraformlinux"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  remote_port         = "22"
  ssh_key             = "t-az-demo.pub"

  depends_on = [azurerm_resource_group.azurerg]
}

module "windowsservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.azurerg.name
  is_windows_image    = true
  vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["islandterraformwin"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  remote_port         = "3389"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true
  depends_on = [azurerm_resource_group.azurerg]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.azurerg.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
  use_for_each = true 
  depends_on = [azurerm_resource_group.azurerg]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}

output "windows_vm_public_name" {
  value = module.windowsservers.public_ip_dns_name
}
