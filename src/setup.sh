#!/usr/bin/env bash

function _make_config_dirs() {
  eval mkdir -p ${HOME}/.gf
  eval mkdir -p ${HOME}/.config/notify
  eval mkdir -p ${HOME}/.config/amass
  eval mkdir -p ${HOME}/.config/nuclei
  eval mkdir -p ${tools}
  eval touch ${tools}/.github_tokens
}

##->> Install System Dependencies
function install_sys_deps() {
  local deps=$1 #-> Choose: [ base | core | pyenv ]

  deps="/tmp/deps/${deps}"
  log_info -p "${bblue}System${reset}: Installing ${deps##*/} dependencies..."
  eval apt update ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to update repositories"; }
  eval xargs -a ${deps} apt install -y --no-install-recommends ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to install system dependencies"; }
  [[ ${deps##*/} == 'base' ]] && eval _make_config_dirs ${nullout}
  [[ ${deps##*/} == 'core' ]] && eval systemctl enable tor ${nullout}
  log_info -d
}

##->> Setup Golang
function install_golang() {
  log_info "${bblue}System${reset}: Installing ${cyan}Golang${reset}"

  #-> Set golang version
  log_info -p "${cyan}Golang${reset}: Querying release history..."
  if [[ -z ${go_version} ]]; then
    go_version="$(curl -sSL 'https://go.dev/VERSION?m=text')"
    go_bin="${go_version}.linux-amd64.tar.gz"
  else
    go_bin=$(curl -sSL 'https://go.dev/dl' | grep -oP "go(${go_version})+([0-9\.]+)\.linux-amd64\.tar\.gz" | head -n 1)
  fi
  log_info -d

  go_version=${go_bin%.linux*}

  log_info -p "${cyan}Golang${reset}: Installing v${go_version/go/}..."
  eval wget -P /tmp "https://go.dev/dl/${go_bin}" ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to download ${go_bin}"; }
  eval tar -xzf "/tmp/${go_bin}" -C /usr/local
  eval rm -rf "/tmp/${go_bin}"
  eval ln -sf /usr/local/go/bin/go /usr/local/bin/
  log_info -d
}

##->> Install Golang Tools
function install_go_tools() {
  log_info "${cyan}Golang${reset}: Installing golang tools"

  count=0
  for gotool in "${!gotools[@]}"; do
    count=$((count + 1))
    log_info -p "${cyan}Golang${reset}: Installing ${yellow}${gotool}${reset} ${count}/${#gotools[@]}..."
    eval go install "${gotools[$gotool]}" ${nullout}
    [[ $? == 0 ]] && log_info -d || { log_info -e; continue; }
  done
}

##->> Setup Python
function install_python() {
  log_info "${bblue}System${reset}: Insalling ${cyan}Python${reset}"

  log_info -p "${cyan}Python${reset}: Installing Pyenv..."
  eval "curl -s https://pyenv.run | bash" ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Python: Failed to install Pyenv"; }
  log_info -d

  log_info -p "${cyan}Python${reset}: Querying release history..."
  if [[ -z ${py_version} ]]; then
    py_version=$(pyenv install --list | tr -d ' ' | grep -oP "^(([0-9]{1})\.([0-9]){1,3}\.([0-9]){1,3})$" | sort -Vr | head -n 1)
  else
    py_version=$(pyenv install --list | egrep -i " ${py_version}" | tr -d ' ' | sort -Vr | head -n 1)
  fi
  log_info -d

  log_info -p "${cyan}Python${reset}: Installing Python v${py_version}..."
  eval pyenv install ${py_version} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Python: Failed to install Python ${py_version}"; }
  log_info -d

  log_info -p "${cyan}Python${reset}: Configuring Python v${py_version}..."
  eval pyenv global ${py_version} ${nullout}
  eval python3 -m ensurepip ${nullout}
  eval pip3 install --no-cache-dir -U pip wheel setuptools ${nullout}
  log_info -d

  log_info -p "${cyan}Python${reset}: Setting up poetry..."
  eval "curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local/bin/pypoetry python3 - " ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Python: Failed to setup poetry"; }
  eval ln -sf /usr/local/bin/pypoetry/bin/poetry -t /usr/local/bin/
  log_info -d
}

##->> Install Python Tools
function install_py_tools() {
  log_info "${cyan}Python${reset}: Installing python tools"

  count=0
  for repo in "${!repos[@]}"; do
    count=$(($count + 1))
    log_info "${cyan}Python${reset}: Setting up ${yellow}${repo}${reset} ${count}/${#repos[@]}${reset}"
    tool_dir="${tools}/${repo}"

    log_info -p "${yellow}${repo}${reset}: Cloning repo..."
    eval git clone "https://github.com/${repos[$repo]}.git" ${tool_dir} ${nullout}
    [[ $? == 0 ]] && log_info -d || { log_info -e; continue; }

    eval cd ${tool_dir}

    #-> Handle repos with special configs
    if [[ ${repo} == 'massdns' ]]; then
      log_info -p "${bblue}System${reset}: Installing ${yellow}${repo}${reset}..."
      eval "make ${nullout}"; [[ $? != 0 ]] && { log_info -e; continue; }
      eval "strip -s bin/massdns && mv bin/massdns -t /usr/local/bin/ ${nullout}"
      log_info -d

    elif [[ ${repo} == 'clairvoyance' ]]; then
      log_info -p "${yellow}${repo}${reset}: Installing..."
      eval poetry install --only main ${nullout}; [[ $? == 0 ]] && log_info -d || log_info -e

    elif [[ ${repo} == 'gf' ]]; then
      eval "ln -rsf examples/*.json -t ${HOME}/.gf ${nullout}"

    elif [[ ${repo} == 'Gf-Patterns' ]]; then
      eval "ln -rsf *.json -t ${HOME}/.gf ${nullout}"

    elif [[ ${repo} == 'trufflehog' ]]; then
      continue

    #-> Install regular python packages
    else
      if [[ -s requirements.txt ]]; then
        log_info -p "${yellow}${repo}${reset}: Setting up requirements..."
        eval pip3 install --no-cache-dir -r requirements.txt ${nullout}; [[ $? == 0 ]] && log_info -d || log_info -e
      fi

      if [[ -s setup.py ]]; then
        log_info -p "${yellow}${repo}${reset}: Installing..."
        eval pip3 install --no-cache-dir . ${nullout}; [[ $? == 0 ]] && log_info -d || log_info -e
      fi
    fi

    cd "${tools}"
  done

  log_info -p "${cyan}Python${reset}: Installing additional python tools..."
  reqs_url="https://raw.githubusercontent.com/six2dez/reconftw/${rq_version}/requirements.txt"
  eval wget -qN -P /grond ${reqs_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to fetch requirements.txt"; }
  eval pip3 install --no-cache-dir -r '/grond/requirements.txt' ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to install additional python tools"; }
  log_info -d
}

##->> Install Other Tools
function install_ot_tools() {

  ##->> TruffleHog
  log_info -p "${bblue}System${reset}: Installing ${yellow}TruffleHog${reset}..."
  platform_type='linux_amd64'
  trufflehog_url=$(curl -s https://api.github.com/repos/trufflesecurity/trufflehog/releases/latest | jq -r ".assets[] | select(.name | test(\"${platform_type}\")) | .browser_download_url")
  eval curl -sLO --output-dir /tmp/ ${trufflehog_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to download TruffleHog"; }
  eval mkdir /tmp/trufflehog ${nullout}
  eval tar -xzf "/tmp/${trufflehog_url##*/}" -C /tmp/trufflehog ${nullout}
  eval mv /tmp/trufflehog/trufflehog -t /usr/local/bin/ ${nullout}
  log_info -d

  ##->> nuclei templates
  log_info -p "${bblue}System${reset}: Installing additional ${yellow}Nuclei Templates${reset}..."
  ec=0
  eval git clone --depth 1 https://github.com/projectdiscovery/nuclei-templates.git ${HOME}/nuclei-templates ${nullout}; ec=$((ec + $?))
  eval git clone --depth 1 https://github.com/geeknik/the-nuclei-templates.git ${HOME}/nuclei-templates/extra_templates ${nullout}; ec=$((ec + $?))
  eval wget -qN -O ${HOME}/nuclei-templates/ssrf_nagli.yaml https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/ssrf.yaml ${nullout}; ec=$((ec + $?))
  eval wget -qN -O ${HOME}/nuclei-templates/sap-redirect_nagli.yaml https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/sap-redirect.yaml ${nullout}; ec=$((ec + $?))
  #-> Make sure to update nuclei in last steps.
  [[ ${ec} == 0 ]] && log_info -d || { log_info -e; log_warn "Errors occured while installing additional Nuclei Templates"; }

  ##->> unimap
  log_info -p "${bblue}System${reset}: Installing ${yellow}unimap${reset}..."
  unimap_url='https://github.com/Edu4rdSHL/unimap/releases/download/0.4.0/unimap-linux'
  eval wget -qN -O /tmp/unimap ${unimap_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Could not download unimap"; }
  eval strip -s /tmp/unimap
  eval chmod 0755 /tmp/unimap
  eval cp /tmp/unimap -t /usr/local/bin/
  log_info -d

  ##->> ppfuzz
  log_info -p "${bblue}System${reset}: Installign ${yellow}ppfuzz${reset}..."
  ppfuzz_url='https://github.com/dwisiswant0/ppfuzz/releases/download/v1.0.1/ppfuzz-v1.0.1-x86_64-unknown-linux-musl.tar.gz'
  eval wget -qN -O /tmp/ppfuzz.tar.gz ${ppfuzz_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Could not download ppfuzz"; }
  eval tar -xzf /tmp/ppfuzz.tar.gz -C /tmp
  eval strip -s /tmp/ppfuzz
  eval chmod 0755 /tmp/ppfuzz
  eval cp /tmp/ppfuzz -t /usr/local/bin/
  log_info -d

  ##->> sqlmap
  log_info -p "${bblue}System${reset}: Installing ${yellow}sqlmap${reset}..."
  sqlmap_url='https://github.com/sqlmapproject/sqlmap.git'
  eval git clone --depth 1 ${sqlmap_url} ${tools}/sqlmap ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Errors occured while cloning sqlmap"; }
  log_info -d

  ##->> testssl
  log_info -p "${bblue}System${reset}: Installing ${yellow}testssl.sh${reset}..."
  testssl_url='https://github.com/drwetter/testssl.sh.git'
  eval git clone --depth 1 ${testssl_url} ${tools}/testssl.sh ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Errors occured while cloning testssl.sh"; }
  log_info -d

  ##->> exploitdb
  log_info -p "${bblue}System${reset}: Installing ${yellow}exploitdb${reset}..."
  exploitdb_url='https://gitlab.com/exploit-database/exploitdb.git'
  eval git clone --depth 1 ${exploitdb_url} /opt/exploitdb ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Errors occured while cloning exploitdb"; }
  eval ln -sf /opt/exploitdb/searchsploit /usr/local/bin/ ${nullout}
  log_info -d

  #->> nrich
  log_info -p "${bblue}System${reset}: Installing ${yellow}nrich${reset}..."
  nrich_url='https://gitlab.com/api/v4/projects/33695681/packages/generic/nrich/latest/nrich_latest_amd64.deb'
  eval wget -qN -P /tmp ${nrich_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to download nrich"; }
  eval dpkg -i /tmp/nrich_latest_amd64.deb ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to install nrich"; }
  log_info -d

  ##->> ripgen
  log_info -p "${bblue}System${reset}: Installing ${cyan}Rust${reset}..."
  eval 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y' ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to install rust"; }
  log_info -d

  log_info -p "${cyan}Rust${reset}: Installing ${yellow}ripgen${reset}..."
  eval source $HOME/.cargo/env
  eval cargo install ripgen ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to install ripgen"; }
  log_info -d

  ##->> packer
  log_info -p "${bblue}System${reset}: Installing ${yellow}Packer${reset}..."
  packer_url='https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip'
  eval wget -qN -O /tmp/packer.zip ${packer_url} ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to download packer"; }
  eval unzip /tmp/packer.zip -d /tmp ${nullout}
  eval strip -s /tmp/packer
  eval chmod 0755 /tmp/packer
  eval cp /tmp/packer -t /usr/local/bin/
  log_info -d
}

function install_required_files() {
  eval mkdir -p ${HOME}/.config/{amass,notify,nuclei}

  log_info -p "${bblue}System${reset}: Downloading required files..."
  ec=0
  for entry in "${files[@]}"; do
    eval _url=${entry%[[:space:]]*}
    eval _pth=${entry#*[[:space:]]}
    [[ ! -d ${_pth%/*} ]] && eval mkdir -p ${_pth%/*}
    eval wget -qN -O ${_pth} ${_url} ${nullout}; ec=$((ec + $?))
  done

  [[ ${ec} == 0 ]] && log_info -d || { log_info -e; log_warn "Some required files failed to download"; }
  [[ -s ${tools}/axiom_config.sh ]] && eval chmod 0755 ${tools}/axiom_config.sh
}

function generate_resolvers() {
  log_info -p "${bblue}System${reset}: Generating Resolvers..."

  if [[ "${generate_resolvers}" = true ]]; then
    eval dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 200 -o resolvers.txt.tmp ${nullout}
    eval dnsvalidator -tL https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt -threads 200 -o resolvers.txt.tmp ${nullout}
    eval cat resolvers.txt.tmp | anew -q resolvers.txt
    eval rm -f resolvers.txt.tmp
  else
    eval wget -q -O ${tools}/resolvers.txt https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt
  fi

  log_info -d
}

function install_axiom() {
  log_info -p "${bblue}System${reset}: Cloning Axiom..."
  axiom_url='https://github.com/pry0cc/axiom.git'
  eval git clone --depth 1 ${axiom_url} ${HOME}/.axiom ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to clone Axiom"; }
  touch ${HOME}/.axiom/axiom.json
  touch ${HOME}/.axiom/interact/includes/functions.sh
  log_info -d
}

function install_last_steps() {
  log_info -p "${bblue}System${reset}: Installation last steps..."
  eval nuclei -update-templates ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to update nuclei templates"; }
  eval h8mail -g ${nullout}; [[ $? != 0 ]] && { log_info -e; log_crt "Failed to generate h8mail config"; }
  eval mv h8mail_config.ini -t ${tools}
  log_info -d
}

function clean_up() {
  local _dirs=(
    "/var/lib/apt/lists"
    "/var/cache"
    "/var/log"
    "/tmp"
  )

  log_info -p "${bblue}System${reset}: Running clean up..."

  eval apt update ${nullout}
  eval apt autoremove -y ${nullout}
  eval apt clean all ${nullout}
  for dir in "${_dirs[@]}"; do
    eval find ${dir} -type f -delete ${nullout}
    eval find ${dir} -mindepth 1 -type d -delete ${nullout}
  done

  log_info -d
}

#-> Configure the working directory
eval cd -- "${0%/*}" 2>&1 > /dev/null

#-> Source dependencies
source grond.cfg
source logger.sh
source tools.sh

#-> Call function passed in args
test "$(declare -F $1)" && "$@" || :
