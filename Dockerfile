# syntax=docker/dockerfile:1.4

ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US

################################
#-> Configure the base image <-#
################################
FROM kalilinux/kali-last-release:latest AS base

ARG LANG
ARG LANGUAGE

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

COPY dpkg/01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY apt/blacklist-python /etc/apt/preferences.d/blacklist-python

COPY src /grond/
WORKDIR /grond

RUN <<eot
#!/bin/bash

#-> Backup .bashrc
cp /root/.bashrc /root/default.bashrc

#-> System Update
./setup.sh sys_full_upgrade

#-> Congifure Locales
./setup.sh sys_config_locales

#-> Congifure localepurge
./setup.sh sys_config_localepurge

#-> Clean up
./setup.sh clean_up
eot

ENV LANG=${LANG}
ENV LANGUAGE=${LANGUAGE}
ENV LC_ALL=${LANG}

###################################
#-> Configure core dependencies <-#
###################################
FROM base AS stage-1

ENV PYENV_ROOT='/root/.pyenv'
ENV GOROOT='/usr/local/go'
ENV GOPATH='/root/go'
ENV AXIOMPATH='/root/.axiom/interact'
ENV CARGOPATH='/root/.cargo/bin'
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${GOROOT}:${PATH}:${GOPATH}:${AXIOMPATH}:${CARGOPATH}"

COPY deps /tmp/deps/

RUN <<eot
#!/bin/bash

#-> Install Deps.
./setup.sh install_sys_deps 'base'
./setup.sh install_sys_deps 'core'

#-> Clone reconFTW
./setup.sh install_reconftw

#-> Clone Axiom
./setup.sh install_axiom

#-> Clean up
./setup.sh clean_up
eot

############################
#-> Install all go tools <-#
############################
FROM stage-1 AS go-tools
RUN ./setup.sh install_golang
RUN ./setup.sh install_go_tools

################################
#-> Install all python tools <-#
################################
FROM stage-1 as py-tools
RUN ./setup.sh install_python
RUN ./setup.sh install_py_tools

#################################
#-> Configure the final image <-#
#################################
FROM stage-1 AS final

COPY --from=go-tools /root/go/bin /usr/local/bin/

COPY --from=py-tools /usr/local/bin/massdns /usr/local/bin/
COPY --from=py-tools /root/tools /root/tools/
COPY --from=py-tools /root/.pyenv /root/.pyenv/
COPY --from=py-tools /root/.gf /root/.gf/

RUN <<eot
#!/bin/bash

#-> Install More tools
./setup.sh install_ot_tools

#-> Fetch required files
./setup.sh install_required_files

#-> Generate resolvers
./setup.sh generate_resolvers

#-> Install last steps
./setup.sh install_last_steps

#-> Clean up
./setup.sh clean_up
cd / && rm -rf '/grond'

#-> Restore .bashrc
mv /root/default.bashrc /root/.bashrc
find /root -type f \( -name '.bashrc*' -not -name '.bashrc' \) -delete
eot

WORKDIR /
SHELL [ "/bin/bash" ]
