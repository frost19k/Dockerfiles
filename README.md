# WebGoat <img align='right' src="assets/logo-small-round.png" width=5%/>

Here is where I manage & conduct experiments to improve the Docker Container for [WebGoat](https://github.com/WebGoat/WebGoat).

Fixes the following issue with the official image:
```bash
❯ docker run -it \
  -p 127.0.0.1:8080:8080 \
  -p 127.0.0.1:9090:9090 \
  -e TZ=Europe/Amsterdam \
  webgoat/webgoat
[...]
2022-05-07 09:57:36.554 ERROR 1 --- [main] hsqldb.db.HSQLDB809D8627A0.ENGINE: could not reopen database
```

### Run the container
```bash
❯ docker run -it \
  -p 8081:8081 \
  -p 9091:9091 \
  -e TZ=Europe/Amsterdam \
  frost19k/webgoat
```
