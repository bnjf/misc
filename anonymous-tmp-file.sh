#!/bin/sh

infd=6
outfd=7

tmpfile=`mktemp`
[ -z "$tmpfile" ] && exit 1

# note: ksh and bash have <>
exec 6> $tmpfile
exec 7< $tmpfile
rm $tmpfile

echo '-- update 1:'
cat >&$infd <<_end_of_msg
line 1: foo
_end_of_msg
cat <&$outfd # after this the fp will be at the end of the file

echo '-- update 2:'
cat >&$infd <<_end_of_msg2
line 2: bar
_end_of_msg2
cat <&$outfd

# if we want the whole contents, we'll need to rewind
echo '-- rewind, cat:'
perl -MPOSIX -e 'POSIX::lseek($_, 0, &POSIX::SEEK_SET) for @ARGV;' $outfd
cat <&$outfd

# or, if we've got a /dev/fd
echo '-- rewind, cat from /dev/fd:'
perl -MPOSIX -e 'POSIX::lseek($_, 0, &POSIX::SEEK_SET) for @ARGV;' $outfd
cat /dev/fd/$outfd

# or, if we've got a procfs (no need to rewind)
echo '-- cat from procfs:'
cat /proc/self/fd/$outfd

