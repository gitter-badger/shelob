#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
echo "Testing with Bash version $BASH_VERSION"

bats test/unit-tests
