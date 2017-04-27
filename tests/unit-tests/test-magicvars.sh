#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1083,SC2119,SC2168

test_should_resolve_sourcing_scripts_file_variables() {
  source tests/utils/sourcemagicvars.sh
  assertTrue $status
}

test_should_resolve_file_variables_when_run() {
  tests/utils/sourcemagicvars.sh
  assertTrue $?
}

test_should_resolve_file_variables_if_file_is_linked() {
  source tests/utils/sourcelink.sh
  assertTrue $status
}

test_should_resolve_file_variables_when_link_is_run() {
  tests/utils/sourcelink.sh
  assertTrue $?
}

source utils/shunit2
