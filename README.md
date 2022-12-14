# NSBrute

## About

[NSBrute](https://github.com/shivsahni/NSBrute) is a python2 utility to takeover domains vulnerable to AWS NS Takeover

## Dockerfile

https://github.com/frost19k/Dockerfiles/blob/NSBrute/Dockerfile

## Run the container

```Bash
❯ docker run -it --rm \
  frost19k/nsbrute -d example.com -a 'your-AWS-AccessKey' -s 'your-AWS-SecretKey'
```
