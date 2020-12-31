variable "hcloud_token" {}
variable "hcloud_floating_ip" {}

variable "private_key" {} 

variable "hcloud_location" {
  default = "nbg1"
}

variable "hcloud_server_type" {
  default = "cx21"
}
