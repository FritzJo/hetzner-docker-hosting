# Hetzner Docker Hosting
**Please keep in mind, that this is a WIP project. Don't use these scripts in production!**

## What is this?
This repository contains scripts and templates for infrastructure automation that will create a Hetzner Cloud VM that is ready to run Docker containers, while keeping maintenance as low as possible. This means that the defaults aren't really "production safe", but good enough for some self-hosted services. Updates for example get automaticly installed and the machine reboots itself to apply kernel updates, which obviously causes a downtime. 

But its perfect for services you dont really want to pay attention to!

## Features
* Automated updates (OS and Docker images)
* Automated backups to Google Cloud Storage)
* Letsencrypt SSL Proxy for all Docker services ([jwilder-nginx-proxy](https://github.com/nginx-proxy/nginx-proxy))
* Deployment of new docker-compose files via Ansible
* Some Web UI Management Tools


## Setup
### Requirements
* [HCloud CLI](https://github.com/hetznercloud/cli/releases)
* [Terraform](https://www.terraform.io/downloads.html)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Pre-Deployment
1. Prepare your Hetzner environment
    1. Create an SSH key and add it to your Hetzner project
    2. Create an floating IP, if you don't want to use this, comment out the last 5 lines in [main.tf](terraform/main.tf)
2. Create terraform.tfvars in the [terraform directory](terraform/) (An example is shown below)
3. (optional) Add additional variable configurations to terraform.tfvars, if you want to change the instance locatio, size or operating system. To see all supported options, look at [variables.tf](terraform/variables.tf)
4. (optional) Edit the [ansible-config.yml](ansible-config.yml) in the root directory. This file contains the credentials for the automated backup to a GCP Storage bucket.
5. Initialize Terraform and all plugins by running [setup.sh](setup.sh)

### Deployment
Run the script in the root directory. If everything was configured correctly this will create the VM and install everything.
```
./setup-vps.sh
```
After that you can login via SSH with any key that is added to your Hetzner account

### Automation
The hosting environment created by these scripts automaticly installs various automation scripts which make it easier for you to manage your services.
#### Default Services
| Service | Description | URL/Port|
|--|--|--|
| Portainer | Manage Docker containers and view logs. | :9000 |
| Filebrowser | Web-based file browser which also can edit files/configs | :9001 |
| PHPMyAdmin | Manage databases with a web interface (Currently WIP) | :9002 |

#### Default scripts
| Script | Description |
|--|--|
| Update | The VM will update itself and all containers in /hosting/instances on reboot. This is also used to start each service after a reboot. |
| Backup | Automated backups to GCP Storage. For more information (like how to change the repo password check the official [documentation](https://restic.readthedocs.io/en/latest/070_encryption.html)|
| Reboot | The VM will restart every Sunday at 3:30AM. This will cause a short downtime. |
### Example configuration
#### terraform.tfvars
```
hcloud_token = ""
hcloud_floating_ip = "" # Name of FIP
private_key = "/path"
```
#### ansible-config.yml
```
GCP_Project_ID: "123456789"
GCP_Bucket_Name: "example-bucket"
GCP_Backup_Password: "123456789"
```

#### Example wordpress service
If you place this file with the name docker-compose.yml in a new folder of the /hosting/instances directory it will create a new Wordpress instance and a SSL certificate for the domain dev.example.com.
**Make sure to change the database password before you use this in production!**

To actually start the new instance, please run update-vps.sh again.
```
version: '2'

services:
  db:
    image: mysql:5.7
    volumes:
      - ./db_data:/var/lib/mysql
    command: '--default-authentication-plugin=mysql_native_password'
    networks:
      - wp
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    networks:
      - proxy
      - wp
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      LETSENCRYPT_HOST: dev.example.com
      VIRTUAL_HOST: dev.example.com
      VIRTUAL_PORT: 8000

networks:
  wp:
  proxy:
    external: true
```
## Folder structure on the remote machine
| Network name | Description |
|--|--|
|Root| /hosting|
|Docker configurations| /hosting/instances|
|Management and scripts| /hosting/scripts|
| Secrets| /hosting/secrets|

## Container Networks
| Network name | Description |
|--|--|
| proxy | Required for each container that has to be available to the internet |
| dbadmin | For connection with PHPMyAdmin, required for MySQL database containers |
