#!/usr/bin/env bash

function log_crt() {
  local message=$1
  printf "$(date +'%H:%M:%S') ⋞ 💥 ⋟ ${bred}${message} (${BASH_SOURCE[$i+1]##*/}:${BASH_LINENO[$i]}) \b${reset}\n" >&2
  exit 1
}

function log_err() {
  local message=$1
  printf "$(date +'%H:%M:%S') ⋞ 💢 ⋟ ${bred}${message} (${BASH_SOURCE[$i]##*/}:${BASH_LINENO[$i]}) \b${reset}\n" >&2
}

function log_warn() {
  local message=$1
  printf "$(date +'%H:%M:%S') ⋞ 💣 ⋟ ${yellow}${message} \b${reset}\n"
}

function log_info() {
  [[ $1 == '-p' ]] && { message=$2 && newline=''; } || { message=$1 && newline='\n'; }
  [[ $1 == '-d' ]] && { printf "[${green}Done${reset}]\n"; return; }
  [[ $1 == '-e' ]] && { printf "[${red}Error${reset}]\n"; return; }
  printf "$(date +'%H:%M:%S') ⋞ 💬 ⋟ ${message} \b${reset}${newline}"
}

###>> Something pretty to look at if you have to wait...
function wait() {
  local wait=$1
  while [[ ${wait} -gt 0 ]]; do
    echo -ne " ${white}Pausing for ${wait} seconds before proceeding...${reset}\033[0K\r"
    sleep 1s
    : $((wait--))
  done
}
