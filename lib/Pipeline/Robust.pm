package Pipeline::Robust;

use strict;
use warnings::register;

use Pipeline;
use base qw ( Pipeline );

$::WARNLEVEL = 0;

sub enter {
  my $self = shift;
  my @return;
  eval {
    @return = $self->SUPER::enter( @_ );
  };
  if ($@) {
    warnings::warn("The pipeline died in execution") if warnings::enabled();
    if (warnings::enabled() && $::WARNLEVEL > 1) {
      warnings::warn($@);
    }
  } else {
    if (wantarray) {
      return @return;
    } else {
      if (scalar(@return) > 1) {
	return [@return];
      } else {
	return $return[0];
      }
    }
  }
}

1;
