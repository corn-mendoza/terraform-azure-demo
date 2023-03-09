terraform {
  cloud {
    organization = "visland-software"
    workspaces {
      name = "visland-software"
    }
  }
  required_version = ">=1.1.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.46.0"
    }
  }
}
