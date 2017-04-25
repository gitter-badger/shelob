#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


if [[ $TRAVIS_OS_NAME = "linux" ]]; then
  sudo add-apt-repository ppa:duggan/bats --yes;
  sudo apt-get update -qq;
  sudo apt-get install -qq bats;
fi


if [[ $TRAVIS_OS_NAME = "osx" ]]; then
  brew install bats
fi
