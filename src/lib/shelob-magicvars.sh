#!/usr/bin/env bash
# shellcheck disable=SC2034

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

while [ -h "$__source" ]; do # resolve $__source until the file is no longer a symlink
  __dir="$( cd -P "$( dirname "$__source" )" && pwd )"
  __source="$(readlink "$__source")"
  [[ $__source != /* ]] && __source="$__dir/$__source" # if $__source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
__dir="$( cd -P "$( dirname "$__source" )" && pwd )"
__base="$(basename "$__source")"
__file="$__dir/$__base"

unset __source
