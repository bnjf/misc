#!/bin/bash

# vim:ts=2 sts=2 sw=2 et ai fdm=marker:

set -eu

# get lock
until ln sem sem.lock 2>/dev/null
do sleep 0
done

# bump
typeset -i i=$(<sem)
echo $((i+1)) > sem

# unlock
rm sem.lock

echo $i

