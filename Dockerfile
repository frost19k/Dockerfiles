# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM golang:1.17-alpine AS subjack
ENV GO111MODULE=on
RUN go install -v github.com/haccer/subjack@latest

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:3.14 AS final

ADD https://raw.githubusercontent.com/haccer/subjack/master/fingerprints.json /root/.config/subjack/

COPY --from=subjack /go/bin/subjack /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "-h" ]
