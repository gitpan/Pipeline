package Pipeline::Store;

use strict;
use warnings::register;

sub new ($) {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
}

sub set ($$) { };
sub get ($$) { };

1;
