#!/usr/bin/env bash

include "colors.sh"

function __log_prefix() {
  # do not print timestamp if outputs to tty
  # piping and redirecting will output timestamp
  local timestamp
  timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
  printf "%s [%s]" "$timestamp" "${1}"
}

function info(){
  __log_prefix "info" | blue
  echo -en "$@"
}

function emergency() {
  __log H
}


