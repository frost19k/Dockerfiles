# syntax=docker/dockerfile:1.4

ARG WEB_HOST=0.0.0.0
ARG WEBGOAT_PORT=8081
ARG WEBWOLF_PORT=9091

FROM maven:3-eclipse-temurin-17-alpine AS builder
WORKDIR /webgoat
RUN <<eot
apk add --no-cache git
git clone --branch develop https://github.com/WebGoat/WebGoat.git .
mvn clean package
eot

FROM eclipse-temurin:17-jre-alpine AS final
ARG WEB_HOST
ARG WEBGOAT_PORT
ARG WEBWOLF_PORT

ENV WEBGOAT_HOST=${WEB_HOST}
ENV WEBGOAT_PORT=${WEBGOAT_PORT}
ENV WEBWOLF_HOST=${WEB_HOST}
ENV WEBWOLF_PORT=${WEBWOLF_PORT}

# ENV WEBGOAT_HSQLPORT=9001
# ENV WEBGOAT_SSLENABLED=true

COPY --from=builder /webgoat/target/webgoat-*.jar /webgoat/webgoat.jar
COPY entrypoint.sh /webgoat/entrypoint.sh

ADD https://raw.githubusercontent.com/WebGoat/WebGoat/develop/LICENSE.txt /webgoat/

RUN <<eot
addgroup -S webgoat
adduser -D -S webgoat -g WebGoat -G webgoat -h /webgoat
chmod -R 0755 /webgoat
eot

EXPOSE ${WEBGOAT_PORT}
EXPOSE ${WEBWOLF_PORT}

USER webgoat
WORKDIR /webgoat
ENTRYPOINT [ "./entrypoint.sh" ]
