# syntax=docker/dockerfile:1.3-labs

FROM golang:1.17-alpine AS subjack
ENV GO111MODULE=on
RUN <<eot
#!/bin/ash
apk add -U git
git clone https://github.com/haccer/subjack.git src/github.com/haccer/subjack/
cd src/github.com/haccer/subjack/
go mod init
go mod tidy
go install
eot

FROM golang:1.17-alpine AS notify
ENV GO111MODULE=on
RUN go install -v github.com/projectdiscovery/notify/cmd/notify@latest

FROM alpine:3.14 AS final
COPY --from=subjack /go/bin/subjack /usr/local/bin/
COPY --from=notify /go/bin/notify /usr/local/bin/

ENTRYPOINT [ "subjack" ]
