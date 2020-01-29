#!/bin/bash

# caveats:
# - won't work if the inode is recycled and is used by the same filename (I'm
#   indexing on inode since bash<4 doesn't have associative arrays)
# - not guaranteed to work if the filename has spaces

interval=1

while read inode filename
do
  seen[inode]="$filename"
done < <(find "$@" -ls 2>/dev/null | awk '{ print $1, $NF }')

while sleep $interval
do
  while read inode filename
  do
    if [[ "${seen[inode]}" != "$filename" ]]
    then
      echo "$filename"
      seen[inode]="$filename"
    fi
  done < <(find "$@" -ls 2>/dev/null | awk '{ print $1, $NF }')
done

