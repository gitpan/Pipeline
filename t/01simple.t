#!/usr/bin/perl -w
use strict;

# Test that a simple pipeline made out of segments and a subpipeline
# works correctly (and has a cleanup segment run properly)

use lib './lib';
use lib 't/lib';

use MyPipe;
use MyPipeCleanup;
use Pipeline;
use Test::Simple tests => 3;

my $pipeline  = Pipeline->new();
my $subpipeline = Pipeline->new();

$subpipeline->add_segment( MyPipe->new() );
$pipeline->add_segment( MyPipe->new(), MyPipe->new(), $subpipeline );						

ok($pipeline, "we have a pipeline");
my $production = $pipeline->dispatch();
ok(ref($production) eq 'MyPipe', "valid production received");
ok(
   !defined($MyPipe::instance), #  && $MyPipe::instance == 0,
   "cleanup was executed (instance was set to zero)\n"
  );




























