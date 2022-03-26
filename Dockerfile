# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM golang:1.17-alpine AS subzy
RUN go install -v github.com/lukasikic/subzy@latest

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:latest AS final

COPY --from=subzy /go/bin/subzy /usr/local/bin/

WORKDIR /subzy

SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "subzy" ]
CMD [ "-h" ]
