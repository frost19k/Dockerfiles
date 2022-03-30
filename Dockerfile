# syntax=docker/dockerfile:1.4

FROM alpine:latest AS base

RUN <<eot
#!/bin/ash
set -x
DEPS='libtool ethtool usbutils pciutils libnl3 openssl3-dev libpcap iw util-linux sqlite pcre-dev zlib'
apk add -U -t .deps ${DEPS}
apk add -u aircrack-ng
eot

SHELL [ "/bin/ash", "-c" ]
