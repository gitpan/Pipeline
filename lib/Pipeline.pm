package Pipeline;

use strict;
use warnings::register;

use Pipeline::Segment;
use Pipeline::Production;
use Pipeline::Store::Simple;
use Scalar::Util qw ( blessed );
use base qw ( Pipeline::Segment );

our $VERSION = '2.00';

sub init {
  my $self = shift;
  $self->pipeline( [] );
  $self->cleanup( [] );
  $self->store( Pipeline::Store::Simple->new() );
  $self->SUPER::init( @_ );
}

sub add_segment {
  my $self = shift;
  push @{$self->pipeline}, @_;
}

sub add_cleanup {
  my $self = shift;
  push @{$self->cleanup}, @_;
}

sub dispatch {
  my $self = shift;
  my $result = $self->dispatch_loop();
  $self->dispatch_loop( $self, $self->cleanup );
  return $result;
}

sub dispatch_loop {
  my $self   = shift;
  my $parent = shift;
  my $torun  = shift || $self->pipeline;

  ##
  ## if we have a parent, then we use its store, otherwise
  ## we use the one that we have initialized
  ##
  my $store;
  if (defined( $parent )) {
    $store = $parent->store();
  } else {
    $store = $self->store();
  }

  my $result;
  foreach my $seg ( @$torun ) {
    my @result = $self->dispatch_segment( $seg );

    foreach my $res (@result) {
      ## have we got a blessed reference?
      if ( blessed( $res ) ) {
	## yup, okay, is it a production?
	if ($res->isa("Pipeline::Production")) {
	  ## we stop the dispatch loop here
	  if ($res->can( 'contents' )) {
	    $result = $res->contents();
	  } else {
	    $result = $res;
	  }
	  $self->store->set( $res );
	} ## is it a segment to cleanup?
	elsif ($res->isa("Pipeline::Segment")) {
	  ## we need to add this to the cleanups
	  $self->add_cleanup( $res );
	} else {  ## okay, well, we'll stuff in in the store and hope
	  $self->store->set( $res );
	}
      }
    }
  }

  return $result;
}

sub dispatch_segment {
  my $self = shift;
  my $seg  = shift;
  return $seg->dispatch( $self );
}

sub cleanup {
  my $self = shift;
  my $pipe = shift;
  if (defined($pipe)) {
    $self->{cleanup} = $pipe;
    return $self;
  } else {
    return $self->{cleanup};
  }
}

sub pipeline {
  my $self = shift;
  my $pipe = shift;
  if (defined($pipe)) {
    $self->{pipeline} = $pipe;
    return $self;
  } else {
    return $self->{pipeline}
  }
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

1;

=head1 NAME

Pipeline - Generic pipeline interface

=head1 SYNOPSIS

  use Pipeline;
  my $pipeline = Pipeline->new();
  $pipeline->add_segment( @segments );
  $pipeline->dispatch();

=head1 DESCRIPTION

C<Pipelines> are a mechanism to process data. They are designed to be
plugged together to make fairly complex operations act in a fairly
straightforward manner, cleanly, and simply.

=head1 USING THE PIPELINE MODULE

The usage of the generic pipeline module is fairly simple. You
instantiate a Pipeline object by using the I<new()> constructor.

Segments can be added to the pipeline with the add_segment method.

The store that the Pipeline will use can be set by calling the I<store()>
method later on.  If a store is not set by the time a pipeline is executing
then it will use a store of the type C<Pipeline::Store::Simple>

To start the pipeline running call the I<dispatch()> method on your Pipeline
object.

=head1 WRITING A PIPELINE

=head2 INHERITANCE

Pipelines are designed to be inherited from.  The inheritance tree is somewhat
warped and should look a little like this:

     MySegment --> Pipeline::Segment <--- Pipeline

In other words, everything is a pipeline segment.

=head2 METHODS

=over 4

=item init()

Things to do at construction time.  If you do override this, its will often
be fairly important that you call $self->SUPER::init() to make sure that
the setup is done correctly.

=item add_segment( LIST )

Adds a segment or segments to the pipeline.

=item add_cleanup( LIST )

Adds a segment or segments to the cleanup pipeline, that gets executed
after the pipeline has finished.

=item dispatch()

Starts the pipeline execution, returns the production or undef

=item dispatch_loop( Pipeline, [ ARRAYREF ] )

The C<dispatch_loop> method performs the processing for the pipeline

=item dispatch_segment( Pipeline::Segment )

The C<dispatch_segment> method handles the execution of an individual
segment object.

=item cleanup( [ value ] )

C<cleanup> gets and sets the value of the cleanup list.  At initialization
this is set to an array reference.

=item pipeline( [ value ] )

C<pipeline> gets and sets the value of the pipeline list.  At initialization
this is set to an array reference.

=item store( [ Pipeline::Store ] )

C<store> gets and sets the value of a Pipeline's store.  At initialization
this is set to a Pipeline::Store::Simple object.

=back

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>
Leon Brocard <acme@astray.com>

=head1 COPYRIGHT

Copyright 2002 Fotango Ltd.
Licensed under the same terms as Perl itself.

=cut

