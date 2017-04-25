#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

shellcheck src/lib/*
shellcheck src/bin/*
