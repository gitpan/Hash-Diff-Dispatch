use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Hash::Diff::Dispatch',
    'VERSION_FROM'	=> 'lib/Hash/Diff/Dispatch.pm', # finds $VERSION
    'PREREQ_PM'		=> {
			'Test::More' => '0.01',
			'Clone'      => '0.01',
		}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Hash/Diff/Dispatch.pm', # retrieve abstract from module
       AUTHOR     => 'Pete Sergeant - <pete@clueball.com>') : ()),
			 
);
