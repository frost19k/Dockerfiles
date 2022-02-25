# syntax=docker/dockerfile:1.3-labs

FROM golang:1.17-alpine AS puredns
ENV GO111MODULE=on
RUN go install github.com/d3mondev/puredns/v2@latest

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:3.14 AS massdns
RUN <<eot
#!/bin/ash
apk add --update --no-cache --virtual .deps build-base cmake git ldns-dev
git clone --branch=master --depth=1 https://github.com/blechschmidt/massdns.git
cd /massdns
make
eot

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:3.14 AS final
LABEL maintainer="Hoodly Twokeys <hoodlytwokeys@gmail.com>"

WORKDIR /puredns

COPY --from=massdns /massdns/bin/massdns /usr/local/bin/
COPY --from=puredns /go/bin/puredns /usr/local/bin/

COPY LICENSE .

RUN <<eot
#!/bin/ash
apk add --update --no-cache ldns
wget https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt
eot

ENTRYPOINT [ "puredns" ]
CMD [ "--help" ]
