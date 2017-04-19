#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1083,SC2119,SC2168
set -eo pipefail
IFS=$'\n\t'

source lib/colors.sh
source lib/logger.sh

@test "Emergency should be formatted accordingly and exit" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red_bg}${__yellow}${__bold}${__underline}[emergency]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${__red}${__bold}${__underline}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"
  run emergency "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 1 ]]
  [[ $output = "$expected" ]]
}

@test "Alert should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red_bg}${__yellow}[alert]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s" "${__red}${__bold}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"
  run alert "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Critical should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red}${__underline}${__bold}[critical]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${__red}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"
  run critical "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Error should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red}${__bold}[error]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"
  run error "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Warning should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__yellow}${__bold}[warning]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"
  run warning "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Notice should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__blue}${__bold}[notice]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"
  run notice "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Info should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__green}[info]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"
  run info "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Debug should be formatted accordingly" {
  __TEST_TERMINAL_CONNECTED=true
  SHELOB_LOG_LEVEL=7
  local message="Hello"
  local formatted_prefix="${__cyan_bg}${__black}[debug]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"
  run debug "$message"

  echo "Expected:" "$expected"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected" ]]
}

@test "Should only output enabled log level" {
  SHELOB_LOG_LEVEL=3
  run info "Info"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ ! $output =~ .*Info.* ]]
  SHELOB_LOG_LEVEL=6
  run info "Info"
  echo "Output:" "$output"
  [[ $output =~ .*Info.* ]]
}

@test "Should not output colors with no tty connected" {
  local expected="$(printf "[info]: Info\n")"
  run info "Info"
  echo "Output:" "$output"
  [[ $status -eq 0 ]]
  [[ $output = "$expected"  ]]
}

@test "Should print timestamp when enabled" {
  SHELOB_LOG_TIMESTAMP=true
  local expected_pattern=$'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} UTC \[info\]: Info$'
  run info "Info"
  echo "Output:" "$output"
  echo "Expected pattern:" "$expected_pattern"
  [[ $status -eq 0 ]]
  [[ $output =~ $expected_pattern  ]]
}

@test "Should handle multiple lines correctly" {
#Trailing new lines are cleared and a single new line at the end is ensured
local input=$(cat << EOF
this
is
a
multiline
text


EOF
)

local expected="$(printf "[error]: this\nis\na\nmultiline\ntext\n")"
run error "$input"
echo "Output:" "$output"
echo "Expected:" "$expected"
[[ $output = "$expected" ]]
}
