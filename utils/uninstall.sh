#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob

prefix=${PREFIX:-/usr/local}

for f in $prefix/lib/shelob-* $prefix/bin/shelob ; do
  rm -v "$f"
done
