package Pipeline::Store::Simple;

use strict;
use warnings::register;

use Pipeline::Store;
use base qw ( Pipeline::Store );

our $VERSION = '2.02';

sub set {
  my $self = shift;
  my $thing = shift;
  $self->store->{ ref( $thing ) } = $thing;
  return $self;
}

sub get {
  my $self = shift;
  my $this = shift;

  ## is something requesting a copy of 
  ## the store?
  if ($this eq ref($self)) {
    ## yup, just return $self
    return $self;
  }

  return $self->store->{ $this };
}

1;


=head1 

Pipeline::Store::Simple - simple store for pipelines

=head1 SYNOPSIS

  use Pipeline::Store::Simple;

  my $store = Pipeline::Store::Simple->new();
  $store->set( $object );
  my $object = $store->get( $class );

=head1 DESCRIPTION

C<Pipeline::Store::Simple> is a simple implementation of a Pipeline store.
It stores things as in a hashref indexed by classname.  You can add an object
to a store by calling the set method with an object, and you can get an object
by calling the get method with the classname of the object you wish to retrieve.

C<Pipeline::Store::Simple> inherits from the C<Pipeline::Store> class and
includes its methods also.

=head1 METHODS

=over 4

=item set( OBJECT )

The C<set> method stores an object specified by OBJECT in itself.

=item get( SCALAR )

The C<get> method attempts to return an object of the class specified
by SCALAR.  If an object of that class does not exist in the store it
returns undef instead.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=cut


