use lib './lib';
use lib 't/lib';

use MyPipe;
use MyPipeCleanup;
use Pipeline::Robust;
use Test::Simple tests => 3;

my $pipeline = Pipeline::Robust->new(
				     segments => [
						  MyPipe->new(),
						  MyPipe->new(),
						  Pipeline->new(
								segments => [
									     MyPipe->new(),
									    ],
							       )
						 ],
				    );

ok($pipeline, "we have a robust pipeline");
my $production = $pipeline->enter();
ok(ref($production) eq 'MyPipe', "valid production received");
ok($MyPipe::instance == 0, "cleanup was executed (instance was set to zero)\n");
