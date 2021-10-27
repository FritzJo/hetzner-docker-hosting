terraform {
  backend "local" {
    path = "../custom/terraform.tfstate"
  }
}


# Data
data "hcloud_floating_ip" "floating-ip" {
  name=var.hcloud_floating_ip
}

data "hcloud_ssh_keys" "all_keys" {

}
# Create a server
resource "hcloud_server" "hosting-vps" {
  name = "hosting-vps"
  image = "debian-10"
  location = var.hcloud_location
  server_type = var.hcloud_server_type
  keep_disk = true
  ssh_keys = data.hcloud_ssh_keys.all_keys.ssh_keys.*.id

  # Software deployments
  provisioner "local-exec" {
	  command = <<EOT
      sleep 30;
	    >hosting-instances.ini;
	    echo "[hosting-vps]" | tee -a ../custom/hosting-instances.ini;
	    echo "${hcloud_server.hosting-vps.ipv4_address} floating_ip=${data.hcloud_floating_ip.floating-ip.ip_address}" | tee -a ../custom/hosting-instances.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	    ansible-playbook ../ansible/master.yaml
      EOT
  }
}

resource "hcloud_floating_ip_assignment" "hosting-ip" {
  floating_ip_id = data.hcloud_floating_ip.floating-ip.id
  server_id = hcloud_server.hosting-vps.id
}


