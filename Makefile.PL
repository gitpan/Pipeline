use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => 'Pipeline',
	      VERSION_FROM => 'lib/Pipeline.pm',
	      PREREQ_PM => {
			    Scalar::Util => '0.01',
			   }
	     );

1;

