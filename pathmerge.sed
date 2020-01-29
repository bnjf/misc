#!/bin/sed -f

# Brad Forschinger, 2016

# a:b:c => :a::b::c:
s/:/::/g
s/^/:/
s/$/:/

:loop
  s/\(:[^:]\{1,\}:\)\(.*\)\1/\1\2/
t loop

s/::*/:/g
s/^://
s/:$//

