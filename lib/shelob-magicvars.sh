#!/usr/bin/env bash

if [[ ${BASH_SOURCE[0]} != "$0" ]]; then
  __source=
  if [[ ${BASH_SOURCE[0]} =~ .*shelob-magicvars.sh$ ]]; then
    __source="${BASH_SOURCE[1]}"
  else
    __source="${BASH_SOURCE[0]}"
  fi
  __is_main=false
else
  __is_main=true
  __source="${BASH_SOURCE[0]}"
fi

__dir="$( cd -P "$( dirname "$__source" )" && pwd )"
__base="$(basename "$__source")"
__file="$__dir/$__base"

unset __source
