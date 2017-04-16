#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob #don't fail if no file found when globbing

gawk -f modules/compiler/compiler.gawk -- \
  -O -x \
  --shell '/usr/bin/env bash' \
  --tempdir /tmp \
  -a src/lib src/bin/shelob \
  -o "shelob" && \
  chmod +x shelob
