#!/bin/ksh

set -eu

pbind $$
pbind -b 0 $$
pbind $$
ksh -c 'pbind $$'

