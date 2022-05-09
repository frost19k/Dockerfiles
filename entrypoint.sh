#!/usr/bin/env bash

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
    -Dwebgoat.host=${WEBGOAT_HOST} \
    -Dwebwolf.host=${WEBWOLF_HOST} \
    -Dwebgoat.port=${WEBGOAT_PORT} \
    -Dwebwolf.port=${WEBWOLF_PORT} \
  "
