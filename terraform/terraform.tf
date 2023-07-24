terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.42.0"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}