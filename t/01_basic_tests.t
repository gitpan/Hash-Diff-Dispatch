
use strict;
use warnings;

use Hash::Diff::Dispatch;
use Test::More tests => 8;

my $test1;
my $test2;

sub test_set { ($test1, $test2) = @_ } 

{

	my $hash = { a => 'b', b => 'd' };

	my $object = Hash::Diff::Dispatch->new(

		$hash,
		b => \&test_set,
		a => \&test_set,
		i => \&test_set,

	);

	isa_ok( $object, 'Hash::Diff::Dispatch' );
	
	$object->update( { a => 'b', b => 'c' } );

	is( $test1, 'changed', "First key changed" );
	is( $test2, 'c',       "First value changed" );


	$object->update( { a => 'b', b => '0' } );
  
	is( $test1, 'changed', "First key changed" );
	is( $test2, '0',       "First value changed" );

  $object->update( { a => 'b' } );
	  
	is( $test1, 'off', "First key changed" );

	$test1 = 'blank'; $test2 = 'blank';

	$object->update( { a => 'b', i => 'asdf' } );
		  
	is( $test1, 'on', "First key changed" );
	is( $test2, 'asdf',       "First value changed" );

}
