#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

source "./lib/shelob-interactive.sh"

ask_input "What is your name?" "John"
