#!/usr/bin/env bash


sudo apt-get update -y

sudo apt-get install -y nano




apt-get install -y apt-utils apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update -y
apt-get install -y docker-ce containerd.io docker-compose-plugin

sudo groupadd -f docker
sudo usermod -aG docker ubuntu
#newgrp docker
id -nG




sudo add-apt-repository -y ppa:ondrej/nginx
sudo apt-get install -y -q nginx



echo "
version: '3.3'

services:

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     volumes:
       - ./wp:/var/www/html:rw
     networks:
          - wp
     ports:
       - "8080:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress

   db:
     image: mysql:8.0
     networks:
          - wp
     volumes:
       -  ./db:/var/lib/mysql:rw
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: root
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress
networks:
    wp:


" > docker-compose.yml



sudo echo "

server {
    listen 80;
    listen [::]:80;
    server_name dev-1.site www.dev-1.site;

location / {
        proxy_pass http://dev-1.site:8080;

        proxy_set_header Host $http_host;
        server_name_in_redirect off;
        proxy_redirect off;
        rewrite ^([^.]*[^/])$ http://dev-1.site:8080$1/ permanent;   #This will add trailing /
    }
}

" > /etc/nginx/sites-enabled/default







docker compose up -d

sudo service nginx start

sudo systemctl enable docker

sudo systemctl enable nginx
