#!/bin/bash

set -o errexit
set -o nounset

mkdir /tmp/addrdoc || exit 1
#mkdir /tmp/addrdoc || { echo couldnt lock; exit 222; }

trap 'echo cleaning up; rm /tmp/addrdoc/*; rmdir /tmp/addrdoc; exit 1;' EXIT INT TERM

echo doing stuff

echo output of something > /tmp/addrdoc/file1

# ...

#sleep 60

echo done


