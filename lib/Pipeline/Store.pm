package Pipeline::Store;

use strict;
use warnings::register;

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
  $self->init();
  return $self;
}

sub init {
  my $self = shift;
  $self->store( {} );
}

sub store {
  my $self = shift;
  my $store = shift;
  if (defined( $store )) {
    $self->{store} = $store;
    return $self;
  } else {
    return $self->{store};
  }
}

sub set {

}

sub get {

}

1;


=head1 NAME

Pipeline::Store - defines the interface for Pipeline store classes

=head1 SYNOPSIS


  use Pipeline::Store; # interface class, does very little

  my $store = Pipeline::Store->new();

=head1 DESCRIPTION

C<Pipeline::Store> provides a constructor and a generic get/set interface
for any class implementing a store to sit on a Pipeline.

=head1 METHODS

=over 4

=item new()

The C<new> method constructs a new Pipeline::Store object and calls
the C<init> method.

=item init()

The C<init> method is called by new() to do any construction-time initialization
of an object.

=item store( [ store ] )

The C<store> method gets or sets the store in a Pipeline::Store object.  Unless C<init>
is changed the store is set at construction time to a hash reference.

=item get()

Does nothing in Pipeline::Store - exists as a placeholder for subclasses.

=item set()

Does nothing in Pipeline::Store - exists as a placeholder for subclasses.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=cut
