package Pipeline::Segment;

use Pipeline;
use base qw ( Pipeline );

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
  if ($self->init( @_ )) {
    return $self;
  } else {
    return undef;
  }
}

sub init {
  1;
}

sub enter {
  my $self = shift;
  my $class = ref($self);
  warnings::warn("segment $class did not implement an enter method");
}

sub onPlugin {
  my $self = shift;
  my $pipeline = shift;
  if ($pipeline->isa('Pipeline')) {
    return 1;
  } else {
    return undef;
  }
}

1;
