package Pipeline::Store;

use strict;
use warnings::register;

use Pipeline::Base;
use base qw( Pipeline::Base );

our $VERSION = '3.00';

sub new {
  my $class = shift;
  return $::TRANSACTION_STORE ||= $class->SUPER::new( @_ );
}

sub init {
  my $self = shift;
  if ($self->SUPER::init( @_ ) && ref($self) ne 'Pipeline::Store') {
    return 1; 
  } else {
    return 0;
  }
}

sub set {
  throw Pipeline::Error::Abstract;
}

sub get {
  throw Pipeline::Error::Abstract;
}

1;


=head1 NAME

Pipeline::Store - defines the interface for Pipeline store classes

=head1 SYNOPSIS

  use Pipeline::Store; # interface class, does very little

=head1 DESCRIPTION

C<Pipeline::Store> provides a constructor and a generic get/set interface
for any class implementing a store to sit on a Pipeline.

=head1 METHODS

The Pipeline class inherits from the C<Pipeline::Base> class and therefore
also has any additional methods that its superclass may have.

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

=head1 SEE ALSO

C<Pipeline>, C<Pipeline::Store::Simple>, C<Pipeline::Store::ISA>

=head1 COPYRIGHT

Copyright 2003 Fotango Ltd. All Rights Reserved

This module is released under the same license as Perl itself.

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=cut
