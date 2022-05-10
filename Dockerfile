# syntax=docker/dockerfile:1.4

ARG HOST_ADDR=0.0.0.0
ARG WEBGOAT_PORT=8080
ARG WEBWOLF_PORT=9090

FROM maven:3-eclipse-temurin-17-alpine AS builder

WORKDIR /webgoat

RUN <<eot
apk add -U git
git clone --depth 1 --branch develop https://github.com/WebGoat/WebGoat.git .
mvn clean package
eot

FROM eclipse-temurin:17-jre-alpine AS final

ARG HOST_ADDR
ARG WEBGOAT_PORT
ARG WEBWOLF_PORT

ENV WEBGOAT_HOST=${HOST_ADDR}
ENV WEBGOAT_PORT=${WEBGOAT_PORT}

ENV WEBWOLF_HOST=${HOST_ADDR}
ENV WEBWOLF_PORT=${WEBWOLF_PORT}

# ENV WEBGOAT_HSQLPORT=9001
# ENV WEBGOAT_SSLENABLED=true

COPY entrypoint.sh /webgoat/entrypoint.sh
COPY --from=builder /webgoat/target/webgoat-*.jar /webgoat/webgoat.jar

RUN <<eot
addgroup -S webgoat
adduser -D -S webgoat -g WebGoat -G webgoat -h /webgoat
chmod -R 0755 /webgoat
eot

EXPOSE ${WEBGOAT_PORT}
EXPOSE ${WEBWOLF_PORT}

USER webgoat
WORKDIR /webgoat

SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "./entrypoint.sh" ]
