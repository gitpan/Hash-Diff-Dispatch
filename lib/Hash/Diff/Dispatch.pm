package Hash::Diff::Dispatch;

	use strict;
	use warnings;
	
	use Clone qw(clone);;

	our $VERSION = '0.01';

=head1 TITLE

Hash::Diff::Dispatch - execute code depending on difference between hashes

=head1 DESCRIPTION

Execute code based on the difference between the saved version of a hash
and a new one

=head1 SYNOPSIS

 my $hash_watcher = Hash::Diff::Dispatch->new(

 	{}, # Sets the starting hash
 
 	# The events will be called using the order returned
 	# by calling 'keys' on these values...
 	
 	'b' => \&bold,
 	'i' => \&italic,

 );


 # Will call: bold('on', 5)
 $hash_watcher->update( { b => 5, a => 'la' } );

 # Will call: bold('changed', 6)
 $hash_watcher->update( { b => 6 } );

 # Will call: bold('changed', 0)
 $hash_watcher->update( { b => 0 } );

 # Will call: bold('off')
 $hash_watcher->update( {} );

=head1 METHODS

=head2 new

Accepts a starting hash-ref, and then a list of keys you want to watch,
and the code to execute when they change. It will take a copy of the hash
in the hash-ref you specify.

=cut

sub new {

	my $class = shift;
	
	my $self = {};
		
	$self->{_hash_ref} = clone( shift() );
	
	$self->{_events} = { @_  };
	
	# Little optimization
	$self->{_watched_keys} = [ keys %{ $self->{_events} } ];
	
	bless $self, $class;

	return $self;

}

=head2 update

Accepts a hash-ref, which it'll take a copy of, and make it the 'saved'
hash to check the next call to C<update> again.

If a key's value has changed, it'll execute the code specified when you
created the object. If the key exists where it didn't before, it'll pass
'on' as the first argument, and the new value as the second. If it's changed,
'changed' and the new value. If it's been deleted, it'll pass 'off'.

=cut

sub update {

	my $self = shift;
	
	my $new_hash = clone( shift() );	

	my $old_hash = $self->{_hash_ref};

	for my $key ( @{ $self->{_watched_keys} } ) {

		# Does the key have a value?
		if ( defined( $new_hash->{ $key } ) ) {
		
			# Did it used to?
			if ( defined($old_hash->{ $key }) ) {
			
				$self->{_events}->{$key}->('changed', $new_hash->{ $key } )
					unless $new_hash->{ $key } eq $old_hash->{ $key };
			
			} else {
			
				$self->{_events}->{$key}->('on', $new_hash->{ $key } );
			
			}
					
		} else {
		
			if ( defined($old_hash->{ $key }) ) {
			
				$self->{_events}->{$key}->('off');				
			
			}
		
		}
			
	}

	$self->{_hash_ref} = $new_hash;

}

=head1 AUTHOR

Pete Sergeant - L<pete@clueball.com>

=head1 LICENSE

As Perl.

=cut

1;
