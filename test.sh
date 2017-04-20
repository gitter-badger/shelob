#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

source "./lib/shelob-logger.sh"
source "./lib/shelob-magicvars.sh"

error "__is_main:" "$__is_main"
info "__dir:" "$__dir"
info "__file:" "$__file"
info "__base:" "$__base"


