#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Games::Cellulo::Game;
use Devel::Dwarn;
my $g = Games::Cellulo::Game->new_with_options;

my $_all = sub {
    return @$_[0];
};

local $SIG{USR1} = sub {
    warn 'KAUGHT A USR1';
    for( @{ $g->particles }) {
        Dwarn $_->successes_in_direction;
    }
    exit };
$g->init;
$g->play;
