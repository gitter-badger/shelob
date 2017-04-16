#!/usr/bin/env bash

__colors=$(tput colors 2> /dev/null)

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
  COLOR=${COLOR:-auto}
  if [[ $COLOR = 'never' ]]; then
    return 1
  elif [[ $COLOR = 'always' ]]; then
    return 0
  else
    [[ -t 1 ]] && [[ -n $__colors ]] && [[ $__colors -ge 8 ]]
  fi
}

function __format() {
  local format="$1"
  local next="${2:-}" # next formatting function e.g. underline
  if has_colors; then
    echo -en "$format"
    if [[ -n $next ]]; then
      shift 2
      tee | "$next" "$@"
    else
      tee
      echo -en "$__reset"
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

