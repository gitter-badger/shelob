#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob #don't fail if no file found when globbing

for l in src/*.sh ; do
    gawk -f utils/compiler.gawk -- \
      -O -x \
      --shell '/usr/bin/env bash' \
      --tempdir /tmp \
      -a src "$l" \
      -o "lib/$(basename "$l")"
done
