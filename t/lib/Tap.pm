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

sub dispatch {
  my($self, $pipe) = @_;

  if ($self->{type} eq 'in') {
    my $water = Water->new();
    return $water;
  } elsif ($self->{type} eq 'out') {
    my $water = $pipe->store->get('Water');
    my $production = Pipeline::Production->new();
        
    $production->contents($water);

    return $production;
  } else {
    warn "unknown tap type $self->{type}\n";
  }
}

1;
