# syntax=docker/dockerfile:1.3-labs

FROM golang:1.16-alpine AS subzy
ENV GO111MODULE=on
RUN go install -v github.com/lukasikic/subzy@latest

FROM alpine:3.14 AS final
COPY --from=subzy /go/bin/subzy /usr/local/bin/

ENTRYPOINT [ "subzy" ]
