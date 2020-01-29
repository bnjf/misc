#!/usr/bin/env perl -l


print "\016", map { chr $_ } 0x20..0x7e;
print "\017", map { chr $_ } 0x20..0x7e;

