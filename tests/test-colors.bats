#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1083,SC2119,SC2168
set -eo pipefail
IFS=$'\n\t'

source lib/colors.sh

@test "Should output formatted when terminal is connected" {
  __TEST_TERMINAL_CONNECTED=true
  local output
  output="$(printf "test" | black)"; \
    [[ $output = "${__black}test${__reset}" ]]
  output="$(printf "test" | red)"; \
    [[ $output = "${__red}test${__reset}" ]]
  output="$(printf "test" | green)"; \
    [[ $output = "${__green}test${__reset}" ]]
  output="$(printf "test" | yellow)"; \
    [[ $output = "${__yellow}test${__reset}" ]]
  output="$(printf "test" | blue)"; \
    [[ $output = "${__blue}test${__reset}" ]]
  output="$(printf "test" | magenta)"; \
    [[ $output = "${__magenta}test${__reset}" ]]
  output="$(printf "test" | cyan)"; \
    [[ $output = "${__cyan}test${__reset}" ]]
  output="$(printf "test" | white)"; \
    [[ $output = "${__white}test${__reset}" ]]

  output="$(printf "test" | black_bg)"; \
    [[ $output = "${__black_bg}test${__reset}" ]]
  output="$(printf "test" | green_bg)"; \
    [[ $output = "${__green_bg}test${__reset}" ]]
  output="$(printf "test" | yellow_bg)"; \
    [[ $output = "${__yellow_bg}test${__reset}" ]]
  output="$(printf "test" | blue_bg)"; \
    [[ $output = "${__blue_bg}test${__reset}" ]]
  output="$(printf "test" | magenta_bg)"; \
    [[ $output = "${__magenta_bg}test${__reset}" ]]
  output="$(printf "test" | cyan_bg)"; \
    [[ $output = "${__cyan_bg}test${__reset}" ]]
  output="$(printf "test" | white_bg)"; \
    [[ $output = "${__white_bg}test${__reset}" ]]

  output="$(printf "test" | bold)"; \
    [[ $output = "${__bold}test${__reset}" ]]
  output="$(printf "test" | underline)"; \
    [[ $output = "${__underline}test${__reset}" ]]
}

@test "Should output formatted when multiple formats applied" {
  __TEST_TERMINAL_CONNECTED=true

  local output
  output="$(printf "test" | black underline)"; \
    [[ $output = "${__black}${__underline}test${__reset}" ]]
  output="$(printf "test" | underline red)"; \
    [[ $output = "${__underline}${__red}test${__reset}" ]]
  output="$(printf "test" | red bold underline)"; \
    [[ $output = "${__red}${__bold}${__underline}test${__reset}" ]]
}

@test "Should format in given order" {
  __TEST_TERMINAL_CONNECTED=true

  local output
  output="$(printf "test" | underline black bold)"; \
    [[ $output = "${__black}${__bold}${__underline}test${__reset}" ]] && \
       exit 1 || true
}

function __multiple_lines() {
  cat << EOF
  Multiple
  Lines
EOF

}

@test "Should output multiple lines formatted" {
  __TEST_TERMINAL_CONNECTED=true
  local output
  local outputsum
  local expectedsum
  local text

  text="$(__multiple_lines)"

  output="$(printf "$text" | underline black bold)"

  expectedsum="$(printf "${__underline}${__black}${__bold}$text${__reset}" | md5sum )"
  outputsum="$(printf "$output" | md5sum )"

  [[ $outputsum = "$expectedsum" ]]

}

@test "Should not output formatted with redirections and pipes and not tty" {
 # test in a subshell
  output="$(printf "test" | red)"; \
    [[ $output = "test" ]]
}


