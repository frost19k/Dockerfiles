# syntax=docker/dockerfile:1.4

FROM eclipse-temurin:17-jdk-focal AS final

ARG WEBGOAT_PORT=8080
ARG WEBWOLF_PORT=9090

ENV WEBGOAT_HOST=0.0.0.0
ENV WEBGOAT_PORT=${WEBGOAT_PORT}

ENV WEBWOLF_HOST=0.0.0.0
ENV WEBWOLF_PORT=${WEBWOLF_PORT}

ENV WEBGOAT_HSQLPORT=9001
ENV WEBGOAT_SSLENABLED=true

ENV GOATURL=http://127.0.0.1:${WEBGOAT_PORT}
ENV WOLFURL=http://127.0.0.1:${WEBWOLF_PORT}

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

EXPOSE ${WEBGOAT_PORT}
EXPOSE ${WEBWOLF_PORT}

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT ./mvnw spring-boot:run
