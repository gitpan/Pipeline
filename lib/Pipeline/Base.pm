package Pipeline::Base;

use strict;
use warnings::register;

our $VERSION = "2.05";

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
  $self->init( @_ );
  return $self;
}

sub init {
  my $self = shift;
  return 1;
}

sub debug {
  my $self = shift;
  return 1 unless ref( $self );
  my $dbg  = shift;
  if (defined($dbg)) {
    $self->{debug} = $dbg;
    return $self;
  } else {
    return $self->{debug};
  }
}

sub emit {
  my $self = shift;
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

Pipeline::Base - base class for all classes in Pipeline distribution

=head1 SYNOPSIS

  use Pipeline::Base;

  $object = Pipeline::Base->new()
  $object->debug( 10 );
  $object->emit("message");

=head1 DESCRIPTION

C<Pipeline::Base> is a class that provides a basic level of functionality
for all classes in the Pipeline system.  Most importantly it provides the 
construction and initialization of new objects.

=head1 METHODS

=over 4

=item CLASS->new()

The C<new()> method is a constructor that returns an instance of receiving
class.

=item OBJECT->init( LIST );

C<init()> is called by the constructor, C<new()> and is passed all of its 
arguments in LIST.

=item OBJECT->debug( [ SCALAR ] )

The C<debug()> method gets and sets the debug state of the OBJECT.  Setting it
to a true value will cause messages sent to C<emit()> to be printed to the
terminal.

=item OBJECT->emit( SCALAR )

C<emit()> is a debugging tool.  It will output SCALAR to STDERR, along with
the class the message was sent from.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=cut
