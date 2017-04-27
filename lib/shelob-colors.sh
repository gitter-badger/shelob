#!/usr/bin/env bash

__shelob_colors=$(tput colors 2> /dev/null) || __shelob_colors=0

function terminal_connected() {
  if [[ ${__TEST_TERMINAL_CONNECTED:-} = true ]]; then
    return 0
  fi
  [[ -t 1 ]]
}

function number_of_colors() {
  echo "$__shelob_colors"
}

function has_color2() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 2 ]]
}

function has_color8() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 8 ]]
}

function has_color16() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 16 ]]
}

__black="$(tput setaf 0 2> /dev/null )" || __black=''
__red="$(tput setaf 1 2> /dev/null)" || __red=''
__green="$(tput setaf 2 2> /dev/null)" || __green=''
__yellow="$(tput setaf 3 2> /dev/null)" || __yellow=''
__blue="$(tput setaf 4 2> /dev/null)" || __blue=''
__magenta="$(tput setaf 5 2> /dev/null)" || __magenta=''
__cyan="$(tput setaf 6 2> /dev/null)" || __cyan=''
__white="$(tput setaf 7 2> /dev/null)" || __white=''

__black_bg="$(tput setab 0 2> /dev/null)" || __black_bg=''
__red_bg="$(tput setab 1 2> /dev/null)" || __red_bg=''
__green_bg="$(tput setab 2 2> /dev/null)" || __green_bg=''
__yellow_bg="$(tput setab 3 2> /dev/null)" || __yellow_bg=''
__blue_bg="$(tput setab 4 2> /dev/null)" || __blue_bg=''
__magenta_bg="$(tput setab 5 2> /dev/null)" || __magenta_bg=''
__cyan_bg="$(tput setab 6 2> /dev/null)" || __cyan_bg=''
__white_bg="$(tput setab 7 2> /dev/null)" || __white_bg=''

__reset="$(tput sgr0 2> /dev/null)" || __reset=''
__bold="$(tput bold 2> /dev/null)" || __bold=''
__underline="$(tput smul 2> /dev/null)" || __underline=''

function colors_enabled() {
  local color=${SHELOB_COLOR:-auto}
  if [[ $color = 'never' ]]; then
    return 1
  elif [[ $color = 'always' ]]; then
    return 0
  else
    terminal_connected && has_color8
  fi
}

function __format() {
  local format="$1"
  local next="${2:-}" # next formatting function e.g. underline
  if colors_enabled; then
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
