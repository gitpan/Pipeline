package Pipeline::Store::ISA;

use strict;
use warnings::register;

use Pipeline::Store;
use base qw ( Pipeline::Store );

use Class::ISA;

our $VERSION=3.08;

sub set {
  my $self = shift;
  my $obj  = shift;
  my @isa  = Class::ISA::super_path( ref($obj) );
  $self->{store_isa}->{$_} = ref( $obj ) foreach @isa;
  $self->{store}->{ref($obj)} = $obj;
  $self->emit("setting object " . ref($obj));
  return $self;
}

sub get {
  my $self = shift;
  my $key  = shift;

  $self->emit("$key requested");

  if (exists( $self->{store}->{ $key })) {
    $self->emit("returning object $key");
    return $self->{store}->{ $key };
  } elsif (exists( $self->{store_isa}->{$key})) {
    return $self->get( $self->{store_isa}->{$key} );
  } else {
    $self->emit("no object $key");
    return undef;
  }
}

1;


=head1 NAME

Pipeline::Store::ISA - inheritance-based store for pipelines

=head1 SYNOPSIS

  use Pipeline::Store::ISA;

  my $store = Pipeline::Store::ISA->new();
  $store->set( $object );
  my $object = $store->get( $class );

=head1 DESCRIPTION

C<Pipeline::Store::ISA> is a slightly more complex implementation of a
Pipeline store than C<Pipeline::Store::Simple>. It stores things as in a
hashref indexed by classname, and also their inheritance tree. You can add
an object to a store by calling the set method with an object, and you can
get an object by calling the get method with the classname or parent classname
of the object you wish to retrieve.

C<Pipeline::Store::ISA> inherits from the C<Pipeline::Store> class and
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

=head1 SEE ALSO

C<Pipeline>, C<Pipeline::Store>, C<Pipeline::Store::Simple>

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=head1 COPYRIGHT

Copyright 2002 Fotango Ltd. All Rights Reserved.

This software is distributed under the same terms as Perl itself.

=cut


