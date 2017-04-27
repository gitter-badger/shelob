#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s globstar

__files=(src/**/*.sh test/**/*.sh utils/**/*.sh)
shellcheck -x "${__files[@]}"
