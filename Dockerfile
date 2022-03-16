# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:latest as gitter
RUN <<eot
apk add -U git
git clone https://github.com/shivsahni/NSBrute.git /NSBrute
git clone --depth 1 --branch v1.16.0 https://github.com/rthalley/dnspython /dnspython
eot

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM python:2.7-slim AS base

COPY --from=gitter /NSBrute /NSBrute/
COPY --from=gitter /dnspython /dnspython/

RUN <<eot
#!/bin/bash
cd /dnspython
python setup.py install
cd /NSBrute
pip install -r requirements.txt
eot

WORKDIR '/NSBrute'
ENTRYPOINT [ "python", "./NSBrute.py" ]
CMD [ "--help" ]
