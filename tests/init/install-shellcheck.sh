#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


if [[ $TRAVIS_OS_NAME = "linux" ]]; then
  sudo apt-get install shellcheck
fi

if [[ $TRAVIS_OS_NAME = "osx" ]]; then
  brew install shellcheck
fi




