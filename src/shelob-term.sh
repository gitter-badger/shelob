#!/usr/bin/env bash


# number of colors supported
__shelob_colors=$(tput colors 2> /dev/null)

#######################################
# Test if stdout is connected to tty.
# If this this command is piped to another command or is redirected to
# a file the test will fail returning 1 indicating stoud is not an interactive
# terminal.
#
# Globals:
#    __TEST_TERMINAL_CONNECTED (RO) : If true tty is assumed to be connected
#                                     set true for testing
# Arguments:
#   None
# Returns:
#   0  : If stdout is connected to terminal
#   1  : If stdout is piped or redirected to a non-terminal output target
# Output:
#   None
#######################################
function terminal_connected() {
  # Check special variable __TEST_TERMINAL for automated test scripts to
  # test code properly
  if [[ ${__TEST_TERMINAL_CONNECTED:-} = true ]]; then
    return 0
  fi
  [[ -t 1 ]]
}



#######################################
# Returns number of colors current terminal supports.
#
# Globals:
#    __shelob_colors (RO) : Number of colors terminal supports
# Arguments:
#   None
# Returns:
#   0
# Output:
#   Number of colours
#######################################
function number_of_colors() {
  echo "$__shelob_colors"
}


#######################################
# Test if terminal supports at least two colors
#
# Globals:
#  __shelob_colors (RO) : Number of colors terminal supports
# Arguments:
#   None
# Returns:
#   0  : If terminal supports at least 2 colors
#   1  : If terminal does not support colors or number of colors supported
#        are less then 2
# Output:
#   None
#######################################
function has_color2() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 2 ]]
}



#######################################
# Test if terminal supports at least eight colors
#
# Globals:
#  __shelob_colors (RO) : Number of colors terminal supports
# Arguments:
#   None
# Returns:
#   0  : If terminal supports at least 8 colors
#   1  : If terminal does not support colors or number of colors supported
#        are less then 8
# Output:
#   None
#######################################
function has_color8() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 8 ]]
}


#######################################
# Test if terminal supports at least sixteen colors
#
# Globals:
#  __shelob_colors (RO) : Number of colors terminal supports
# Arguments:
#   None
# Returns:
#   0  : If terminal supports at least 16 colors
#   1  : If terminal does not support colors or number of colors supported
#        are less then 16
# Output:
#   None
#######################################
function has_color16() {
  [[ -n $__shelob_colors ]] && [[ $__shelob_colors -ge 16 ]]
}
