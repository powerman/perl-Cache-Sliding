[![Build Status](https://travis-ci.org/powerman/perl-Cache-Sliding.svg?branch=master)](https://travis-ci.org/powerman/perl-Cache-Sliding)
[![Coverage Status](https://coveralls.io/repos/powerman/perl-Cache-Sliding/badge.svg?branch=master)](https://coveralls.io/r/powerman/perl-Cache-Sliding?branch=master)

# NAME

Cache::Sliding - Cache using sliding time-based expiration strategy

# VERSION

This document describes Cache::Sliding version v2.0.0

# SYNOPSIS

    use Cache::Sliding;

    $cache = Cache::Sliding->new(10*60);

    $cache->set($key, $value);
    $value = $cache->get($key);
    $cache->del($key);

# DESCRIPTION

Implement caching object using sliding time-based expiration strategy
(data in the cache is invalidated by specifying the amount of time the
item is allowed to be idle in the cache after last access time).

Use EV::timer, so this module only useful in EV-based applications,
because cache expiration will work only while you inside EV::loop.

# INTERFACE 

## new

    $cache = Cache::Sliding->new( $expire_after );

Create and return new cache object. Elements in this cache will expire
between $expire\_after seconds and 2\*$expire\_after seconds.

## set

    $cache->set( $key, $value );

Add new item into cache. Will replace existing item for that $key, if any.

## get

    $value = $cache->get( $key );

Return value of cached item for $key. If there no cached item for that $key
return nothing.

For example, if you may keep undefined values in cache and still wanna be
able to check is item was found in cache:

    $cache->set( 'item 1', undef );
    $val = $cache->get( 'item 1' );  # $val is undef
    @val = $cache->get( 'item 1' );  # @val is (undef)
    $val = $cache->get( 'nosuch' );  # $val is undef
    @val = $cache->get( 'nosuch' );  # @val is ()

## del

    $cache->del( $key );

Remove item for $key from cache, if any. Return nothing.

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/powerman/perl-Cache-Sliding/issues](https://github.com/powerman/perl-Cache-Sliding/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.
Feel free to fork the repository and submit pull requests.

[https://github.com/powerman/perl-Cache-Sliding](https://github.com/powerman/perl-Cache-Sliding)

    git clone https://github.com/powerman/perl-Cache-Sliding.git

## Resources

- MetaCPAN Search

    [https://metacpan.org/search?q=Cache-Sliding](https://metacpan.org/search?q=Cache-Sliding)

- CPAN Ratings

    [http://cpanratings.perl.org/dist/Cache-Sliding](http://cpanratings.perl.org/dist/Cache-Sliding)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Cache-Sliding](http://annocpan.org/dist/Cache-Sliding)

- CPAN Testers Matrix

    [http://matrix.cpantesters.org/?dist=Cache-Sliding](http://matrix.cpantesters.org/?dist=Cache-Sliding)

- CPANTS: A CPAN Testing Service (Kwalitee)

    [http://cpants.cpanauthors.org/dist/Cache-Sliding](http://cpants.cpanauthors.org/dist/Cache-Sliding)

# AUTHOR

Alex Efros &lt;powerman@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2009- by Alex Efros &lt;powerman@cpan.org>.

This is free software, licensed under:

    The MIT (X11) License
