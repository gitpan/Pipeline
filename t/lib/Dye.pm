package Dye;

use Pipeline::Segment;
use Pipeline::Production;
use Water;
use base qw (Pipeline::Segment);

sub init {
  my $self = shift;
  my %params = @_;
  $self->{ink} = ($params{type} || 'green');
}

sub enter {
  my($self, $store) = @_;

  my $water = $store->get('Water');
  $water->{colour} = $self->{ink};
  return $water;
}

1;
