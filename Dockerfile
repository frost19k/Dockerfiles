# syntax=docker/dockerfile:1.3-labs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM golang:1.17-alpine AS subzy
ENV GO111MODULE=on
RUN go install -v github.com/lukasikic/subzy@latest

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

FROM alpine:latest AS final

COPY --from=subzy /go/bin/subzy /usr/local/bin/

SHELL [ "/bin/ash", "-c" ]
ENTRYPOINT [ "subzy" ]
CMD [ "-h" ]
