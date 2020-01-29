#!/usr/bin/env perl

# vim:ts=2 sts=2 sw=2 et ai fdm=marker:

use strict;
use warnings;
use IO::Handle;
use Parallel::ForkManager;
use IPC::SysV qw(IPC_PRIVATE S_IRWXU IPC_CREAT SEM_UNDO);
use IPC::Semaphore;

use constant SLAVE_COUNT => 4;

my $pm = Parallel::ForkManager->new(SLAVE_COUNT);

# init semaphores {{{
use constant READER_MUTEX => 0;
use constant WRITER_MUTEX => 1;
use constant MUTEX_COUNT  => 2;
my $sem = new IPC::Semaphore(IPC_PRIVATE, MUTEX_COUNT, S_IRWXU | IPC_CREAT)
  or die "creating semaphore: $!";
$sem->setval(READER_MUTEX, 0);
$sem->setval(WRITER_MUTEX, SLAVE_COUNT);
sub reader_wait   { $sem->op(READER_MUTEX, -1, SEM_UNDO); }
sub writer_wait   { $sem->op(WRITER_MUTEX, -1, SEM_UNDO); }
sub reader_signal { $sem->op(READER_MUTEX, 1,  SEM_UNDO); }
sub writer_signal { $sem->op(WRITER_MUTEX, 1,  SEM_UNDO); }
# }}}

-p "jobs" or die "you should ``mkfifo jobs'' first";
link("jobs", "jobs.lock") or die "couldn't lock";

# start slaves
for (1 .. SLAVE_COUNT) {
  my $pid = $pm->start and next;
  my $jobs;

  open($jobs, "<", "jobs");
  while (1) {
    reader_wait();
    my $line = <$jobs>;
    last unless defined($line) ; # SEM_UNDO will up the reader semaphore, we don't have to handle it here

    # do work here

    writer_signal();
  }
  close($jobs);

  $pm->finish;
}

# feed slaves
open(my $master, ">", "jobs");
$master->autoflush(1);
my $i = 1000;
while ($i--) {
  for ('a' .. 'z', 'A' .. 'Z', '0' .. '9') {
    writer_wait();

    # provide work here
    print {$master} $_ x 112 . "\n";

    reader_signal();
  }
}
close($master);
reader_signal();    # let them pick up eof

$pm->wait_all_children;
unlink("jobs.lock");

