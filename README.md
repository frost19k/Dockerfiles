# Dockerfiles 🐳

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/frost19k/Dockerfiles/blob/master/LICENSE)
[![Build on Schedule](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-schedue.yml/badge.svg?branch=master)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-schedue.yml)

In this repo I maintain the Dockerfiles for the tools I use in Bug Hunting.

Each branch of this repo is a different tool. I've organised things this way so that:
- I don't have to disperse my Docker credentials across multiple repos
- I don't have to rebuild every image everytime I update any one of them

Some of these tools do **not** have an official Docker Image, others do. The ones that have an official image have been rewritten & the resoning is explained in their respective READMEs.

## Available Tools

| Name          | Docker Image           | Links          | Status (Latest Push)    |
|---------------|------------------------|----------------|-------------------------|
| Amass         | frost19k/amass         | [Repo](https://github.com/OWASP/Amass) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/amass/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=amass)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| DNSValidator  | frost19k/dnsvalidator  | [Repo](https://github.com/frost19k/DNSValidator) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/DNSValidator/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=DNSValidator)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| NSBrute       | frost19k/nsbrute       | [Repo](https://github.com/shivsahni/NSBrute) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/NSBrute/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=NSBrute)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| Subjack       | frost19k/subjack       | [Repo](https://github.com/haccer/subjack) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/subjack/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=subjack)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| Subzy         | frost19k/subzy         | [Repo](https://github.com/LukaSikic/subzy) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/Subzy/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=Subzy)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| puredns       | frost19k/puredns       | [Repo](https://github.com/d3mondev/puredns) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/puredns/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=puredns)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)
| reconFTW      | frost19k/reconftw      | [Repo](https://github.com/six2dez/reconftw) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/reconFTW/README.md)  | [![Build on Push](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml/badge.svg?branch=reconFTW)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-push.yml)

### Pull from Docker Hub
```bash
docker pull frost19k/IMAGE:latest
```
