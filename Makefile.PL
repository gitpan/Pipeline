use ExtUtils::MakeMaker;

# Enable "make cover" target
sub MY::postamble {
  return <<EOF
cover:
\trm -rf cover_db
\tPERL5OPT=-MDevel::Cover make test || true
\tcover -report html cover_db > /dev/null
EOF
}

WriteMakefile(
	      NAME => 'Pipeline',
	      VERSION_FROM => 'lib/Pipeline.pm',
	      PREREQ_PM => {
			    Scalar::Util => '0.01',
			    Class::ISA   => '0.01',
			    Test::More => '0.01',
			   }
	     );

1;

