#!/usr/bin/perl -w

use strict;
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

my $pipeline = Pipeline->new(
			     segments => [
					  Tap->new(type => 'in'),
					  Dye->new(ink => 'green'),
					  Tap->new(type => 'out'),
					 ],
			    );

ok($pipeline, "we have a pipeline");
my $production = $pipeline->enter();
ok(ref($production) eq 'Water', "should get water out of the pipe");
ok($production->colour eq 'green', "should get green water out");
