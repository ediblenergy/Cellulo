use strict;
use warnings;
use Games::Cellulo::Game;
use Test::More;
ok my $g = Game->new,'instantiated!';
$g->play;
done_testing;
