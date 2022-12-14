# Amass <img align='right' src="https://raw.githubusercontent.com/OWASP/Amass/master/images/amass_logo.png" width=36/>

## About

[Amass](https://github.com/OWASP/Amass) is an in-depth Attack Surface Mapping and Asset Discovery tool, written in golang.

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/amass/Dockerfile

## Run the container

```bash
❯ docker run -it --rm \
  -v "${PWD}":'/amass/' \
  frost19k/amass enum -d example.com
```
