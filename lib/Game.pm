package Game;
use strict;
use warnings FATAL => 'all';
use Game::Screen;
use Time::HiRes;
use Game::Particle;
use Data::Dumper::Concise;
use Try::Tiny;

use Moo;
use MooX::Options;

has screen => ( is => 'lazy', handles => [qw/ grid /] );

option sleep_time => (
    is => 'ro',
    format => 's',
    required => 0,
    doc => 'time to sleep between frames',
    default => sub { .03 },
);
option num_particles => (
    is => 'ro',
    format => 'i',
    required => 1,
    doc => "number of onscreen particles",
);

option meld => (
    is => 'ro',
    doc => 'particles should turn in to each other when stuck'
);

has screen_args => ( 
    is => 'ro',
    default => sub { +{} },
);

has particles => ( 
    is => 'rw',
);
sub _rand_dir {
    int( rand(3) ) - 1;
}
sub _build_screen {
    Game::Screen->new( shift->screen_args )
}

sub randx {
    my $self = shift;
    my $cols = $self->screen->cols;
    int( rand( $cols )  );
}

sub randy {
    my $self = shift;
    my $rows = $self->screen->rows;
    int( rand( $rows )  );

}

sub init {
    my $self = shift;
    my $rows = $self->screen->rows;
    my $cols = $self->screen->cols;
    $self->screen->clrscr;
    my $grid = $self->screen->grid;
    my @particles;
    for ( 1 .. $self->num_particles ) {
        my $randy = $self->randy;
        my $randx = $self->randx;
        next if $grid->[$randy][$randx];
        $grid->[$randy][$randx] = Game::Particle->new(
            rows => $rows,
            cols => $cols,
            x    => $randx,
            y    => $randy,
            type => int( rand(4) + 1 ),
        );
        push( @particles, $grid->[$randy][$randx] );
    }
    $self->particles( \@particles );
}

sub play {
    my $self = shift;
    $self->draw while ( !$self->screen->key_pressed );
}

sub draw_grid {
    my $self   = shift;
    my $screen = $self->screen;
    my $grid   = $self->screen->grid;
    $screen->at( 0, 0 );
    for ( 0 .. $screen->rows - 1 ) {
        $screen->at( $_, 0 );
        print join "" => map { $_ ? $_->char : " " } @{ $grid->[$_] };
    }
}

my $_move = sub {
    my ( $p, $wantx, $wanty, $grid ) = @_;
    $grid->[$wanty][$wantx] = $p;
    $grid->[ $p->y ][ $p->x ] = undef;
    $p->x($wantx);
    $p->y($wanty);
};

sub move_particles {
    my $self  = shift;
    my $grid  = $self->screen->grid;
    for ( @{ $self->particles } ) {
        my $wantx = $_->xpos( $_->x + $_->xdir );
        my $wanty = $_->ypos( $_->y + $_->ydir );
        unless ( $grid->[$wanty][$wantx] ) {
            $_move->( $_, $wantx, $wanty, $grid );
        }
        else {
            $wantx = $_->xpos( $_->x + $_->avoidx );
            $wanty = $_->ypos( $_->y + $_->avoidy );
            unless ( $grid->[$wanty][$wantx] ) {
                $_move->( $_, $wantx, $wanty, $grid );
            } elsif( $self->meld ) {
                $_->type( $grid->[$wanty][$wantx]->type );
                $_->clear_xdir;
                $_->clear_ydir;
                $_->clear_char;
            }
        }
    }
}
sub draw {
    my $self = shift;
   $self->screen->at(0,0);
    my $grid = $self->screen->grid;
    $self->move_particles;
#    $self->screen->reset_grid;
    $self->draw_grid;
    Time::HiRes::sleep $self->sleep_time;
}
1;
