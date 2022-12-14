# DNSValidator

## About

[DNSValidator](https://github.com/frost19k/DNSValidator) filters a list of IPv4 DNS Servers by verifying them against baseline servers, and ensuring accurate responses.

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/DNSValidator/Dockerfile

## Run the container

```Bash
❯ docker run -it --rm \
  -v "{PWD}":'/dnsvalidator' \
  frost19k/dnsvalidator -t 20 -o resolvers.txt
```
