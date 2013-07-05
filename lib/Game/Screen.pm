package Game::Screen;
use strict;
use warnings FATAL => 'all';
require Term::Screen;
use Moo;
use Data::Dumper::Concise;

has _screen => (
    is      => 'lazy',
    handles => {
        'at'        => 'at',
        key_pressed => 'key_pressed',
        clrscr => 'clrscr',
    } );

has grid => ( 
    is => 'lazy',
);

has rows => ( is => 'lazy' );
has cols => ( is => 'lazy' );

sub _build_rows { shift->_screen->rows }
sub _build_cols { shift->_screen->cols }

sub reset_grid {
    my $self = shift;
    my $grid = $self->grid;
    @$grid = @{ $self->_build_grid };
    return $grid;
}
sub _build_grid {
    my $self = shift;
    my $ret = [ map { [ (undef) x $self->cols ] } ( 1 .. $self->rows ) ];
    return $ret;
}

sub _build__screen {
    my $self = shift;
    Term::Screen->new;
}

1;
