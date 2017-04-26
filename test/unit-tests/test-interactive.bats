#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1083,SC2119,SC2168
set -eo pipefail
IFS=$'\n\t'

source lib/shelob-interactive.sh

@test "Should use default answer if yes no answer not given" {
  run ask_yes_no "Hello" "n" <<< ""
  echo "$output"
  [[ $status -eq 1 ]]
  run ask_yes_no "Hello" "y" <<< ""
  [[ $status -eq 0 ]]
}

@test "Should return success if answered yes" {
  run ask_yes_no "Hello" "n" <<< "Y"
  [[ $status -eq 0 ]]
  run ask_yes_no "Hello" "n" <<< "y"
  [[ $status -eq 0 ]]
}

@test "Should return failure if answered no" {
  run ask_yes_no "Hello" "Y" <<< "N"
  [[ $status -eq 1 ]]
  run ask_yes_no "Hello" "Y" <<< "n"
  [[ $status -eq 1 ]]
}


@test "Should use yes as default value if not supplied" {
  run ask_yes_no "Hello" <<< ""
  [[ $status -eq 0 ]]
}

@test "Should ask again if answer is invalid" {
  run ask_yes_no "Hello" <<< "Hi"
  echo $output
  [[ $output =~ Hello.*Hello ]]
}

@test "Should output default input if no input given" {
  ask_input "testvar" "Hello" "Hi" <<< ""
  [[ $testvar = "Hi" ]]
}

@test "Should output given input" {
  export SHELOB_LOG_LEVEL=6
  ask_input "testvar" "Hello" "Hi" <<< "Howdy"
  [[ $testvar = "Howdy" ]]
}

@test "Should work without default value" {
  export SHELOB_LOG_LEVEL=6
  ask_input testvar "Hello" <<< ""
  [[ $testvar = "" ]]
}


@test "Should fail if no variable name given " {
  export SHELOB_LOG_LEVEL=6
  ask_input <<< "" || true
}

