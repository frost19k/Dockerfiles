# syntax=docker/dockerfile:1.3-labs

FROM golang:1.17-alpine AS go-builder
ENV GO111MODULE=on
RUN go install -v github.com/lukasikic/subzy@latest
RUN go install -v github.com/projectdiscovery/notify/cmd/notify@latest

FROM alpine:3.14 AS final
COPY --from=go-builder /go/bin/subzy /usr/local/bin/
COPY --from=go-builder /go/bin/notify /usr/local/bin/

ENTRYPOINT [ "subzy" ]
