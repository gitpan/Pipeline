package Pipeline::Production;

use strict;
use warnings::register;
use Scalar::Util qw ( blessed );

sub new {
  my $class = shift;
  my $elem  = shift;
  my $self  = { contained => '' };
  if ($elem) {
    $self->contains( $elem );
  }
  bless $self, $class;
}

sub contains {
  my $self = shift;
  my $elem = shift;
  if(blessed($elem)) {
    $self->{contained} = $elem;
  } else {
    if (exists $self->{contained}) {
      return $self->{contained};
    } else {
      return $self;
    }
  }
}

1;
