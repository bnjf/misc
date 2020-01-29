#!/usr/bin/perl -w

use strict;
use warnings;
use NetAddr::IP;

sub f {
    my ( $n_, $s_ ) = @_;

    # subnet is outside?
    return printf "%-20s # %s\n", $n_, $n_->range() if !$s_->within($n_);

    # exactly the net?
    return printf "# %-20s # %s\n", $n_, $n_->range() if $s_ == $n_;

    # within, but too broad.  split it.
    f( $_, $s_ ) foreach $n_->split( $n_->masklen() + 1 )
}

die "missing args" unless @ARGV == 2;
my ( $n, $s );
$n = new NetAddr::IP(shift) or die "bogus args";
$n = $n->network()          or die "couldn't get network for $n";
$s = new NetAddr::IP(shift) or die "bogus args";
$s = $s->network()          or die "couldn't get network for $s";

die "$s isn't within $n" unless $s->within($n);

f( $n, $s );

