#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s extglob

shellcheck src/lib/*
shellcheck src/bin/*
