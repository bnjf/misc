#!/bin/bash

# 2013-10-09 bnjf

set -o nounset

# opts
wflag=
wval=0 # forever
while getopts w: name; do
    case $name in
	w)  wflag=1
	    wval="$OPTARG";;
    esac
done
shift $((OPTIND - 1))

# grab the dir name, shift it off
D="${1?"Usage: $0 [-w seconds] directory-name command"}"
shift

# since mkdir can't block like lockf, we'll mkdir and back off
let X=1 SECONDS=0
until mkdir "$D" 2>/dev/null; do
    if (( wval > 0 && SECONDS > wval )); then
	echo "gave up on \"mkdir $D\" after $wval seconds." >&2
	exit 1
    fi
    sleep $((X+=1))
done

# got it, set up a trap
trap "rmdir \"$D\"; exit" EXIT INT HUP

# done
eval "$@"


