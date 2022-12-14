# WebGoat <img align='right' src="https://raw.githubusercontent.com/frost19k/Dockerfiles/WebGoat/assets/logo-small-round.png" width=36/>

## About

[WebGoat](https://github.com/WebGoat/WebGoat) is a deliberately insecure web application.

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/WebGoat/Dockerfile

## Run the container

```Bash
❯ docker run -it --rm \
  -p 8081:8081 \
  -p 9091:9091 \
  -e TZ=Europe/Amsterdam \
  frost19k/webgoat
```
