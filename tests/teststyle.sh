#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

__files=(src/*.sh tests/*.sh tests/unit-tests/*.sh tests/utils/*.sh utils/*.sh)
shellcheck -x "${__files[@]}"
