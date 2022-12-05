# syntax=docker/dockerfile:1.4

FROM golang:alpine AS puredns
RUN go install github.com/d3mondev/puredns/v2@latest

FROM alpine:latest AS massdns
RUN <<eot
#!/bin/ash
apk add -U build-base git ldns-dev
git clone -b master https://github.com/blechschmidt/massdns.git
cd /massdns
make
eot

FROM alpine:latest AS final

RUN apk add --no-cache ldns

ADD https://raw.githubusercontent.com/trickest/resolvers/main/resolvers-trusted.txt /puredns/resolvers.txt
ADD https://gist.githubusercontent.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt /puredns/all.txt

COPY --from=massdns /massdns/bin/massdns /usr/local/bin/
COPY --from=puredns /go/bin/puredns /usr/local/bin/

COPY LICENSE /puredns/

WORKDIR /puredns
ENTRYPOINT [ "puredns" ]
CMD [ "--help" ]
