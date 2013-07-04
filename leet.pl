use strict;
use warnings FATAL => 'all';
use Time::HiRes;
use Term::Screen;

binmode STDOUT, ':encoding(UTF-8)';
my $chars_per_frame = 3;
$|=1; #autoflush
sub randchar {
    return eval { return chr(rand( 0b100000000000)) };
}
sub main {
    my $scr = Term::Screen->new;
    my $rows = $scr->rows;
    my $cols = $scr->cols;
    my $i = 1;
    while ($i++) {
            randchar;
            for(0..$chars_per_frame) {
                $scr->at(rand(0),rand($cols));
                $scr->puts( randchar );
            }
            $scr->at(0,0)->il;
            Time::HiRes::sleep .1;
            exit if $scr->key_pressed;
    }
}
exit main;
