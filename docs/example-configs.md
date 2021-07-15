# Example Services
Most Applications that support Docker deployments will also offer the option to use docker-compose. Check their documentation for more details. 

There are some extra options you need to configure to make it work with this setup, but the required changes should be clear if you follow the examples in this repository.

To actually start the new instance, please run update-vps.sh again.

## How to use these examples
If you place the example docker-compose files in a new folder of the /hosting/instances directory it will deploy the service and generate a valid SSL certificate for the domain dev.example.com.

You have to update the file to match your own domain and change the default passwords.

## List of examples
| Name | File | Notes |
|--|--|--|
|Wordpress|[wordpress-docker-compose.yml](https://github.com/FritzJo/hetzner-docker-hosting/blob/master/docs/examples/wordpress-docker-compose.yml)||
|Nginx Webserver|[nginx-docker-compose.yml](https://github.com/FritzJo/hetzner-docker-hosting/blob/master/docs/examples/nginx-docker-compose.yml)||

## How to adapt you own docker-compose files
Basic steps:
* Add 3 environment variables:
    * LETSENCRYPT_HOST -> The domain for you new service (e.g. dev.example.com)
    * VIRTUAL_HOST -> The domain for you new service (e.g. dev.example.com)
    * VIRTUAL_PORT -> Default port of the service (80 for Nginx, 8080 for Tomcat, ...) 
* Add the proxy network for the container that has to be accessible from the internet
* Add the network at the bottom of the docker-compose file
