# syntax=docker/dockerfile:1.4

ARG PYTHON_VERSION=3.10.4

FROM debian:11-slim AS base

ARG PYTHON_VERSION
ENV PYTHON_VERSION=${PYTHON_VERSION}

ENV PYENV_ROOT='/root/.pyenv'
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

COPY packages.txt /tmp/packages.txt
COPY clean.sh /usr/local/bin/clean.sh

RUN <<eot
#!/bin/bash
chmod +x /usr/local/bin/clean.sh
apt update
apt install -y --no-install-recommends apt-utils ca-certificates
xargs apt install -y --no-install-recommends < /tmp/packages.txt
clean.sh
eot

FROM base AS pyenv

RUN <<eot
#!/bin/bash
apt update
apt install -y --no-install-recommends build-essential make cmake gcc git curl wget
curl https://pyenv.run | bash
eval "$(pyenv init -)"
pyenv install ${PYTHON_VERSION}
eot

FROM base AS final

COPY --from=pyenv /root/.pyenv /root/.pyenv/

RUN <<eot
eval "$(pyenv init -)"
pyenv global ${PYTHON_VERSION}
eot

WORKDIR /pyenv

SHELL [ "/bin/bash", "-c" ]
ENTRYPOINT [ "python3" ]
