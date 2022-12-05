# syntax=docker/dockerfile:1.4

FROM python:3.9-alpine AS builder
RUN <<eot
#!/bin/ash
apk add --no-cache build-base git
git clone -b master https://github.com/frost19k/DNSValidator.git
cd DNSValidator/
pip3 install --upgrade --no-cache pip setuptools wheel
pip3 install .
eot

FROM python:3.9-alpine AS final

COPY --from=builder /usr/local/bin/dnsvalidator /usr/local/bin/
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages/

COPY LICENSE /dnsvalidator/

WORKDIR /dnsvalidator
ENTRYPOINT [ "dnsvalidator" ]
CMD [ "--help" ]
