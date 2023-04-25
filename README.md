# XSStrike <img align='right' src="https://image.ibb.co/cpuYoA/xsstrike-logo.png" width=36/>

## About

[XSStrike](https://github.com/s0md3v/XSStrike) is a Cross Site Scripting detection suite equipped with four hand written parsers, an intelligent payload generator, a powerful fuzzing engine and an incredibly fast crawler.

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/XSStrike/Dockerfile

## Run the container

```bash
❯ docker run -it --rm \
  frost19k/xsstrike -u https://example.com/search?q=test
```
