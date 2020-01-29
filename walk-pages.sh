#!/bin/bash

typeset -i page_size=4096 # getconf PAGE_SIZE
for pid in $(cd /proc && echo [0-9]*/); do
  pid="${pid%/}"
  cd "/proc/$pid" || continue
  for vaddr in $(cut -f1 -d- "maps"); do
    paddr=$(dd if=pagemap bs=8 count=1 skip=$(( 0x$vaddr / page_size )) 2>/dev/null | od -t u8 -A n)
    pfn=$(( (paddr & 0x7fffffffffffff) ))
    swapped=$(( (paddr & 0x4000000000000000) != 0))

    printf "pid:%s vaddr:%s paddr:%x (swapped:%s)\n" "$pid" "$vaddr" "$pfn" "$swapped"
  done
done

