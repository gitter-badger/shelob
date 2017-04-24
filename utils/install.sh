#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

prefix="${PREFIX:-/usr/local}"

for l in lib/*; do
  install -vD "$l" "$prefix/lib/$(basename "$l")"
done

install -vD "shelob" "$prefix/bin/shelob"
