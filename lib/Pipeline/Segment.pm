package Pipeline::Segment;

use strict;
use warnings::register;

our $VERSION = '2.01';

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
  $self->init( @_ );
  return $self;
}

sub init { my $self = shift; }

sub dispatch {
  my $self = shift;
  my $pipe = shift;
  {
    # ... do something ... #
  }
}

sub debug {
  my $self  = shift;
  my $debug = shift;
  if (defined($debug)) {
    $self->{debug} = $debug;
    return $self;
  } else {
    return $self->{debug};
  }
}

sub emit {
  my $self  = shift;
  my $mesg  = shift;
  my $force = shift;
  if ($self->debug() || $force) {
    print STDERR '[';
    print STDERR ref($self);
    print STDERR ']';
    print STDERR " $mesg\n";
  }
}

1;

=head1 NAME

Pipeline::Segment - basic class for a segment

=head1 SYNOPSIS

use Pipeline::Segment;
my $ps = Pipeline::Segment->new();
$ps->dispatch();

=head1 DESCRIPTION

C<Pipeline::Segment> is designed as a part of the C<Pipeline> system.  Although
the Pipeline::Segment class can be used as is to achieve Nothing At All, it is
designed to be inherited from as a part of the Pipeline system.  The primary
method that needs to be overloaded is the C<dispatch> method, which the Pipeline
class uses to enter each individual segment that it contains.

=head1 METHODS

=over 4

=item new()

The C<new> method creates a new object of the class C<Pipeline::Segment> and
returns it to the creator.  In the process it calls the init method.

=item init()

The C<init> method is called at construction time.  Any arguments passed to the
C<new> method are passed to it.

=item dispatch( Pipeline )

The C<dispatch> method causes the Pipeline::Segment to perform its action.  Its receives
the C<Pipeline> object that it is being exectued from.

=item debug( [ VALUE ] )

The C<debug> method sets the debug value for the Pipeline::Segment.

=item emit( <MESSAGE> [, FORCE] )

The C<emit> method prints MESSAGE to STDERR if the segments debug level has been set to 
a true value.  If FORCE is a true value MESSAGE gets printed regardless of the debug level
of the segment.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>


=cut
