use Test::Simple tests => 2;

use Pipeline;
use Pipeline::Segment;

package MyElem;

use base qw ( Pipeline::Base );

package MyTest;

use base qw ( Pipeline::Segment );

sub dispatch {
  my $self  = shift;
  my $pipe  = shift;
  my $store = $pipe->store();
  main::ok($store->get("MyElem"),"got expected elem from store");
}

package main;

my $storeelem = MyElem->new();
my $pipe1 = Pipeline->new();
my $pipe2 = Pipeline->new();

$pipe2->add_segment( MyTest->new() );
$pipe1->add_segment( MyTest->new() );

$pipe1->store()->set($storeelem);
$pipe1->add_segment( $pipe2 );

$pipe1->dispatch();