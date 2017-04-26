#!/usr/bin/env bash

source lib/shelob-magicvars.sh
status=0

testdir="$(pwd)/test"
expected_dir="$testdir/utils"
expected_file="$testdir/utils/sourcemagicvars.sh"
expected_base='sourcemagicvars.sh'
echo "Dir: $__dir , Exptected: $expected_dir"
echo "File: $__file , Exptected: $expected_file"
echo "Base: $__base, Expected: $expected_base"
[[ $__dir = "$expected_dir" ]] || status=1
[[ $__file = "$expected_file" ]] || status=1
[[ $__base = $(basename "$expected_base") ]] || status=1

# if script is being executed rather than sourced exit with status
if [[ ! ${BASH_SOURCE[0]} != "$0" ]]; then
  exit "$status"
fi
