#!/usr/bin/perl -w

use strict;

BEGIN {
  no warnings qw ( uninitialized );
  eval {
    require Acme::Colour;
  };
  if ($@) {
    print "1..0 # Skipped - do not have Acme::Colour installed\n";
    exit;
  }
}

use lib './lib';
use lib 't/lib';
use Dye;
use Tap;
use Water;
use Pipeline;
use Test::Simple tests => 6;

my $water = Water->new();
ok(ref($water) eq 'Water', "should get water object");
ok($water->colour eq 'clear', "water should be clear");
$water->colour("red");
ok($water->colour eq 'red', "water should be red");
my $pipeline = Pipeline->new();
$pipeline->add_segment(
		       Tap->new(type => 'in'  ),
		       Dye->new( ink => 'red' ),
		       Dye->new( ink => 'blue'),
		       Tap->new(type => 'out' ),
		      );
ok($pipeline, "we have a pipeline");
my $production = $pipeline->dispatch();
ok(ref($production) eq 'Water', "should get water out of the pipe");
ok($production->colour eq 'dark magenta', "should get dark magenta water out");
#print $production->colour;
