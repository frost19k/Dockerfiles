# syntax=docker/dockerfile:1.4

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:latest AS gitter

COPY entrypoint.sh /webgoat/entrypoint.sh
WORKDIR /webgoat

RUN <<eot
#!/bin/ash
set -x

###>> Install dependencies <<###
apk add -U curl git jq wget

###>> Donwload latest release <<###
JSON=$(curl -s https://api.github.com/repos/WebGoat/WebGoat/releases/latest)
echo ${JSON} | jq -r ".assets[] | .browser_download_url" | wget -qi -
for FILE in $(ls | grep '.jar'); do mv ${FILE} "$(echo ${FILE} | cut -d '-' -f 1).jar"; done

###>> Set version info <<###
VERSION=$(echo ${JSON} | jq -r ".tag_name" | tr -d 'v')
sed -i "/^VERSION=/s/=.*/=${VERSION}/" entrypoint.sh

###>> Set permissions <<###
chmod -R 0775 .
eot

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM eclipse-temurin:17-jdk-focal AS base

COPY --from=gitter /webgoat /home/webgoat/

RUN <<eot
#!/bin/bash
set -x

###>> Configure system <<###
apt update
apt full-upgrade -f -y --allow-downgrades
apt install -y --no-install-recommends apt-utils nginx

###>> Configure USER <<###
groupadd webgoat
useradd -M -g webgoat -d /home/webgoat -s /bin/bash webgoat
chown -R 0 /home/webgoat
chmod -R g=u /home/webgoat

###>> Clean up <<###
apt update
apt autoremove -y
apt clean all
find /var/lib/apt/lists -type f -delete
find /var/cache -type f -delete
find /var/log -type f -delete
find /tmp -type f -delete
eot

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080
EXPOSE 9090

ENV WEBGOAT_PORT=8080
ENV WEBGOAT_SSLENABLED=false

ENV GOATURL=https://127.0.0.1:$WEBGOAT_PORT
ENV WOLFURL=http://127.0.0.1:9090

USER webgoat
WORKDIR /home/webgoat

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "/home/webgoat/entrypoint.sh" ]
