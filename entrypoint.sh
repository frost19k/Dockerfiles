#!/usr/bin/env bash

HOST_ADDR=$1
WEBGOAT_PORT=$2
WEBWOLF_PORT=$3

./mvnw spring-boot:run \
  -Dspring-boot.run.jvmArguments="\
    -Duser.home=/webgoat \
    -Dfile.encoding=UTF-8 \
    --add-opens java.base/java.lang=ALL-UNNAMED \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang.reflect=ALL-UNNAMED \
    --add-opens java.base/java.text=ALL-UNNAMED \
    --add-opens java.desktop/java.beans=ALL-UNNAMED \
    --add-opens java.desktop/java.awt.font=ALL-UNNAMED \
    --add-opens java.base/sun.nio.ch=ALL-UNNAMED \
    --add-opens java.base/java.io=ALL-UNNAMED \
    --add-opens java.base/java.util=ALL-UNNAMED \
    -Drunning.in.docker=true \
    -Dwebgoat.host=${HOST_ADDR} \
    -Dwebwolf.host=${HOST_ADDR} \
    -Dwebgoat.port=${WEBGOAT_PORT} \
    -Dwebwolf.port=${WEBWOLF_PORT} \
  "
