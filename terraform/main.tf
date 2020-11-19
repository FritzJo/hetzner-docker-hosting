# Data
data "hcloud_floating_ip" "floating-ip" {
  name=var.hcloud_floating_ip
}

data "hcloud_ssh_keys" "all_keys" {

}
# Create a server
resource "hcloud_server" "wordpress-vps" {
  name = "wordpress-vps"
  image = "debian-10"
  location = var.hcloud_location
  server_type = var.hcloud_server_type
  keep_disk = true
  #ssh_keys =  var.hcloud_ssh_keys
  ssh_keys = data.hcloud_ssh_keys.all_keys.ssh_keys.*.id

  # Software deployments
  provisioner "local-exec" {
	  command = <<EOT
      sleep 30;
	    >wordpress-instances.ini;
	    echo "[wordpress]" | tee -a wordpress-instances.ini;
	    echo "${hcloud_server.wordpress-vps.ipv4_address} ansible_user=root ansible_ssh_private_key_file=${var.private_key} floating_ip=${data.hcloud_floating_ip.floating-ip.ip_address}" | tee -a wordpress-instances.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	    ansible-playbook -u root --private-key ${var.private_key} -i wordpress-instances.ini ../ansible/playbook-docker.yaml
      ansible-playbook -u root --private-key ${var.private_key} -i wordpress-instances.ini ../ansible/playbook-hosting.yaml
      EOT
  }
}

resource "hcloud_floating_ip_assignment" "wordpress-ip" {
  floating_ip_id = data.hcloud_floating_ip.floating-ip.id
  server_id = hcloud_server.wordpress-vps.id
}


