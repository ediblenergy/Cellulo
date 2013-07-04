use strict;
use warnings;
use Game;
use Test::More;
ok my $g = Game->new;
$g->play;
done_testing;
