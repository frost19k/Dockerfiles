# syntax=docker/dockerfile:1.4

FROM python:2.7-slim as base
RUN <<eot
#!/bin/bash
set -x
###>> Configure System
apt update
apt install -y git
python -m pip install -qq -U pip<21.0 wheel<0.34 setuptools<44.0
###>> Configure dnspython
git clone --branch v1.16.0 https://github.com/rthalley/dnspython.git /dnspython
cd /dnspython &&
python setup.py install
###>> Configure NSBrute
git clone https://github.com/shivsahni/NSBrute.git /NSBrute
cd /NSBrute
pip install -qq -r requirements.txt
eot

FROM python:2.7-slim AS final

COPY --from=base /usr/local/lib/python2.7/site-packages /usr/local/lib/python2.7/site-packages/
COPY --from=base /NSBrute /NSBrute/

WORKDIR '/NSBrute'
ENTRYPOINT [ "python", "./NSBrute.py" ]
