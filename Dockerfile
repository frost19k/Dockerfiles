# syntax=docker/dockerfile:1.4

FROM python:3.10-alpine

RUN <<eot
#!/bin/ash
apk add -U --no-cache g++ gcc git libffi-dev make openssl-dev
git clone https://github.com/s0md3v/XSStrike.git /opt/XSStrike
cd /opt/XSStrike
pip3 install -r requirements.txt
eot

WORKDIR /opt/XSStrike
SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "python3", "xsstrike.py" ]
