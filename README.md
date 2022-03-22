# Amass
###### source https://github.com/OWASP/Amass.git

Here is where I manage & conduct experiments to improve the Docker Container for Amass.

This image differs from the official in two ways
1. It runs `amass` as root inside the container
2. It outputs to `/amass` instead of `/.config/amass`

### Run the container
```bash
❯ docker run -it --rm \
  -v "${PWD}/":'/amass' \
  frost19k/amass:latest enum -d example.com
```