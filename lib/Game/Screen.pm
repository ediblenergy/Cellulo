package Game::Screen;
use strict;
use warnings FATAL => 'all';
require Term::Screen;
use Moo;

has _screen => (
    is => 'lazy',
    handles => { rows => 'rows', cols => 'cols', 'at' => 'at', key_pressed => 'key_pressed' }
);

has grid => ( 
    is => 'lazy',
);

sub reset_grid {
    my $self = shift;
    my $grid = $self->grid;
    @$grid = @{ $self->_build_grid };
    return $grid;
}
sub _build_grid {
    my $self = shift;
    [ map { [ ('-') x $self->cols ] } ( 1 .. $self->rows ) ];
}

sub _build__screen {
    my $self = shift;
    Term::Screen->new;
}

1;
