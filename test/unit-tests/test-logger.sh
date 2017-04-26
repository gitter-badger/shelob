#!/usr/bin/env bash
# shelcheck disable=SC2154,SC1083,SC2119,SC2168

source lib/shelob-colors.sh
source lib/shelob-logger.sh

test_emergency_should_be_formatted_accordingly_and_exit() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red_bg}${__yellow}${__bold}${__underline}[emergency]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${__red}${__bold}${__underline}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"
  local output
  output=$(emergency "$message" 2>&1)
  assertFalse $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_alert_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red_bg}${__yellow}[alert]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s" "${__red}${__bold}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(alert "$message" 2>&1)
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_critical_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red}${__underline}${__bold}[critical]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${__red}${message}${__reset}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(critical "$message" 2>&1)
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_error_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__red}${__bold}[error]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(error "$message" 2>&1)
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_warning_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__yellow}${__bold}[warning]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(warning "$message" 2>&1)
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_notice_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__blue}${__bold}[notice]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(notice "$message")
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_info_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  local message="Hello"
  local formatted_prefix="${__green}[info]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(info "$message")
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_debug_should_be_formatted_accordingly() {
  __TEST_TERMINAL_CONNECTED=true
  SHELOB_LOG_LEVEL=7
  local message="Hello"
  local formatted_prefix="${__cyan_bg}${__black}[debug]:${__reset}"
  local formatted_message
  formatted_message="$(printf " %s\n" "${message}")"
  local expected="${formatted_prefix}${formatted_message}"

  local output
  output=$(debug "$message")
  assertTrue $?
  assertEquals "$expected" "$output"
  unset __TEST_TERMINAL_CONNECTED
}

test_only_output_enabled_log_level() {
  SHELOB_LOG_LEVEL=3
  local output
  output=$(info "Info")
  assertTrue $?
  [[ ! $output =~ .*Info.* ]]
  assertTrue $?
  SHELOB_LOG_LEVEL=6
  output=$(info "Info")
  assertTrue $?
  [[ $output =~ .*Info.* ]]
  assertTrue $?
}

test_do_not_output_colors_with_no_tty_connected() {
  local expected
  expected="$(printf "[info]: Info\n")"
  local output
  output=$(info "Info")
  assertTrue $?
  assertEquals "$expected" "$output"
}

# @test "Should print timestamp when enabled" {
#   SHELOB_LOG_TIMESTAMP=true
#   local expected_pattern=$'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} UTC \[info\]: Info$'
#   run info "Info"
#   echo "Output:" "$output"
#   echo "Expected pattern:" "$expected_pattern"
#   [[ $status -eq 0 ]]
#   [[ $output =~ $expected_pattern  ]]
# }
#
# @test "Should handle multiple lines correctly" {
# #Trailing new lines are cleared and a single new line at the end is ensured
# local input=$(cat << EOF
# this
# is
# a
# multiline
# text
#
#
# EOF
# )
#
# local expected="$(printf "[error]: this\nis\na\nmultiline\ntext\n")"
# run error "$input"
# echo "Output:" "$output"
# echo "Expected:" "$expected"
# [[ $output = "$expected" ]]
# }
#

source utils/shunit2
