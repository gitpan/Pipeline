package MyPipe;

use MyPipeCleanup;
use Pipeline::Segment;
use Pipeline::Production;
use base qw ( Pipeline::Segment );
my $instance = 0;

sub init {
  my $self = shift;
  $instance++;
  $self->{instance} = $instance;
}

sub dispatch {
  my $self = shift;
  if ($self->{instance} == 2) {
    my $production = Pipeline::Production->new();
    $production->contents( $self );
    return ($production, MyPipeCleanup->new());
  }
}

1;
