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
