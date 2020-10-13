# Wordpress Hosting
## Folder structure
* Root: /hosting
* Wordpress: /hosting/instances
* Management and scripts: /hosting/scripts
* Secrets: /hosting/secrets

## terraform.tfvars example
```
hcloud_token = ""
hcloud_floating_ip = ""
hcloud_ssh_keys = [""]
private_key = "/path"
```