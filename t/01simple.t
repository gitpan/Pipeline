use lib './lib';
use lib 't/lib';

use MyPipe;
use MyPipeCleanup;
use Pipeline;
use Test::Simple tests => 3;

my $pipeline  = Pipeline->new();
my $pipeline2 = Pipeline->new();

$pipeline2->add_segment( MyPipe->new() );
$pipeline->add_segment( MyPipe->new(), MyPipe->new(), $pipeline2 );						

ok($pipeline, "we have a pipeline");
my $production = $pipeline->dispatch();
ok(ref($production) eq 'MyPipe', "valid production received");
ok($MyPipe::instance == 0, "cleanup was executed (instance was set to zero)\n");
