#!/usr/bin/env bash

include "colors.sh"

SHELOB_LOG_LEVEL="${SHELOB_LOG_LEVEL:-6}"
function __log_prefix() {
  # do not print timestamp if outputs to tty
  # piping and redirecting will output timestamp
  local timestamp
  if [[  ${SHELOB_LOG_TIMESTAMP:-false} = true ]]; then
    timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    printf "%s [%s]:" "$timestamp" "${1}"
  else
    printf "[%s]:" "${1}"
  fi
}

function emergency(){
  __log_prefix "emergency" | red_bg yellow bold underline
  printf " "
  printf "%s" "$@" | red bold underline
  printf "\n"
  exit 1
}


function alert(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 1 ]]; then return; fi
  __log_prefix "alert" | red_bg yellow
  printf " "
  printf "%s" "$@" | red bold
  printf "\n"
}

function critical(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 2 ]]; then return; fi
  __log_prefix "critical" | red underline bold
  printf " "
  printf "%s" "$@" | red
  printf "\n"
}

function error(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 3 ]]; then return; fi
  __log_prefix "error" | red bold
  printf " "
  printf "%s" "$@"
  printf "\n"
}

function warning(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 4 ]]; then return; fi
  __log_prefix "warning" | yellow bold
  printf " "
  printf "%s" "$@"
  printf "\n"
}

function notice(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 5 ]]; then return; fi
  __log_prefix "notice" | blue bold
  printf " "
  printf "%s" "$@"
  printf "\n"
}

function info(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 6 ]]; then return; fi
  __log_prefix "info" | green
  printf " "
  printf "%s" "$@"
  printf "\n"
}

function debug(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 7 ]]; then return; fi
  __log_prefix "debug" | cyan_bg black
  printf " "
  printf "%s" "$@"
  printf "\n"
}

