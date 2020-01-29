#!/bin/bash

# vim:set ts=2 sts=2 sw=2 et ai fdm=marker:

declare -a _exit_handlers=()
_atexit() {
  _exit_handlers+=("$@")
}
_exit() {
  for (( c = ${#_exit_handlers[@]} - 1; c >= 0; c-- )); do
    echo "$0: atexit: ${_exit_handlers[c]}" >&2
    eval "${_exit_handlers[c]}" || true
  done
}
trap _exit EXIT

set -o errexit

mkdir foo.$$
_atexit "rmdir foo.$$"
touch foo.$$/bar
_atexit "rm foo.$$/bar"
touch foo.$$/with\ space
_atexit "rm foo.$$/with\ space"
_atexit "rm foo.$$/with\ space1"


