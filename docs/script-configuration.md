# Script configuration
The following steps describe how to change the existing script configurations to better match your requirements

## Optional changes
### terraform.tfvars
File location: [custom/terraform.tfvars.example](../custom/terraform.tfvars.example),  copy to `custom/terraform.tfvars`

| Variable name | Default value | Information |
|--|--|--|
|hcloud_location|nbg1|Datacenter location of the server. To see all options run ```hcloud location list``` |
|hcloud_server_type|cx21|Hardware specs of the server. Default is 2 vCPUs, 4 GB RAM, 40 GB Storage. To see all options run ```hcloud server-type list``` |
|hcloud_server_name|hosting-vps|Name of the Hetzner VM created via this script. |
|hcloud_server_image|debian-13|OS image used during deployment. |

#### Example
```
hcloud_token = "YOUR_HCLOUD_TOKEN"
hcloud_floating_ip = "hosting-fip"

hcloud_server_type = "cx11"
hcloud_server_name = "my-docker-vm"
hcloud_server_image = "debian-13"
```

### ansible-config.yml
File location: [custom/ansible-config.yml.example](../custom/ansible-config.yml.example), copy to `custom/ansible-config.yml`

| Variable name | Default value | Information |
|--|--|--|
|hosting_domain|example.org|Domain used for automated SSL. |
|user_name|hetzner-user|Name of the non-root sudo user. |
|GCP_Project_ID|-|Project ID for the automated GCP backups. If empty, backups are disabled. |
|GCP_Bucket_Name|-|Storage bucket name. If empty, backups are disabled. |

**Secrets** (`user_password`, `GCP_Backup_Password`) are **no longer** kept here. They live in `custom/secrets/vault.yml` (see [vault.yml.example](../custom/secrets/vault.yml.example)). For stronger protection, encrypt that file with:

```bash
ansible-vault encrypt custom/secrets/vault.yml
```

and run `hosting.sh` with `ANSIBLE_VAULT_PASSWORD_FILE` pointing at a file containing the vault password.

#### Example (non-secret values only)
```
hosting_domain: "example.org"
user_name: hetzner-user
GCP_Project_ID: "hosting-backups"
GCP_Bucket_Name: "hosting-backups-bucket"
```

#### vault.yml (secrets — do NOT commit)
```
user_password: "a-long-random-password"
GCP_Backup_Password: "another-long-random-password"
```
