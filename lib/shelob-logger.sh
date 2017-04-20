#!/usr/bin/env bash

function terminal_connected() {
  if [[ ${__TEST_TERMINAL_CONNECTED:-} = true ]]; then
    return 0
  fi
  [[ -t 1 ]]
}

function number_of_colors() {
  tput colors 2> /dev/null
}

__colors=$(number_of_colors)

__black="$(tput setaf 0)"
__red="$(tput setaf 1)"
__green="$(tput setaf 2)"
__yellow="$(tput setaf 3)"
__blue="$(tput setaf 4)"
__magenta="$(tput setaf 5)"
__cyan="$(tput setaf 6)"
__white="$(tput setaf 7)"

__black_bg="$(tput setab 0)"
__red_bg="$(tput setab 1)"
__green_bg="$(tput setab 2)"
__yellow_bg="$(tput setab 3)"
__blue_bg="$(tput setab 4)"
__magenta_bg="$(tput setab 5)"
__cyan_bg="$(tput setab 6)"
__white_bg="$(tput setab 7)"

__reset="$(tput sgr0)"
__bold="$(tput bold)"
__underline="$(tput smul)"

function has_colors() {
  local color=${SHELOB_COLOR:-auto}
  if [[ $color = 'never' ]]; then
    return 1
  elif [[ $color = 'always' ]]; then
    return 0
  else
    terminal_connected && [[ -n $__colors ]] && [[ $__colors -ge 8 ]]
  fi
}

function __format() {
  local format="$1"
  local next="${2:-}" # next formatting function e.g. underline
  if has_colors; then
    printf "%s" "$format"
    if [[ -n $next ]]; then
      shift 2
      tee | "$next" "$@"
    else
      tee
      printf "%s" "$__reset"
    fi
  else
    tee #print output
  fi
}

function black() { __format "$__black" "$@"; }
function red() { __format "$__red" "$@"; }
function green() { __format "$__green" "$@";}
function yellow() { __format "$__yellow" "$@"; }
function blue() { __format "$__blue" "$@"; }
function magenta() { __format "$__magenta" "$@";}
function cyan() { __format "$__cyan"  "$@";}
function white() { __format "$__white"  "$@";}

function black_bg() { __format "$__black_bg" "$@"; }
function red_bg() { __format "$__red_bg" "$@"; }
function green_bg() { __format "$__green_bg" "$@";}
function yellow_bg() { __format "$__yellow_bg" "$@"; }
function blue_bg() { __format "$__blue_bg" "$@"; }
function magenta_bg() { __format "$__magenta_bg" "$@";}
function cyan_bg() { __format "$__cyan_bg"  "$@";}
function white_bg() { __format "$__white_bg"  "$@";}

function bold() { __format "$__bold"  "$@";}
function underline() { __format "$__underline" "$@"; }

SHELOB_LOG_LEVEL="${SHELOB_LOG_LEVEL:-6}"
function __log_prefix() {
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
  __log_prefix "alert" | red_bg yellow >&2
  printf " " >&2
  printf "%s" "$@" | red bold >&2
  printf "\n" >&2
}

function critical(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 2 ]]; then return; fi
  __log_prefix "critical" | red underline bold >&2
  printf " " >&2
  printf "%s" "$@" | red >&2
  printf "\n" >&2
}

function error(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 3 ]]; then return; fi
  __log_prefix "error" | red bold >&2
  printf " " >&2
  printf "%s" "$@" >&2
  printf "\n" >&2
}

function warning(){
  if [[ ${SHELOB_LOG_LEVEL} -lt 4 ]]; then return; fi
  __log_prefix "warning" | yellow bold >&2
  printf " " >&2
  printf "%s" "$@" >&2
  printf "\n" >&2
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

