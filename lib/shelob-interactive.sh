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
  __log_prefix "emergency" | red_bg yellow bold underline >&2
  printf " " >&2
  printf "%s" "$@" | red bold underline >&2
  printf "\n" >&2
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

function ask_yes_no(){
    local question=${1:-}
    local default_answer=${2:-invalid}
    local yes="Y y"
    local no="N n"
    local alternate="n"
    local response="invalid"
    local prompt

    if [[ "$yes" =~ $default_answer ]]; then
      default_answer="Y"
    elif [[ "$no" =~ $default_answer ]]; then
      default_answer="N"
    else
      warning "The default answer: $default_answer is invalid. Setting default answer as Y"
      default_answer="Y"
    fi

    [[ "$no" =~ $default_answer ]] && alternate="y" || alternate="n"

    prompt="$question (${default_answer}/${alternate})> "

    if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
      debug "Answer all flag is set, answering $default_answer"
      echo "${prompt}$default_answer" |  blue | bold
    else
      while [[ ! $no =~ $response ]] && \
            [[ ! $yes =~ $response ]] && \
            [[ "$response" != "" ]];
      do
          printf "%s" "${prompt}" |  blue | bold
          read -r response
          debug "Reponse $response"
      done
    fi

    if [[ "$response" = "" ]]; then
      debug "Response is empty, using default answer"
      response="$default_answer";
    fi

    [[ $yes =~ $response ]]
}

function ask_input() {
    local variable_name=${1:-}
    local __response=
    if [[ -z $variable_name ]]; then
      error "Missing variable name"
      info "Usage: ask_input <variable-name> <prompt> [default-input]"
      return 1
    fi
    local prompt=${2:-}
    local default_input=${3:-}
    if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
      debug "Answer all flag is set, using default input: $default_input"
      printf -v "$variable_name" "%s" "$default_input"
      return 0
    else
      printf "%s" "$prompt [${default_input}]> " |  blue | bold
      read -r __response
    fi
    debug "Response: $__response"
    if [[ "$__response" = "" ]]; then
      debug "Response is empty, using default input $default_input"
      __response="$default_input";
    fi
    printf -v "$variable_name" "%s" "$__response"
}

function ask_input_required() {
    local variable_name=${1:-}
    ask_input "$@"
    while [[ -z ${!variable_name} ]]; do
      if [[ ${SHELOB_ANSWER_ALL:-} = true ]]; then
        error "There is no default input, can not auto answer"
        return 1
      fi
      ask_input "$@"
    done
}

function ask_option() {
    local variable_name=${1:-}
    local prompt=${2:-}
    IFS=',' read -ra options <<< "${3:-}"
    debug "Number of options: ${#options[@]}"
    local __default_answer=${4:-}
    local __answer=
    local selected_option=

    if [[ -z $variable_name ]]; then
      error "Missing variable name"
      info "Usage: ask_option <variable-name> <description> <option-list> [default-option]"
      return 1
    fi

    if [[ ${#options[@]} -eq 0 ]]; then
      error "No option given, options must be a comma separated list"
      info "Usage: ask_option <variable-name> <description> <option-list> [default-option]"
      return 1
    fi

    echo "$prompt" |  blue | bold
    let count=1
    for option in "${options[@]}"; do
      echo "$count) $option" |  blue | bold
      count=$((count+1))
    done
    while [[ -z ${selected_option} ]]; do
      ask_input_required selected_option "Select an option" "$__default_answer"
      if [[ $selected_option =~ ^[0-9]+$ ]] && \
         [[ $selected_option -le ${#options[@]} ]] && \
         [[ $selected_option -gt 0 ]]; then
         selected_option=$((selected_option-1)) # Adjust reponse as array index is 0-based
         __answer=${options[$selected_option]}
       else
         selected_option= # Clear invalid selection
      fi
    done

    debug "Selected answer: $__answer"
    printf -v "$variable_name" "%s" "$__answer"
}

