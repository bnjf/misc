#!/bin/awk -f

BEGIN {
  FS=":"
}

{
  for (i = 1; i <= NF; i++) {
    if (!seen[$i]++) {
      if (i == 1) { val = $i }
      else { val = val ":" $i }
    }
  }
  print val
}
