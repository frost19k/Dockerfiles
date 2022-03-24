# DNSValidator

Here is where I manage & conduct experiments to improve the Docker Container for [DNSValidator](https://github.com/frost19k/DNSValidator).

### To run the container
```bash
❯ docker run -it --rm \
  -v "{PWD}":'/dnsvalidator/'
  frost19k/dnsvalidator -t 20 -o resolvers.txt
```
