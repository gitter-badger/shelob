#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

prefix="${PREFIX:-/usr/local}"

for l in lib/*; do
  echo "Installing library $l"
  install -vD "$l" "$prefix/lib/shelob-$(basename "$l")"
done


echo "Installing shelob"
install -vD "shelob" "$prefix/bin/shelob"
