# syntax=docker/dockerfile:1.4

FROM eclipse-temurin:17-jdk-focal AS final

ARG WEBGOAT_PORT=8080
ARG WEBWOLF_PORT=9090
ARG HOST_ADDR=0.0.0.0

ENV WEBGOAT_HOST=${HOST_ADDR}
ENV WEBGOAT_PORT=${WEBGOAT_PORT}

ENV WEBWOLF_HOST=${HOST_ADDR}
ENV WEBWOLF_PORT=${WEBWOLF_PORT}

WORKDIR /webgoat

RUN <<eot
#!/bin/bash
set -x

###>> Configure system <<###
apt update
apt full-upgrade -f -y --allow-downgrades
apt install -y --no-install-recommends apt-utils ca-certificates git

###>> Configure WebGoat <<###
git clone --depth 1 --branch develop https://github.com/WebGoat/WebGoat.git .
./mvnw clean install

###>> Clean up <<###
apt update
apt remove --purge -y git
apt autoremove -y
apt clean all
find /var/lib/apt/lists -type f -delete
find /var/cache -type f -delete
find /var/log -type f -delete
find /tmp -type f -delete
eot

COPY entrypoint.sh .

EXPOSE ${WEBGOAT_PORT}
EXPOSE ${WEBWOLF_PORT}

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT ./entrypoint.sh
