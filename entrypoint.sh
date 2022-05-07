#!/usr/bin/env bash

VERSION=

service nginx start

sleep 3

java -Duser.home=/home/webgoat -Dfile.encoding=UTF-8 -jar webgoat.jar --webgoat.build.version=${VERSION} --server.address=0.0.0.0  > webgoat.log &

sleep 10

java -Duser.home=/home/webgoat -Dfile.encoding=UTF-8 -jar webwolf.jar --webgoat.build.version=${VERSION} --server.address=0.0.0.0 > webwolf.log &

tail -300f webgoat.log
