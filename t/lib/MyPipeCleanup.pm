package MyPipeCleanup;

use strict;
use warnings::register;
use Pipeline::Segment;
use base qw ( Pipeline::Segment );

sub dispatch {
  ## resets the number of instances that the MyPipe class
  ## has created
  $MyPipe::instance = 0;
}

1;
