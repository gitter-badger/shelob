#shellcheck shell=bash
#
# A set of utility functions to format text
#
# Format functions are meant to be used as pipes.
# This library uses tput to get color information. If tput is not available
# no colors will be printed
# e.g.
#  echo "Hello" | green bold underlined
# or
#  echo "Hello" | red blue_bg
# etc.

include "shelob-term.sh"


# foreground colors
__black="$(tput setaf 0 2> /dev/null )" || __black=''
__red="$(tput setaf 1 2> /dev/null)" || __red=''
__green="$(tput setaf 2 2> /dev/null)" || __green=''
__yellow="$(tput setaf 3 2> /dev/null)" || __yellow=''
__blue="$(tput setaf 4 2> /dev/null)" || __blue=''
__magenta="$(tput setaf 5 2> /dev/null)" || __magenta=''
__cyan="$(tput setaf 6 2> /dev/null)" || __cyan=''
__white="$(tput setaf 7 2> /dev/null)" || __white=''

# background colors
__black_bg="$(tput setab 0 2> /dev/null)" || __black_bg=''
__red_bg="$(tput setab 1 2> /dev/null)" || __red_bg=''
__green_bg="$(tput setab 2 2> /dev/null)" || __green_bg=''
__yellow_bg="$(tput setab 3 2> /dev/null)" || __yellow_bg=''
__blue_bg="$(tput setab 4 2> /dev/null)" || __blue_bg=''
__magenta_bg="$(tput setab 5 2> /dev/null)" || __magenta_bg=''
__cyan_bg="$(tput setab 6 2> /dev/null)" || __cyan_bg=''
__white_bg="$(tput setab 7 2> /dev/null)" || __white_bg=''

# style
__reset="$(tput sgr0 2> /dev/null)" || __reset=''
__bold="$(tput bold 2> /dev/null)" || __bold=''
__underline="$(tput smul 2> /dev/null)" || __underline=''



#######################################
# Determine if colors enabled/disabled or supported using SHELOB_COLOR
# environment variable
#
# Globals:
#    SHELOB_COLOR (RO) : enable colors? options: always/never/auto[default]
# Arguments:
#   None
# Returns:
#   0  : If colors should be outputted
#   1  : If colors should NOT be outputted
# Output:
#   None
#######################################
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


#######################################
# Format input using given color or style escape code.
# Calls next styling function which calls back format again for stylinn
# recursively.
#
# e.g. echo "Hello" | __format $__red blue
#
# Globals:
#   None
# Arguments:
#   format ($1) : Color/style code to output.
#   next ($2)   : Next formatting function to call
# Returns:
#   0
# Output:
#   Formatted input
#######################################
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


#######################################
# Format functions. Designed to be used as next pipe to format and output
# as needed.
#
# e.g.
#   echo "Hello" | red underline bold blue_bg
# will output Hello in red, underlined and bold on a blue background.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0  : If successful
#   1  : If failure
# Output:
#   None
#######################################
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
