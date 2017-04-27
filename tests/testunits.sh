#!/usr/bin/env bash
# shellcheck disable=SC1090
set -euo pipefail
IFS=$'\n\t'
echo "Testing with Bash version $BASH_VERSION"

for f in tests/unit-tests/*.sh; do
  "$f"
done

