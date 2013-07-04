package Game;
use strict;
use warnings FATAL => 'all';
use Game::Screen;
use Time::HiRes;
use Game::Particle;
use Data::Dumper::Concise;


use Moo;
has screen => ( is => 'lazy', handles => [qw/ grid /] );

has num_particles => (
    is => 'ro',
    required => 1,
    default => sub { 40 },
);

has particles => ( 
    is => 'rw',
);
sub _rand_dir {
    int( rand(3) ) - 1;
}
sub _build_screen {
    Game::Screen->new;
}

sub randx {
    my $self = shift;
    my $cols = $self->screen->cols;
    int( rand( $cols ) + 1 );
}

sub randy {
    my $self = shift;
    my $rows = $self->screen->rows;
    int( rand( $rows ) + 1 );

}

sub init {
    my $self = shift;
    my $rows = $self->screen->rows;
    my $cols = $self->screen->cols;
    $self->particles(
        [
            map {
                Game::Particle->new(
                    rows => $rows,
                    cols => $cols,
                    x    => $self->randx,
                    y    => $self->randy,
                    xdir => _rand_dir(),
                    ydir => _rand_dir(),
                  )
            } ( 1 .. $self->num_particles ) ] );
}

sub play {
    my $self = shift;
    $self->draw while ( !$self->screen->key_pressed );
}

sub grid_str {
    join "", map { join( "" => @$_ ) } @{ shift->screen->grid }
}

sub draw_grid {
    print( shift->grid_str );
}
sub move_particles {
    my $self = shift;
    for ( @{ $self->particles } ) {
        $_->move;
    }
}
sub draw {
    my $self = shift;
   $self->screen->reset_grid;
   $self->screen->at(0,0);
    my $grid = $self->screen->grid;
    for ( @{ $self->particles } ) {
        $grid->[ $_->y ][ $_->x ] = 'o';
    }
    $self->move_particles;
    $self->draw_grid;
    Time::HiRes::sleep .02;
}
1;
