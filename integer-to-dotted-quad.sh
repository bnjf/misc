#!/usr/bin/env bash

function atoi {
# 1
	#set -- $(IFS=.; echo $*)
	#echo $(( $1 << 24 | $2 << 16 | $3 << 8 | $4 ))

# 2
	local ip=$1
	[[ "$ip" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]] || return
	local a=${BASH_REMATCH[1]}
	local b=${BASH_REMATCH[2]}
	local c=${BASH_REMATCH[3]}
	local d=${BASH_REMATCH[4]}
	
	echo $(( a << 24 | b << 16 | c << 8 | d ))
}

function itoa {
	echo $(( $1 >> 24 & 255 )).\
$(( $1 >> 16 & 255 )).\
$(( $1 >> 8  & 255 )).\
$(( $1       & 255))
}

atoi 1.2.3.4
itoa 16909060

atoi 192.168.1.1
itoa 3232235777

