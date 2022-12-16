# syntax=docker/dockerfile:1.4

ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US

################################
#-> Configure the base image <-#
################################
FROM kalilinux/kali-last-release:latest AS base

ARG LANG
ARG LANGUAGE

ENV LANG=$LANG
ENV LANGUAGE=$LANGUAGE
ENV LC_ALL=$LANG

ENV PYENV_ROOT='/root/.pyenv'
ENV GOROOT='/usr/local/go'
ENV GOPATH='/root/go'
ENV AXIOMPATH='/root/.axiom/interact'
ENV CARGOPATH='/root/.cargo/bin'
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${GOROOT}:${PATH}:${GOPATH}:${AXIOMPATH}:${CARGOPATH}"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

COPY dpkg/01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY apt/blacklist-python /etc/apt/preferences.d/blacklist-python

COPY deps /tmp/deps/
COPY src /grond/

WORKDIR /grond

RUN <<eot
#!/bin/bash

source grond.cfg
source logger.sh

#-> Backup .bashrc
cp /root/.bashrc /root/default.bashrc

#-> System Update
log_info -p "${bblue}System${reset}: Updating base image..."
ec=0
echo "deb http://kali.download/kali kali-last-snapshot main contrib non-free" > /etc/apt/sources.list
echo "deb-src http://kali.download/kali kali-last-snapshot main contrib non-free" >> /etc/apt/sources.list
eval apt clean all ${nullout}; ec=$((ec + $?))
eval apt update ${nullout}; ec=$((ec + $?))
eval apt full-upgrade -f -y --allow-downgrades ${nullout}; ec=$((ec + $?))
[[ ${ec} == 0 ]] && log_info -d || { log-info -e; log_crt "Failed to update system"; }

#-> Congifure Locales
log_info -p "${bblue}System${reset}: Configuring locales..."
ec=0
eval apt install -y --no-install-recommends locales ${nullout}; ec=$((ec + $?))
eval sed -i -- "'/${LANG}/s/^# //g'" /etc/locale.gen; ec=$((ec + $?))
eval dpkg-reconfigure locales ${nullout}; ec=$((ec + $?))
eval update-locale LANG=${LANG} ${nullout}; ec=$((ec + $?))
[[ ${ec} == 0 ]] && log_info -d || { log-info -e; log_crt "Failed to configure locales"; }

#-> Congifure localepurge
log_info -p "${bblue}System${reset}: Configuring localepurge..."
ec=0
eval apt install -y --no-install-recommends localepurge ${nullout}; ec=$((ec + $?))
eval sed -i -- '/^USE_DPKG/s/^/#/' /etc/locale.nopurge ${nullout}; ec=$((ec + $?))
eval dpkg-reconfigure localepurge ${nullout}; ec=$((ec + $?))
eval localepurge ${nullout}; ec=$((ec + $?))
[[ ${ec} == 0 ]] && log_info -d || { log-info -e; log_crt "Failed to configure localepurge"; }

#-> Install Deps.
./setup.sh install_sys_deps 'base'
./setup.sh install_sys_deps 'core'

#-> Install Golang
./setup.sh install_golang

#-> Configure Python
./setup.sh install_python

#-> Clone Axiom
./setup.sh install_axiom

#-> Clean up
./setup.sh clean_up
eot

############################
#-> Install all go tools <-#
############################
FROM base AS go-tools
RUN ./setup.sh install_go_tools

################################
#-> Install all python tools <-#
################################
FROM base as py-tools
RUN ./setup.sh install_py_tools

#################################
#-> Configure the final image <-#
#################################
FROM base AS final

COPY --from=go-tools /root/go/bin /usr/local/bin/

COPY --from=py-tools /usr/local/bin/massdns /usr/local/bin/
COPY --from=py-tools /root/tools /root/tools/
COPY --from=py-tools /root/.pyenv /root/.pyenv/
COPY --from=py-tools /root/.gf /root/.gf/

RUN <<eot
#!/bin/bash
#-> Install Other tools
./setup.sh install_ot_tools
#-> Required files
./setup.sh install_required_files
#-> Generate resolvers
./setup.sh generate_resolvers
#-> Install Last Steps
./setup.sh install_last_steps
#-> Clean up
./setup.sh clean_up
#-> Restore .bashrc
mv /root/default.bashrc /root/.bashrc
find /root -type f \( -name '.bashrc*' -not -name '.bashrc' \) -delete
eot

WORKDIR /
SHELL [ "/bin/bash" ]
