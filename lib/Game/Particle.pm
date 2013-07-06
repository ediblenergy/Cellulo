package Game::Particle;
use strict;
use warnings FATAL => 'all';
use Moo;
use Term::ANSIColor;

use constant {
    R => 1,
    B => 2, 
    G => 3,
    Y => 4,
};
has x => ( is => 'rw', required => 1 );
has y => ( is => 'rw', required => 1 );
has type => ( is => 'rw', required => 1 );

has xdir => ( is => 'lazy', clearer => 1 );
has ydir => ( is => 'lazy', clearer => 1  );
has char => ( is => 'lazy', clearer => 1 );

has rows => ( is => 'ro', required => 1);
has cols => ( is => 'ro', required => 1);

sub _build_xdir {
    my $self = shift;
    for( $self->type ) {
        return -1 if $_ eq R;
        return 1 if $_ eq B;
        return 0;
    }
}

sub _build_ydir {
    my $self = shift;
    for( $self->type ) {
        return -1 if $_ eq G;
        return 1 if $_ eq Y;
        return 0;
    }
}

sub _build_char {
    my $self = shift;
    return color('blue') . '_' . color('reset')   if $self->type eq B;
    return color('red') . 'x' . color('reset')    if $self->type eq R;
    return color('green') . '^' . color('reset')  if $self->type eq G;
    return color('yellow') . 'v' . color('reset') if $self->type eq Y;
}
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

sub avoidx {
    my $self = shift;
    return 0 if $self->xdir;
    int( rand(3) ) - 1;
}

sub avoidy {
    my $self = shift;
    return 0 if $self->ydir;
    int( rand(3) ) - 1;
}


sub move {
    my $self = shift;
    my $wantx = $self->xpos( $self->x + $self->xdir );
    my $wanty = $self->ypos( $self->y + $self->ydir );
    $self->x( $wantx );
    $self->y( $wanty );
}

1;
