package Pipeline;

use strict;
use warnings::register;
use Scalar::Util qw ( blessed );

our $VERSION = '1.00';

use Pipeline::Store::Simple;

sub new {
  my $class = shift;
  my $args  = { @_ };
  my $self  = {};
  bless $self, $class;
  if( $self->init( $args ) ) {
    return $self;
  } else {
    return 0;
  }
}


##
## called whenever a pipeline is constructed, must return truth.
##
sub init {
  my $self = shift;
  my $args = shift;

  ## if we don't have a store supplied via the 'store' parameter then we
  ## create a simple store, just out of convenience really.
  if ($args->{store}) {
    if (ref($args->{store})) {
      $self->store( $args->{store} );
    }
  } else {
    $self->store( Pipeline::Store::Simple->new() );
  }

  if (!$args->{segments}) {
    return undef;
  } else {
    foreach my $segment (@{$args->{segments}}) {
      $self->plugin( $segment );
    }
  }

  return 1;
}

##
## gets/sets the store.
##
sub store {
  my $self = shift;
  my $store = shift;
  if (!$store) {
    return $self->{store};
  } else {
    if (blessed($store) && $store->isa('Pipeline::Store')) {
      $self->{store} = $store;
      return 1;
    }
  }
}

## plug in another segment or pipeline.  executes onPlugin method
##  on the element, and if it returns 1, it goes in.
sub plugin {
  my $self = shift;
  my $segment = shift;
  if (!$segment) {
    return undef;
  }
  if( $segment->onPlugin( $self ) ) {
    push @{$self->{segments}}, $segment;
  }
}

##
## adds a list of cleanup segment(s) / pipeline(s) to the pipeline
##
sub cleanup {
  my $self = shift;
  my $cleanup = shift;
  if (!$cleanup) {
    return undef;
  }
  if (ref($cleanup) && ref($cleanup) eq 'ARRAY') {
    push @{$self->{cleanups}}, grep { $_->isa( 'Pipeline::Segment' ) } @$cleanup;
  } else {
    if ( $cleanup->onPlugin( $self )) {
      push @{$self->{cleanups}}, $cleanup;
    }
  }
}

##
## occurs when this gets plugged in to something.
##
sub onPlugin {
  my $self = shift;
  my $pipe = shift;  # this is the pipe it gets plugged in to.
  return 1;
}

sub segments {
  my $self = shift;
  return $self->{segments};

}

sub enter {
  my $self  = shift;
  my $store = shift;

  my $segments = shift || $self->segments();

  if (blessed($store) && $store->isa('Pipeline::Store')) {
    $self->{store} = $store;
  }

  ## for every element in the pipeline, if it is an element,
  ##  then we enter, otherwise, we dispatch.
  foreach my $element (@{ $segments }) {
    my @elements;
    if ($element->isa( 'Pipeline::Segment' )) {
      @elements = $self->dispatch( $element );
    } elsif ($element->isa( 'Pipeline' )) {
      @elements = $element->enter();
    } else {
#      warn "Pipeline element $element not Segment or Pipeline";
      next;
    }

    ## check for any cleanups, basically they need to be Pipeline::Segment objects to.
    my @cleanups   = grep { blessed( $_ ) && $_->isa( 'Pipeline::Segment' ) } @elements;
    $self->cleanup( [@cleanups] );

    ## check for any productions from the pipeline
    my @productions = map { $_->contains() }
      grep { blessed($_) && $_->isa( 'Pipeline::Production' ) } @elements;

    if (@productions) {

      ## terminate the pipeline, but run the cleanups first
      $self->exit( $store );

      if (wantarray && scalar(@productions) > 1) {
	return @productions;
      } elsif (scalar(@productions) > 1) {
	return [@productions];
      } else {
	return $productions[0];
      }
    } else {
      $self->{store}->set( @elements );
    }

  }
}

##
## runs cleanups
##
sub exit {
  my $self  = shift;
  my $store = shift;

  $self->enter( $store, $self->{cleanups} );
}

sub dispatch {
  my $self = shift;
  my $elem = shift;
  my @elements = $elem->enter( $self->store() );
  return @elements;
}


1;

=head1 NAME

Pipeline - Generic pipeline interface

=head1 SYNOPSIS

  use Pipeline;
  my $pipeline = Pipeline->new(
    store    => Pipeline::Store::Simple->new(),
    segments => [
      Pipeline::Segment->new(),
      Pipeline->new(
        Pipeline::Segment->new(),
        Pipeline::Segment->new(),
      ),
    ]
  );

  $pipeline->plugin( Pipeline::Segment->new() );
  my $output = $pipeline->enter();

=head1 DESCRIPTION

C<Pipelines> are a mechanism to process data. They are designed to be
plugged together to make fairly complex operations act in a fairly
straightforward manner.

=head1 USING THE PIPELINE MODULE

The usage of the generic pipeline module is fairly simple. You
instantiate a Pipeline object by using the I<new()> constructor.

Pipeline elements (segments or pipelines) can be added at construction time,
by placing them in the segments array, or afterwards by using the I<plugin()>
method.

The store that the Pipeline will use can be set by using the store parameter
to the constructor, or by calling the I<store()> method later on.  If a
store is not set by the time a pipeline is executing then it will use
a store of the type C<Pipeline::Store::Simple>

To start the pipeline running call the I<enter()> method on your Pipeline
object.

=head1 WRITING A PIPELINE

The pipeline module is designed to be an interface that can be
inherited from and implemented to meet the implementors requirements.
In order to do so the pipeline architecture has to be fairly
rigorously defined.  A Pipeline is a collection of Segments.  For most
purposes redefinition of the I<enter()> method in pipelines inheriting
from the Pipeline module should not be needed.  The most common method
to redefine is the I<dispatch()> method which handles idiosyncracies
of individual segment types.

The generic I<enter()> method calls the I<dispatch()> method with the
calling object (the Pipeline) and the element that it is calling to as
its arguments. It is expected that segments requiring changes in
dispatch semantics will be placed in separate pipelines inside the
main pipeline, thus removing the need make the dispatch method
overly complex.

Whenever the enter method is called - either on a Pipeline or a Pipeline
Segment - the first argument is the message reciever (the calling object)
and the second argument is the store.

=head1 AUTHOR

James A. Duncan <jduncan@fotango.com>

=head1 COPYRIGHT

Copyright 2002 Fotango Ltd.
Licensed under the same terms as Perl itself.

=cut

# comment booster
#
#
#
#
#
#
#
#
#
#
#
#
