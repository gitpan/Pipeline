package Tap;

use Pipeline::Segment;
use Pipeline::Production;
use Water;
use base qw (Pipeline::Segment);

sub init {
  my $self = shift;
  my %params = @_;
  $self->{type} = ($params{type} || 'in');
}

sub enter {
  my($self, $store) = @_;

  if ($self->{type} eq 'in') {
    my $water = Water->new();
    return $water;
  } elsif ($self->{type} eq 'out') {
    my $water = $store->get('Water');
    my $production = Pipeline::Production->new();
    $production->contains($water);
    return $production;
  } else {
    warn "unknown tap type $self->{type}\n";
  }
}

1;
