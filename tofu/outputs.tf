output "ephemeral-ip" {
  description = "IPv4 address of the created server"
  value       = hcloud_server.hosting-vps.ipv4_address
  value       = hcloud_server.hosting-vps.ipv6_address
}