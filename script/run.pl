use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Game;
my $g = Game->new( num_particles => $ARGV[0] );
$g->init;
$g->play;
