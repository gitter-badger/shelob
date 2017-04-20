#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1083,SC2119,SC2168
set -eo pipefail
IFS=$'\n\t'


@test "Should resolve sourcing script's file variables" {
  if source tests/utils/sourcemagicvars.sh; then
    return 0
  else
    return 1
  fi
}

@test "Should resolve file variables when run" {
  if tests/utils/sourcemagicvars.sh; then
    return 0
  else
    return 1
  fi
}

@test "Should resolve file variables if file is linked" {
  if source tests/utils/sourcelink.sh; then
    return 0
  else
    return 1
  fi
}

@test "Should resolve file variables when link is run" {
  if tests/utils/sourcelink.sh; then
    return 0
  else
    return 1
  fi
}
