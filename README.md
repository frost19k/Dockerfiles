# Aircrack-ng

Here is where I manage & conduct experiments to improve the Docker Container for [Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng).

### Run the container
```bash
❯ docker run -it --rm \
  --userns=host --network=host --privileged \
  frost19k/aircrack-ng
```
** You might not need the `--userns=host` flag if you do not use [Linux Namespaces](https://www.jujens.eu/posts/en/2017/Jul/02/docker-userns-remap/).