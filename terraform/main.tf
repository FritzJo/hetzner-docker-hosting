terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.22.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {}
variable "hcloud_floating_ip" {}
variable "hcloud_ssh_keys" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Create a server
resource "hcloud_server" "wordpress-vps" {
  name = "wordpress-vps"
  image = "debian-10"
  location = "nbg1"
  server_type = "cx21"
  keep_disk = true
  ssh_keys =  var.hcloud_ssh_keys
}

resource "hcloud_floating_ip_assignment" "wordpress-ip" {
  floating_ip_id = var.hcloud_floating_ip
  server_id = "${hcloud_server.wordpress-vps.id}"
}

output "temp_ip" {
  value = "${hcloud_server.wordpress-vps.ipv4_address}"
}

