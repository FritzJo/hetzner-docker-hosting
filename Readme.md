# Hetzner Docker Hosting

  * [What is this?](#what-is-this-)
  * [Features](#features)
  * [Setup](#setup)
    + [Requirements](#requirements)
    + [Pre-Deployment](#pre-deployment)
    + [Deployment](#deployment)
    + [Post-Deployment](#post-deployment)
    + [Automation](#automation)
      - [Default Services](#default-services)
      - [Default scripts](#default-scripts)
  * [Examples](#examples)
    + [Configuration](#configuration)
    + [Services](#services)
  * [Folder structure on the remote machine](#folder-structure-on-the-remote-machine)
  * [Container Networks](#container-networks)
  * [Roadmap](#roadmap)


## What is this?
This repository contains scripts and templates for infrastructure automation that will create a Hetzner Cloud VM that is ready to run Docker containers, while keeping maintenance as low as possible. This means that the defaults aren't really "production safe", but good enough for some self-hosted services. Updates for example get automaticly installed and the machine reboots itself to apply kernel updates, which obviously causes a downtime. 

But its perfect for services you dont really want to pay attention to!

In addition to the core scripts for deploying and managing Docker environments, the code is extensible with custom ansible files for more flexible setups.

## Features
* Automated updates (OS and Docker images)
* Automated backups to Google Cloud Storage
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
    2. ~~Create an floating IP, if you don't want to use this, comment out the last 5 lines in [main.tf](terraform/main.tf)~~
2. Create terraform.tfvars in the [custom directory](custom/) directory. (An example is shown [here](docs/script-configuration.md))
3. Initialize Terraform and all plugins by running
```
./hosting.sh setup
```
4. Configure your VM details in the custom directory (ansible-config.yml in [custom/](custom/ansible-config.yml)) directory.
4. Find out how to configure your DNS records. This is dependend on your domain registrar and will be needed later

### Deployment
Run the script in the root directory. If everything was configured correctly this will create the VM and install everything.
```
./hosting.sh create
```
After that you can login via SSH with any key that is added to your Hetzner account

### Post-Deployment
If you can access the Portainer management interface at ```http://<Your-Servers-IP>:9000``` the deployment was successful.
Alternatively, if you configured a domain in your ansible configuration file your Portainer interface is also acessible via 
[https://docker.<Your-Domain.tld>](#). To make this work you need to setup the correct DNS configuration. In most cases it is enough to create a single wildcard record that directs all subdomains to your new Hetzner IP.

How to manage your new server is documented [here](docs/maintenance.md)

For specific details on how to use Portainer, check the [official documentaion](https://docs.portainer.io/)
### Automation
The hosting environment created by these scripts automaticly installs various automation scripts which make it easier for you to manage your services.

#### Default Services
| Service | Description | URL/Port|
|--|--|--|
| Portainer | Manage Docker containers and view logs. | :9000, or ```https://docker.<Your-Domain>```|

#### Default scripts
| Script | Description |
|--|--|
| Update | The VM will update itself and all containers in /hosting/instances on reboot. This is also used to start each service after a reboot. |
| Backup | Automated backups to GCP Storage. For more information (like how to change the repo password check the official [documentation](https://restic.readthedocs.io/en/latest/070_encryption.html))|
| Reboot | The VM will restart every Sunday at 3:30AM. This will cause a short downtime. |

## Examples
### Configuration
Check the [script documentation](docs/script-configuration.md) for detailed examples
### Services
Check the [example documentation](docs/example-configs.md) for detailed examples

## Folder structure on the remote machine
| Usage | Path |
|--|--|
|Root| /hosting|
| Docker configurations | /hosting/instances |
| Management and scripts | /hosting/scripts |
| Secrets | /hosting/secrets |

## Container Networks
| Network name | Description |
|--|--|
| proxy | Required for each container that has to be available to the internet |

## How to manage your custom configuration
All custom configuration, your docker-compose files and all secrets are placed inside the [custom](custom/) directory. 

If you want to use git to manage your files, follow these steps:
``` bash
git subtree split -P custom -b <name-of-new-branch>

# Create a new git repository
mkdir ~/<new-repo> && cd ~/<new-repo>
git init
git pull </path/to/hetzner-docker-hosting> <name-of-new-branch>

# Add a remote for the new repo
git remote add origin <git@github.com:user/new-repo.git>
git push -u origin master

# Symlink new folder to the custom folder
ln -s </path/to/new/repo </path/to/hetzner-docker-hosting/custom>
```

## Roadmap
The roadmap and upcoming features are documented as issues in this repository. This is also the correct way to request new features or additional documentation.

# FAQ
## 1. I updated my scripts and now the ansible instance update fails
```"Could not find or access '../custom/secrets/gcp-secret.json'``` is an error that occurs, because the location of the secret file got moved to the custom directory. Just copy (or move) your ```secrets``` folder into your existing ```custom``` directory.

## 2. Are ARM VMs also supported?
Yes! Simply change the ```terraform.tfvars``` in the ```custom``` directory to the desired ARM server type and adapt your Dockerfiles accordingly.