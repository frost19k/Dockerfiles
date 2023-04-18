# syntax=docker/dockerfile:1.4

FROM golang:alpine AS builder
RUN <<eot
#!/bin/ash
apk add -U git subversion
go install -v github.com/owasp-amass/amass/v3/...@master
svn checkout https://github.com/OWASP/Amass/trunk/examples/wordlists /wordlists
eot

FROM alpine:latest AS final

ADD https://raw.githubusercontent.com/OWASP/Amass/master/LICENSE /amass/

COPY --from=builder /go/bin/amass /usr/local/bin/
COPY --from=builder /wordlists/*.txt /wordlists/

RUN <<eot
#!/bin/ash
apk add --no-cache ca-certificates
mkdir -p /root/.config/amass
ln -sf /root/.config/amass /amass
eot

WORKDIR /amass
ENTRYPOINT [ "amass" ]
CMD [ "-help" ]
