package Pipeline::Segment;

use strict;
use warnings::register;

use Pipeline::Base;
use Scalar::Util qw( weaken );
use Pipeline::Error::Abstract;

use base qw( Pipeline::Base );

our $VERSION=3.07;

sub init {
  my $self = shift;
  if ($self->SUPER::init()) {
    $self->parent( '' );
    return 1; 
  } else {
    return undef;
  }
}

sub dispatch {
  throw Pipeline::Error::Abstract;
}

sub dispatch_method { undef }

sub parent {
  my $self = shift;
  my $seg  = shift;
  if (defined( $seg )) {
    $self->{ parent } = $seg;
    return $self;
  } else {
    return $self->{ parent };
  }
}

sub store {
  my $self = shift;
  my $store = shift;
  if (defined( $store )) {
    $self->{ store } = $store;
    return $self;
  } else {
    return $self->{ store };
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

C<Pipeline::Segment> is designed as a part of the C<Pipeline> system.  The
C<Pipeline::Segment> class is designed to be subclassed as a part of the Pipeline
system.  The primary method that needs to be overloaded is the C<dispatch> method,
which the Pipeline class uses to enter each individual segment that it contains.

=head1 METHODS

The C<Pipeline::Segment> class inherits from C<Pipeline::Base> and therefore
also has any additional methods that its superclass may have.

=over 4

=item init()

The C<init> method is called at construction time.  Any arguments passed to the
C<new> method are passed to it.

=item dispatch()

The C<dispatch> method causes the segment to perform its action.

=item dispatch_method()

The C<dispatch_method> gets and sets the method that gets called on dispatch, by
default this is the C<dispatch()> method.

=item store()

The C<store> method gets the current store.

=item parent()

The C<parent> method returns the pipeline that the segment is current operating from.
It is set at dispatch time by the calling pipeline.

=back

=head1 SEE ALSO

C<Pipeline>, C<Pipeline::Segment::Async>

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=head1 COPYRIGHT

Copyright 2003 Fotango Ltd. All Rights Reserved.

This software is released under the same terms as Perl itself.
=cut


