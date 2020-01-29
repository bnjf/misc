#!/usr/bin/env perl

# vim:ts=2 sts=2 sw=2 et ai fdm=marker:

use strict;
use warnings;
use IO::Pipe;
use Parallel::ForkManager;

use constant SLAVE_COUNT => 4;

my @slaves;

my $pm = Parallel::ForkManager->new(SLAVE_COUNT);
# start slaves
for (1 .. SLAVE_COUNT) {
  my $pipe = IO::Pipe->new;
  my $pid  = $pm->start;

  if ($pid) {
    $pipe->writer;
    push @slaves, {pid => $pid, pipe => $pipe};
    next;
  }
  else {
    $pipe->reader;
    while (<$pipe>) {
      print "$$: $_";
    }
    $pm->finish;
  }
}

# feed slaves
my $i = 0;
print {$slaves[ $i++ % scalar @slaves ]{'pipe'}} $_ x 80 . "\n" for 'a' .. 'z', 'A' .. 'Z', '0' .. '9';
for my $slave (@slaves) {
  $slave->{'pipe'}->close();
}

$pm->wait_all_children;

