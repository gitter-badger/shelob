#!/usr/bin/env bash
# shellcheck disable=2119
source lib/shelob-colors.sh

test_format_when_terminal_is_connected() {
  __TEST_TERMINAL_CONNECTED=true
  local output
  output="$(printf "test" | black)"
  assertEquals "${__black}test${__reset}" "$output"
  output="$(printf "test" | red)"
  assertEquals "${__red}test${__reset}" "$output"
  output="$(printf "test" | green)"
  assertEquals "${__green}test${__reset}" "$output"
  output="$(printf "test" | yellow)"
  assertEquals "${__yellow}test${__reset}" "$output"
  output="$(printf "test" | blue)"
  assertEquals "${__blue}test${__reset}" "$output"
  output="$(printf "test" | magenta)"
  assertEquals "${__magenta}test${__reset}" "$output"
  output="$(printf "test" | cyan)"
  assertEquals "${__cyan}test${__reset}" "$output"
  output="$(printf "test" | white)"
  assertEquals "${__white}test${__reset}" "$output"
  output="$(printf "test" | black_bg)"
  assertEquals "${__black_bg}test${__reset}" "$output"
  output="$(printf "test" | green_bg)"
  assertEquals "${__green_bg}test${__reset}" "$output"
  output="$(printf "test" | yellow_bg)"
  assertEquals "${__yellow_bg}test${__reset}" "$output"
  output="$(printf "test" | blue_bg)"
  assertEquals "${__blue_bg}test${__reset}" "$output"
  output="$(printf "test" | magenta_bg)"
  assertEquals "${__magenta_bg}test${__reset}" "$output"
  output="$(printf "test" | cyan_bg)"
  assertEquals "${__cyan_bg}test${__reset}" "$output"
  output="$(printf "test" | white_bg)"
  assertEquals "${__white_bg}test${__reset}" "$output"
  output="$(printf "test" | bold)"
  assertEquals "${__bold}test${__reset}" "$output"
  output="$(printf "test" | underline)"
  assertEquals "${__underline}test${__reset}" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_format_with_multiple_formats() {
  __TEST_TERMINAL_CONNECTED=true

  local output
  output="$(printf "test" | black underline)"
  assertEquals "${__black}${__underline}test${__reset}" "$output"
  output="$(printf "test" | underline red)"
  assertEquals "${__underline}${__red}test${__reset}" "$output"
  output="$(printf "test" | red bold underline)"
  assertEquals "${__red}${__bold}${__underline}test${__reset}" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_format_in_given_order() {
  __TEST_TERMINAL_CONNECTED=true

  local output
  output="$(printf "test" | underline black bold)"
  assertEquals "${__underline}${__black}${__bold}test${__reset}" "$output"
  assertNotSame "${__black}${__bold}${__underline}test${__reset}" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

function __multiple_lines() {
  cat << EOF
  Multiple
  Lines
EOF
}

test_format_multiple_lines() {
  __TEST_TERMINAL_CONNECTED=true
  local output
  local outputsum
  local expectedsum
  local text

  text="$(__multiple_lines)"

  output="$(printf "%s" "$text" | underline black bold)"

  expectedsum="$(printf "%s" "${__underline}${__black}${__bold}$text${__reset}" | md5sum )"
  outputsum="$(printf "%s" "$output" | md5sum )"

  [[ $outputsum = "$expectedsum" ]]

  unset __TEST_TERMINAL_CONNECTED
}

test_not_format_when_output_is_not_tty() {
  # test in a subshell
  output="$(printf "test" | red)"; \
    [[ $output = "test" ]]
}

source utils/shunit2
