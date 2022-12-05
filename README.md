# Damn Vulnerable GraphQL Application <img align='right' src="assets/logo-small.png" width=3%/>

Here is where I manage & conduct experiments to improve the Docker Container for [DVGA](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application).

The official image doesn't seem to be working...
```Bash
❯ docker run -it --rm -p 5013:5013 -e WEB_HOST=0.0.0.0 dolevf/dvga
Traceback (most recent call last):
  File "app.py", line 5, in <module>
    from flask import Flask
ModuleNotFoundError: No module named 'flask'
```
### Run the container
```bash
❯ docker run -it --rm -p 5013:5013 frost19k/dvga
```
Note: In this image `WEB_HOST` is already `0.0.0.0`.
