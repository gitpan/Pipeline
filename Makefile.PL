use ExtUtils::MakeMaker;
# $Header: /var/repository/pipeline/Makefile.PL,v 1.1 2002/02/19 17:35:25 james Exp $

WriteMakefile(
    NAME	 => "Pipeline",
    VERSION_FROM => 'lib/Pipeline.pm',
    PREREQ_PM    => {
		     Scalar::Util         => 0.01,
		    },
);


