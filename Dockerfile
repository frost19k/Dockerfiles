# syntax=docker/dockerfile:1.4

ARG WEB_HOST=0.0.0.0

FROM python:3.9-alpine

ARG WEB_HOST
ENV WEB_HOST=${WEB_HOST}

RUN <<eot
#!/bin/ash
apk add --no-cache --virtual .deps curl git
git clone --depth 1 'https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application.git' /opt/dvga
cd /opt/dvga
pip3 install --no-cache-dir -U pip wheel setuptools
pip3 install --no-cache-dir -r requirements.txt
pip3 install --no-cache-dir .
apk del .deps
eot

EXPOSE 5013/tcp

WORKDIR /opt/dvga
ENTRYPOINT [ "python3", "app.py" ]
