#!/usr/bin/env bash

source lib/shelob-magicvars.sh

testdir="$( cd "$( dirname "${BATS_TEST_DIRNAME}" )" && pwd )"
expected_dir="$testdir/utils"
expected_file="$testdir/utils/sourcemagicvars.sh"
expected_base='sourcemagicvars.sh'
echo "Dir: $__dir , Exptected: $expected_dir"
echo "File: $__file , Exptected: $expected_file"
echo "Base: $__base, Expected: $expected_base"
[[ $__dir = "$expected_dir" ]]
[[ $__file = "$expected_file" ]]
[[ $__base = $(basename "$expected_base") ]]
