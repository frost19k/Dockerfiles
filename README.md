<p>
  <img src="https://raw.githubusercontent.com/OWASP/Amass/master/images/amass_logo.png" width=5% style="float:right;"/>
  <h1>Amass</h1>
</p>

Here is where I manage & conduct experiments to improve the Docker Container for [Amass](https://github.com/OWASP/Amass).

This image differs from the official in two ways
1. It runs `amass` as root inside the container
2. It outputs to `/amass` instead of `/.config/amass`

### Run the container
```bash
❯ docker run -it --rm \
  -v "${PWD}":'/amass/' \
  frost19k/amass enum -d example.com
```
