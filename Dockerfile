# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM python:2.7-slim as base
RUN <<eot
#!/bin/bash
set -x

#####>> Configure System <<#####
apt update
apt install -y git
python -m pip install -U wheel setuptools

#####>> Configure dnspython <<#####
git clone --depth 1 --branch v1.16.0 https://github.com/rthalley/dnspython /dnspython
cd /dnspython
python setup.py install

#####>> Configure NSBrute <<#####
git clone https://github.com/shivsahni/NSBrute.git /NSBrute
cd /NSBrute
pip install -r requirements.txt
eot

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM python:2.7-slim AS final

COPY --from=base /usr/local/lib/python2.7/site-packages /usr/local/lib/python2.7/site-packages/
COPY --from=base /NSBrute /NSBrute/

WORKDIR '/NSBrute'

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "python", "./NSBrute.py" ]
CMD [ "--help" ]
