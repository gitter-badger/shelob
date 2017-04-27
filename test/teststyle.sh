#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

__files=(src/*.sh test/*.sh test/unit-tests/*.sh test/utils/*.sh utils/*.sh)
shellcheck -x "${__files[@]}"
