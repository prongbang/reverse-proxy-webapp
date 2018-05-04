# Create Network

```
$ docker network create nginx-proxy
```

# Create Container
```
$ docker run -d \
  --name reverse-proxy \
  -p 80:80 \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  --net nginx-proxy-network jwilder/nginx-proxy:alpine
```

# nginx config for websites
> nginx-blog.conf
```nginx
worker_processes  1;

events {
  worker_connections  1024;
}

http {
  include /etc/nginx/mime.types;

  server {
    listen 80;
    server_name localhost;
    
    root /var/www/html/web;
    index index.html;
  }
}
```
> nginx-profile.conf
```nginx
worker_processes  1;

events {
  worker_connections  1024;
}

http {
  include /etc/nginx/mime.types;

  server {
    listen 80;
    server_name localhost;
    
    root /var/www/html/web;
    index index.html;
  }
}
```

# website containers
> docker-compose.yml
```yml
version: '2'
services:
  blog:
    image: nginx:1.13.0-alpine
    container_name: blog
    expose:
      - 80
    volumes:
      - ./web/blog:/var/www/html/web
      - ./nginx/nginx-blog.conf:/etc/nginx/nginx.conf
    environment:
      VIRTUAL_HOST: 'blog.prongbang.io'

  profile:
    image: nginx:1.13.0-alpine
    container_name: profile
    expose:
      - 80
    volumes:
      - ./web/profile:/var/www/html/web
      - ./nginx/nginx-profile.conf:/etc/nginx/nginx.conf
    environment:
      VIRTUAL_HOST: 'profile.prongbang.io'

networks:
  default:
    external:
      name: nginx-proxy-network
```

# Create and start container
```
$ docker-compose up -d
```

# Setup domain name
> Mac OSX
```
sudo nano /etc/hosts
```

> Example
```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1		localhost blog.prongbang.io profile.prongbang.io
255.255.255.255		broadcasthost
::1                          localhost

```

# Start all in one
```
sh start.sh
```

# Stop
```
sh stop.sh
```

# Listening

> Profile
[http://profile.prongbang.io](http://profile.prongbang.io)

> Blog
[http://blog.prongbang.io](http://blog.prongbang.io)