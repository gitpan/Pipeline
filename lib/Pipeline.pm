package Pipeline;

use strict;
use warnings::register;

use Pipeline::Segment;
use Pipeline::Dispatch;
use Pipeline::Store::Simple;
use Scalar::Util qw( blessed weaken );
use base qw( Pipeline::Segment );

$::PIPES = 0;

our $VERSION=3.08;

sub init {
  my $self = shift;
  if ($self->SUPER::init( @_ )) {
    $self->debug( 0 );
    $self->store( Pipeline::Store::Simple->new() );
    $self->dispatcher( Pipeline::Dispatch->new() );
    $self->segments( [] );
    return $self;
  } else {
    return undef;
  }
}

sub add_segment {
  my $self = shift;
  $self->dispatcher->add( @_ );
  $self;
}

sub get_segment {
  my $self = shift;
  my $idx  = shift;
  return $self->dispatcher()->get( $idx );
}

sub del_segment {
  my $self = shift;
  my $idx  = shift;
  my $seg = $self->segments()->[ $idx ];
  $self->dispatcher()->delete( $idx );
  $seg;
}

sub segments {
  my $self = shift;
  return $self->dispatcher()->segments( @_ );
  my $segs = shift;
  if (defined( $segs )) {
    $self->{ segments } = $segs;
    return $self;
  } else {
    return $self->{ segments };
  }
}

sub dispatch {
  my $self = shift;

  my $result = $self->dispatch_loop();
  my $cleanup_result = $self->cleanup;
  $self->dispatcher()->reset();

  if (blessed( $result )) {
    return $result->isa('Pipeline::Production') ?
      $result->contents :
      $result || 1;
  } else {
    return $result || 1;
  }
}

sub start_dispatch {
  my $self = shift;
  $self->store->start_transaction;
}

sub end_dispatch {
  my $self = shift;
  $self->store->end_transaction;
}

sub dispatch_loop {
  my $self = shift;
  while($self->dispatcher->segment_available) {
    my @results = $self->dispatcher->next( $self );
    my $final;
    foreach my $result ( @results ) {
      next unless blessed $result;
      if ( $result->isa('Pipeline::Segment') ) {
        $self->cleanups->add_segment( $result )
      } elsif ( $result->isa('Pipeline::Production') ) {
        $final = $result;
        $self->store->set( $result->contents );
      } else {
        $self->store->set( $result );
      }
    }
    return $final if $final;
  }
  return 1;
}

## be careful here
sub cleanup {
  my $self = shift;
  if ($self->{ cleanup_pipeline }) {
    return ($self->{ cleanup_pipeline }->debug( $self->debug || 0 )
                                       ->parent( $self )
                                       ->store( $self->store() )
                                       ->dispatch());
  }
  $self->end_dispatch();
}

sub dispatcher {
  my $self = shift;
  my $obj  = shift;
  if (defined( $obj )) {
    $self->{ dispatcher } = $obj;
    return $self;
  } else {
    return $self->{ dispatcher };
  }
}

sub cleanups {
  my $self = shift;
  $self->{ cleanup_pipeline } ||= ref($self)->new();
}

sub debug_all {
  my $self  = shift;
  my $debug = shift;

  foreach my $segment (@{ $self->segments }) {
    $segment->isa( 'Pipeline' )
      ? $segment->debug_all( $debug )
      : $segment->debug( $debug );
  }

  $self->debug( $debug );
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

To see what is being dispatched within a pipeline dispatch set the pipeline's
debug value to true.

=head1 WRITING A PIPELINE

=head2 INHERITANCE

Pipelines are designed to be inherited from.  The inheritance tree is somewhat
warped and should look a little like this:

     MySegment --> Pipeline::Segment <--- Pipeline

In other words, everything is a pipeline segment.

=head2 METHODS

The Pipeline class inherits from the C<Pipeline::Segment> class and therefore
also has any additional methods that its superclass may have.

=over 4

=item init( @_ )

Things to do at construction time.  If you do override this, it will often
be fairly important that you call $self->SUPER::init(@_) to make sure that
the setup is done correctly.  Returns itself on success, undef on failure.

=item add_segment( LIST )

Adds a segment or segments to the pipeline.  Returns itself.

=item get_segment( INTEGER )

Returns the segment located at the index specified by INTEGER

=item del_segment( INTEGER )

Deletes and returns the segment located at the index specified by INTEGER

=item dispatch()

Starts the pipeline execution, returns the production or undef

=item dispatch_loop( Pipeline, [ ARRAYREF ] )

The C<dispatch_loop> method performs the processing for the pipeline

=item dispatch_segment( Pipeline::Segment )

The C<dispatch_segment> method handles the execution of an individual
segment object.

=item cleanups()

Returns the cleanup pipeline.  This is a pipeline in and of itself, and all
the methods you can call on a pipeline can also be called on this.

=item cleanup()

Calls the dispatch method on the cleanup pipeline.

=item segments( [ value ] )

C<segments> gets and sets the value of the pipeline list.  At initialization
this is set to an array reference.

=item debug_all( value )

Sets debug( value ) recursively for each segment in this pipeline.

=back

=head1 SEE ALSO

C<Pipeline::Segment>, C<Pipeline::Store>, C<Pipeline::Store::Simple>
C<Pipeline::Production>

=head1 AUTHORS

  James A. Duncan <jduncan@fotango.com>
  Leon Brocard <acme@astray.com>

=head1 COPYRIGHT

Copyright 2003 Fotango Ltd.
Licensed under the same terms as Perl itself.

=cut

