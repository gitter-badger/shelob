#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
echo "Testing with Bash version $BASH_VERSION"

for f in test/unit-tests/*.sh; do
  $f
done
