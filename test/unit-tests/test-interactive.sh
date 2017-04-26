#!/usr/bin/env bash
# shellcheck disable=SC2154

source lib/shelob-interactive.sh

test_use_default_yes_no_answer() {
  ask_yes_no "Hello" "n" <<< ""
  assertFalse $?
  ask_yes_no "Hello" "y" <<< ""
  assertTrue $?
}

test_return_success_if_answered_yes() {
  ask_yes_no "Hello" "n" <<< "Y"
  assertTrue $?
  ask_yes_no "Hello" "n" <<< "y"
  assertTrue $?
}

test_return_failure_if_answered_no() {
  ask_yes_no "Hello" "Y" <<< "N"
  assertFalse $?
  ask_yes_no "Hello" "Y" <<< "n"
  assertFalse $?
}


test_use_yes_with_no_default_answer() {
  ask_yes_no "Hello" <<< ""
  assertTrue $?
}

test_ask_again_if_answer_is_invalid() {
  local output
  output=$(ask_yes_no "Hello" <<< "Hi")
  [[ $output =~ Hello.*Hello ]]
  assertTrue $?
}

test_use_default_input_if_no_input_given() {
  ask_input "testvar" "Hello" "Hi" <<< ""
  assertEquals "Hi" "$testvar"
}

test_use_given_input() {
  export SHELOB_LOG_LEVEL=6
  ask_input "testvar" "Hello" "Hi" <<< "Howdy"
  assertEquals "Howdy" "$testvar"
}

test_work_without_default_input() {
  export SHELOB_LOG_LEVEL=6
  ask_input testvar "Hello" <<< ""
  assertEquals "" "$testvar"
}

test_fail_if_no_variable_name_given() {
  export SHELOB_LOG_LEVEL=6
  ask_input <<< ""
  assertFalse $?
}

source utils/shunit2
