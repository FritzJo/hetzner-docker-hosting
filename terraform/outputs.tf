output "ephemeral-ip" {
  value = "${hcloud_server.wordpress-vps.ipv4_address}"
}