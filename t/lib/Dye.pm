package Dye;

use Pipeline::Segment;
use Water;
use base qw (Pipeline::Segment);

sub init {
  my $self = shift;
  my %params = @_;
  $self->{ink} = ($params{ink} || 'green');
}

sub dispatch {
  my($self, $pipe) = @_;

  my $water = $pipe->store->get('Water');
  $water->dye($self->{ink});
  return $water;
}

1;
