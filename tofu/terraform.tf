terraform {
  required_version = ">= 1.5, < 2.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49"
    }
  }

  backend "local" {
    path = "../custom/terraform.tfstate"
  }
}

provider "hcloud" {
  token = var.hcloud_token
}