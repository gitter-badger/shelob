#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
echo "Testing with Bash version $BASH_VERSION"
shopt -s extglob

shellcheck src/**/*
modules/bats/bin/bats tests/unit-tests
