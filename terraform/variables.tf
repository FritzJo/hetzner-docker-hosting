variable "hcloud_token" {}
variable "hcloud_floating_ip" {}

variable "hcloud_location" {
  default = "nbg1"
}

variable "hcloud_server_type" {
  default = "cx21"
}

variable "hcloud_server_name" {
  default = "hosting-vps"
}

variable "floating_ip" {
  default = true
  type = bool
}

