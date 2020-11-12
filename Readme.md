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

## Container Networks
| Network name | Description |
|--|--|
| proxy | Required for each container that has to be available to the internet |
| dbadmin | For connection with PHPMyAdmin, required for MySQL database containers |
