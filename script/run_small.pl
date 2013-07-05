use strict;
use warnings FATAL => 'all';
use Game;
$|=1;
my $g = Game->new( screen_args => { rows => 2, cols => 2 } );
$g->init;
$g->play;

