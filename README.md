# subjack

Here is where I manage & conduct experiments to improve the Docker Container for [Subjack](https://github.com/haccer/subjack).

### To run the container
```bash
❯ docker run -it --rm \
  -v "${PWD}/subdomains.txt":'/subjack/subdomains.txt' \
  frost19k/subjack -w 'subdomains.txt' -a -m
```