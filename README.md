# Puredns

## About

[Puredns](https://github.com/d3mondev/puredns) is a fast domain resolver and subdomain bruteforcing tool that can accurately filter out wildcard subdomains and DNS poisoned entries.

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/puredns/Dockerfile

## Run the container

Bruteforce a list of subdomains using a wordlist named `all.txt`

```bash
❯ docker run -t --rm \
  -v "${PWD}/all.txt":"/puredns/all.txt" \
  frost19k/puredns bruteforce all.txt domain.com
```

Resolve a list of domains contained in a text file (one per line)

```bash
❯ docker run -t --rm \
  -v "${PWD}/domains.txt":"/puredns/domains.txt" \
  frost19k/puredns resolve domains.txt
```
