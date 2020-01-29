#!/usr/bin/env perl

use strict;
use warnings;

use constant INTERVAL => 1;

# autoflush
$| = 1;

# get the inode for file, or return 0
sub get_inode { (stat(shift))[1] || 0 }

# build a hash (fn => inode) from the args
my %fi = map { $_ => get_inode $_ } @ARGV;

# monitor files for inode changes
while (sleep INTERVAL) {
  for my $f (keys %fi) {
    my $i = get_inode($f);
    if ($fi{$f} != $i) {
      # don't print if the new inode is 0
      print "$f\n" if $fi{$f} = $i;
    }
  }
}

