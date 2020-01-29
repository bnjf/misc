#!/usr/bin/perl -nps
# autoflush
BEGIN { use POSIX "strftime"; $| = 1; }
# -z or -u to use zero-offset time
if   ($z || $u) { s/^(\d+)/strftime("%FT%TZ", gmtime($1))/e; }
else            { s/^(\d+)/strftime("%FT%T", localtime($1))/e; }
