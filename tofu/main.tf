data "hcloud_floating_ip" "floating-ip" {
  count = var.floating_ip ? 1 : 0
  name  = var.hcloud_floating_ip
}

data "hcloud_ssh_keys" "all_keys" {
}

resource "hcloud_server" "hosting-vps" {
  name        = var.hcloud_server_name
  image       = var.hcloud_server_image
  location    = var.hcloud_location
  server_type = var.hcloud_server_type
  keep_disk   = true
  ssh_keys    = data.hcloud_ssh_keys.all_keys.ssh_keys[*].id

  lifecycle {
    prevent_destroy = true
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 30
      >../custom/hosting-instances.ini
      echo "[hosting-vps]" | tee -a ../custom/hosting-instances.ini
      echo "${self.ipv4_address}" | tee -a ../custom/hosting-instances.ini
      echo "[hosting-vps:vars]" | tee -a ../custom/hosting-instances.ini
      echo "floating_ip=${var.floating_ip ? data.hcloud_floating_ip.floating-ip[0].ip_address : ""}" | tee -a ../custom/hosting-instances.ini
      cd ../ansible || exit 1
      ansible-playbook master.yaml
    EOT
  }
}

resource "hcloud_floating_ip_assignment" "hosting-ip" {
  count          = var.floating_ip ? 1 : 0
  floating_ip_id = data.hcloud_floating_ip.floating-ip[0].id
  server_id      = hcloud_server.hosting-vps.id
}

