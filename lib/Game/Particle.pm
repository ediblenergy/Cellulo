package Game::Particle;
use strict;
use warnings FATAL => 'all';
use Moo;

has x => ( is => 'rw', required => 1 );
has y => ( is => 'rw', required => 1 );

has xdir => ( is => 'ro', required => 1, default => sub { 0 } );
has ydir => ( is => 'ro', required => 1, default => sub { 0 } );

has rows => ( is => 'ro', required => 1);
has cols => ( is => 'ro', required => 1);

sub xpos {
    my( $self, $xx ) = @_;
    if( $xx >= $self->cols ) {
        $xx -= $self->cols;
    } elsif ( $xx < 0 ) {
        $xx += $self->cols;
    }
    return $xx;
}

sub ypos {
    my( $self, $yy ) = @_;
    if( $yy >= $self->rows ) {
        $yy -= $self->rows;
    } elsif ( $yy < 0 ) {
        $yy += $self->rows;
    }
    return $yy;
}
sub move {
    my $self = shift;
    $self->x( $self->xpos( $self->x + $self->xdir ) );
    $self->y( $self->ypos( $self->y + $self->ydir ) );
    warn $self->x;
    warn $self->y;
}

1;
