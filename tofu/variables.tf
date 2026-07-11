variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "hcloud_floating_ip" {
  description = "Name of an existing Hetzner Cloud floating IP to assign to the server (required if floating_ip is true)"
  type        = string
  default     = null
}

variable "hcloud_location" {
  description = "Hetzner Cloud datacenter location"
  type        = string
  default     = "nbg1"
}

variable "hcloud_server_type" {
  description = "Hetzner Cloud server type (e.g. cx21, cx31, cax21 for ARM)"
  type        = string
  default     = "cx21"
}

variable "hcloud_server_name" {
  description = "Hostname of the created server"
  type        = string
  default     = "hosting-vps"
}

variable "hcloud_server_image" {
  description = "OS image for the server (e.g. debian-13, ubuntu-24.04)"
  type        = string
  default     = "debian-13"
}

variable "floating_ip" {
  description = "Whether to assign a floating IP to the server"
  type        = bool
  default     = false
}

variable "ssh_source_ips" {
  description = "IP ranges allowed to connect via SSH (e.g. [\"203.0.113.0/24\"]). Defaults to 0.0.0.0/0 if unset — a warning is shown during apply."
  type        = list(string)
  default     = null
}

variable "firewall_additional_rules" {
  description = "Additional firewall rules to apply to the server"
  type = list(object({
    direction  = string
    protocol   = string
    port       = string
    source_ips = list(string)
  }))
  default = []
}

