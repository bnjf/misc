#!/usr/bin/env python

import sys
from netaddr import IPSet

for x in (IPSet([sys.argv[1]]) - IPSet([sys.argv[2]])).iter_cidrs():
  print '{0:20} # {1} - {2}'.format(x, x[0], x[-1])

