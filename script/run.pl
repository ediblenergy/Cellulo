#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Game;
my $g = Game->new_with_options;
$g->init;
$g->play;
