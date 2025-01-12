#!/bin/bash
docker pull nginx
docker run -p 81:81 -d nginx
dockerId=$(docker ps -q)
# read -p "Enter docker container ID: " dockerId


docker cp  ./nginx/nginx.conf $dockerId:/etc/nginx/nginx.conf
docker cp hello.c $dockerId:/home/

docker exec $dockerId apt-get update
docker exec $dockerId apt-get install -y gcc spawn-fcgi libfcgi-dev
docker exec $dockerId rm -rf /var/lib/apt/lists/*
docker exec $dockerId service nginx reload
docker exec $dockerId gcc -o home/hello home/hello.c -lfcgi -Wall -Werror -Wextra
docker exec -d $dockerId spawn-fcgi -p 8080 -n ./home/hello
sleep 2
curl localhost:81
curl localhost:81/status