# Subzy

Here is where I manage & conduct experiments to improve the Docker Container for [Subzy](https://github.com/LukaSikic/subzy).

### To run the container
```bash
❯ docker run -it --rm \
  -v "${PWD}/subdomains.txt":'/subzy/subdomains.txt' \
  frost19k/subzy -targets 'subdomains.txt'
```
