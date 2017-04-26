#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
echo "Testing with Bash version $BASH_VERSION"

bats tests/unit-tests
