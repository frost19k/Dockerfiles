#!/usr/bin/env bash

tools_check() {
  declare -a not_installed
  local count=0

  #-> iterate over the keys of the gotools associative array
  for tool in "${!gotools[@]}"; do
    if command -v "${tool}" >/dev/null 2>&1; then
      continue
    else
      let count++
      not_installed+=( "${tool}" )
    fi
  done

  #-> iterate over the keys of the repos associative array
  for tool in "${!repos[@]}"; do
    if command -v "${tool}" >/dev/null 2>&1 || [[ -d "${tools}/${tool}" ]]; then
      continue
    else
      let count++
      not_installed+=( "${tool}" )
    fi
  done

  #-> check for tools installed by install_ot_tools
  ot_tools=("trufflehog" "unimap" "ppfuzz" "searchsploit" "nrich" "packer")
  for tool in "${ot_tools[@]}"; do
    if command -v "${tool}" >/dev/null 2>&1; then
      continue
    else
      let count++
      not_installed+=( "${tool}" )
    fi
  done

  if [[ ${count} != 0 ]]; then
    log_err "The following tools are not installed"
    for tool in "${not_installed[@]}"; do
      log_info "${yellow}${tool}${reset}"
    done
  else
    log_info "All tools installed"
  fi
}

#-> Configure the working directory
eval cd -- "${0%/*}" 2>&1 > /dev/null

#-> Source dependencies
source grond.cfg
source logger.sh
source tools.sh

#-> Call the function
tools_check