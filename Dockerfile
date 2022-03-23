# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM golang:1.17-alpine AS subjack
ENV GO111MODULE=on
RUN go install -v github.com/haccer/subjack@latest

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:latest AS final

ADD https://raw.githubusercontent.com/haccer/subjack/master/LICENSE .
ADD https://raw.githubusercontent.com/haccer/subjack/master/fingerprints.json /root/.config/subjack/

COPY --from=subjack /go/bin/subjack /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

WORKDIR /subjack

SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "-h" ]
