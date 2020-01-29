#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

sub foo {
  my %args = (
    a => 1,
    b => 2,
    @_
  );
  Dumper(\%args);
}

print foo();                     # defaults
print foo(c => 3);               # new
print foo(a => 0x41, c => 3);    # override, new

print foo(arr=>[0,1,2]);
print foo(hash=>{foo=>100, bar=>200, baz=>300});
