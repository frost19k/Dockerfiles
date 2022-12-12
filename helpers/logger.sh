#!/usr/bin/env bash

function log_crt() {
  local script_name="$1"
  local line_num="$2"
  local message="$3"
  printf "$(date +'%H:%M:%S') ⋞ 💥 ⋟ ${b_red}${message} (${script_name}:${line_num}) \b${reset}\n" | tee -a ${logfile} >&2
  exit 1
}

function log_err() {
  local script_name=$1
  local line_num=$2
  local message=$3
  printf "$(date +'%H:%M:%S') ⋞ 💢 ⋟ ${b_red}${message} (${script_name}:${line_num}) \b${reset}\n" | tee -a ${logfile} >&2
}

function log_warn() {
  local message=$1
  local log_header=$2
  if [[ -n ${log_header} ]]; then
    printf "$(date +'%H:%M:%S') ⋞ 💣 ⋟ ${log_header} ${yellow}${message} \b${reset}\n" | tee -a ${logfile} >&1
  else
    printf "$(date +'%H:%M:%S') ⋞ 💣 ⋟ ${yellow}${message} \b${reset}\n" | tee -a ${logfile} >&1
  fi
}

function log_info() {
  [[ $1 == '-p' ]] && { message=$2 && newline=''; } || { message=$1 && newline='\n'; }
  [[ $1 == '-d' ]] && { printf "[${green}Done${reset}]\n"; return; }
  [[ $1 == '-e' ]] && { printf "[${red}Error${reset}]\n"; return; }
  printf "$(date +'%H:%M:%S') ⋞ 💬 ⋟ ${message} \b${reset}${newline}" | tee -a ${logfile} >&1
}

function wait() {
  local wait=$1
  while [[ ${wait} -gt 0 ]]; do
    echo -ne " ${white}Pausing for ${wait} seconds before proceeding...${reset}\033[0K\r"
    sleep 1s
    : $((wait--))
  done
}

nullout='> /dev/null 2>&1'
