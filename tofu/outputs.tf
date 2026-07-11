output "ephemeral-ip" {
  description = "IPv4 address of the created server"
  value       = hcloud_server.hosting-vps.ipv4_address
}

output "ansible_inventory" {
  description = "Ansible inventory INI content"
  value = templatefile("${path.module}/inventory.tftpl", {
    ip          = hcloud_server.hosting-vps.ipv4_address
    floating_ip = var.floating_ip ? data.hcloud_floating_ip.floating-ip[0].ip_address : ""
  })
}