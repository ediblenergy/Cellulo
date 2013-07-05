use strict;
use warnings;
use Game;
$|=1;
my $g = Game->new( num_particles => $ARGV[0] );
$g->init;
$g->play;
