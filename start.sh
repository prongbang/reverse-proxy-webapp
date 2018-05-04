#!/bin/bash

if [ ! "$(docker network ls | grep nginx-proxy)" ]; then
    echo "Creating nginx-proxy-network network ..."
    docker network create nginx-proxy-network
else
    echo "nginx-proxy-network network exists."
fi

# run nginx-proxy container
if [ ! "$(docker ps | grep nginx-proxy)" ]; then
    if [ "$(docker ps -aq -f name=nginx-proxy)" ]; then
        echo "Cleaning Nginx Proxy ..."
        docker rm nginx-proxy
    fi
    echo "Running Nginx Proxy in global nginx-proxy network ..."
    docker-compose -f ./proxy/docker-compose.yml up -d
else
    echo "Nginx Proxy already running."
fi

# down container
docker-compose down

# run web container 
docker-compose up --build -d
