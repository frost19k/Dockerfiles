#!/usr/bin/env bash

VERSION=8.2.2

service nginx start

sleep 3s

java \
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
  -Dwebgoat.host=0.0.0.0 \
  -Dwebwolf.host=0.0.0.0 \
  -Dwebgoat.port=8080 \
  -Dwebwolf.port=9090 \
  -jar webgoat.jar \
    --webgoat.build.version=${VERSION} \
    --server.address=0.0.0.0 2>&1 > webgoat.log &

sleep 30s

java \
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
  -jar webwolf.jar \
    --webgoat.build.version=${VERSION} \
    --server.address=0.0.0.0 2>&1 > webwolf.log &

tail -300f webgoat.log
