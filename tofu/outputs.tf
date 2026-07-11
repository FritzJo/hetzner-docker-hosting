output "ephemeral-ip" {
  value = "${hcloud_server.hosting-vps.ipv4_address}"
}