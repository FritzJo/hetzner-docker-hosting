# Script configuration
The following steps describe how to change the existing script configurations to better match your requirements

## Optional changes
### terraform.tfvars
File location: [custom/terraform.tfvars](custom/terraform.tfvars)
| Variable name | Default value | Information |
|--|--|--|
|hcloud_location|nbg1|Datacenter location of the server. To see all options run ```hcloud location list``` |
|hcloud_server_type|cx21|Hardware specs of the server. Default is 2 vCPUs, 4 GB RAM, 40 GB Storage. To see all options run ```hcloud server-type list``` |

#### Example
```
hcloud_token = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
hcloud_floating_ip = "hosting-fip"
hcloud_ssh_keys = ["1230000"]

private_key = "/.ssh/private-key"
hcloud_server_type = "cx11"
```

### ansible-config.yml
File location: [custom/ansible-config.yml](custom/ansible-config.yml)
| Variable name | Default value | Information |
|--|--|--|
|GCP_Project_ID|-|Project ID for the autoated GCP backups. If this is empty, the automated backups will be disabled.|
|GCP_Bucket_Name|-|Storage bucket name for the autoated GCP backups. The provided credentials need to have the role "Storage Admin" for this bucket. If this is empty, the automated backups will be disabled.|
|GCP_Backup_Password|-|Password for the autoated GCP backups. If this is empty, the automated backups will be disabled. This value cant be changed later and has to be defined when the instance gets created!|

#### Example
```
GCP_Project_ID: "hosting-backups"
GCP_Bucket_Name: "hosting-backups-bucket"
GCP_Backup_Password: "123456"
```