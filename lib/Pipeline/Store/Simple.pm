package Pipeline::Store::Simple;

use strict;
use warnings::register;

use Pipeline::Store;
use Scalar::Util qw ( blessed );
use base qw ( Pipeline::Store );

sub set {
  my $self = shift;

  foreach my $elem (@_) {
    if (!ref($elem)) {
      next;
    }

    $self->{store}->{ref($elem)} = $elem;
  }
}

sub get {
  my $self = shift;
  my @elements;
  foreach my $req (@_) {
    if (exists $self->{store}->{$req}) {
      push @elements, $self->{store}->{$req};
    } else {
      return undef;
    }
  }

  if (wantarray) {
    return @elements;
  } else {
    return $elements[0];
  }
}

1;
