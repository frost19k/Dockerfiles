# syntax=docker/dockerfile:1.4

FROM alpine:latest AS base

RUN <<eot
#!/bin/ash
set -x
DEPS='libtool usbutils pciutils openssl3-dev util-linux'
apk add -U -t .deps ${DEPS}
apk add -u aircrack-ng
eot

SHELL [ "/bin/ash", "-c" ]
