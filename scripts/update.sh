#!/bin/bash

# Configuration
DEPLOYMENT_ROOT="/hosting/instances"

# Update system
apt-get update 
apt-get upgrade -y
apt-get autoremove -y

# Update container
cd $DEPLOYMENT_ROOT || exit 1
for dir in */
do
    dir=${dir%*/}
    if [ "$dir" = "*" ]; then
      echo "No instances found!"
      exit 0
    fi

    echo "Updating: $dir"
    cd "$dir" || exit 1

    # Do stuff
    docker-compose down || exit 1
    docker-compose pull || exit 1
    docker-compose up -d || exit 1

    cd $DEPLOYMENT_ROOT || exit 1
done

echo "Cleaning up old Docker images"
docker image prune -a || exit 1

echo "Done! Consider rebooting the system"
