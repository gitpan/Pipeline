package Pipeline::Production;

use strict;
use warnings::register;

our $VERSION = '2.03';
use Pipeline::Base;
use base qw ( Pipeline::Base );

sub contents {
  my $self = shift;
  my $contains = shift;
  if (defined( $contains )) {
    $self->{contents} = $contains;
    return $self;
  } else {
    return $self->{contents};
  }
}

1;

=head1 NAME

Pipeline::Production - wrapper for production objects

=head1 SYNOPSIS

  use Pipeline::Production;

  my $pp = Pipeline::Production->new();

  $pp->contents( $object );
  my $production = $pp->contents();

=head1 DESCRIPTION

The C<Pipeline::Production> class acts as a wrapper around any scalar
(and therfore object, or reference) that a Pipeline is to consider as
a production.  A production object will terminate the pipeline apon receipt
and cause the cleanup segments to be executed.

=head1 METHODS

=over 4

=item new()

The C<new> method constructs a fresh Pipeline::Production object and
returns it.  In the process it calls the C<init()> method.

=item init()

The C<init> method is called at construction time to perform any pre-use
initialization on the object.

=item contents( [ SCALAR ] )

The C<contents> method gets or sets the contents of the production, ie, the
actual production itself.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=cut
