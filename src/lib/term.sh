#!/usr/bin/env bash

function terminal_connected() {
  # Check special variable __TEST_TERMINAL for automated test scripts to
  # test code properly
  if [[ ${__TEST_TERMINAL_CONNECTED:-} = true ]]; then
    return 0
  fi
  [[ -t 1 ]]
}

function number_of_colors() {
  tput colors 2> /dev/null
}
