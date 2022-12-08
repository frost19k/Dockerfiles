# Dockerfiles 🐳

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/frost19k/Dockerfiles/blob/master/LICENSE)
[![Build on Schedule](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-schedue.yml/badge.svg?branch=master)](https://github.com/frost19k/Dockerfiles/actions/workflows/build-on-schedue.yml)

In this repo I maintain the Dockerfiles for the tools I use in Bug Hunting.

Each branch of this repo is a different tool. I've organised things this way so that:
- I don't have to disperse my Docker credentials across multiple repos
- I don't have to rebuild every image everytime I update any one of them

Some of these tools do **not** have an official Docker Image, others do. The ones that have an official image have been rewritten & the resoning is explained in their respective READMEs.

## Available Tools

| Branch Name   | Docker Image           | Links          |
|---------------|------------------------|----------------|
| DNSValidator  | frost19k/dnsvalidator  | [Repo](https://github.com/frost19k/DNSValidator) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/DNSValidator/README.md)
| DVGA          | frost19k/dvga          | [Repo](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/DVGA/README.md)
| NSBrute       | frost19k/nsbrute       | [Repo](https://github.com/shivsahni/NSBrute) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/NSBrute/README.md)
| WebGoat       | frost19k/webgoat       | [Repo](https://github.com/WebGoat/WebGoat) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/WebGoat/README.md)
| amass         | frost19k/amass         | [Repo](https://github.com/OWASP/Amass) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/amass/README.md)
| puredns       | frost19k/puredns       | [Repo](https://github.com/d3mondev/puredns) \| [ReadMe](https://github.com/frost19k/Dockerfiles/blob/puredns/README.md)

### Clone the build files
```bash
git clone -b BRANCH_NAME https://github.com/frost19k/Dockerfiles.git
```

### Pull from Docker Hub
```bash
docker pull DOCKER_IMAGE:latest
```
