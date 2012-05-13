package Cache::Sliding;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('1.0.1');    # update POD & Changes & README

# update DEPENDENCIES in POD & Makefile.PL & README
use Scalar::Util qw( weaken );
use EV;


sub new {
    my ($class, $expire_after) = @_;
    my $self = {
        L1      => {},
        L2      => {},
        t       => undef,
    };
    weaken(my $this = $self);
    $self->{t} = EV::timer $expire_after, $expire_after, sub { if ($this) {
        $this->{L2} = $this->{L1};
        $this->{L1} = {};
    } };
    return bless $self, $class;
}

sub get {
    my ($self, $key) = @_;
    if (exists $self->{L1}{$key}) {
        return $self->{L1}{$key};
    }
    elsif (exists $self->{L2}{$key}) {
        return ($self->{L1}{$key} = delete $self->{L2}{$key});
    }
    return;
}

sub set {   ## no critic (ProhibitAmbiguousNames)
    my ($self, $key, $value) = @_;
    return ($self->{L1}{$key} = $value);
}

sub del {
    my ($self, $key) = @_;
    delete $self->{L2}{$key};
    delete $self->{L1}{$key};
    return;
}


1; # Magic true value required at end of module
__END__

=head1 NAME

Cache::Sliding - Cache using sliding time-based expiration strategy


=head1 VERSION

This document describes Cache::Sliding version 1.0.1


=head1 SYNOPSIS

    use Cache::Sliding;

    $cache = Cache::Sliding->new(10*60);

    $cache->set($key, $value);
    $value = $cache->get($key);
    $cache->del($key);


=head1 DESCRIPTION

Implement caching object using sliding time-based expiration strategy
(data in the cache is invalidated by specifying the amount of time the
item is allowed to be idle in the cache after last access time).

Use EV::timer, so this module only useful in EV-based applications,
because cache expiration will work only while you inside EV::loop.


=head1 INTERFACE 

=over

=item new( $expire_after )

Create and return new cache object. Elements in this cache will expire
between $expire_after seconds and 2*$expire_after seconds.

=item set( $key, $value )

Add new item into cache. Will replace existing item for that $key, if any.

=item get( $key )

Return value of cached item for $key. If there no cached item for that $key
return nothing.

For example, if you may keep undefined values in cache and still wanna be
able to check is item was found in cache:

 $cache->set( 'item 1', undef );
 $val = $cache->get( 'item 1' );  # $val is undef
 @val = $cache->get( 'item 1' );  # @val is (undef)
 $val = $cache->get( 'nosuch' );  # $val is undef
 @val = $cache->get( 'nosuch' );  # @val is ()

=item del( $key )

Remove item for $key from cache, if any. Return nothing.

=back


=head1 DIAGNOSTICS

None.


=head1 CONFIGURATION AND ENVIRONMENT

Cache::Sliding requires no configuration files or environment variables.


=head1 DEPENDENCIES

 version
 EV

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-cache-sliding@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Alex Efros  C<< <powerman-asdf@ya.ru> >>


=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Alex Efros C<< <powerman-asdf@ya.ru> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
