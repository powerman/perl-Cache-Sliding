use Test::More tests => 10;

use Cache::Sliding;

my $cache1 = Cache::Sliding->new(0.1);
my $cache2 = Cache::Sliding->new(0.2);
my $cache5 = Cache::Sliding->new(0.5);

$cache1->set('test', 1);
$cache2->set('test', 2);
$cache5->set('test', 5);

my @t = (
    EV::timer(0.1, 0, sub { is($cache1->get('test'), 1)        }),
    EV::timer(0.1, 0, sub { is($cache2->get('test'), 2)        }),
    EV::timer(0.1, 0, sub { is($cache5->get('test'), 5)        }),
    EV::timer(0.2, 0, sub { is($cache1->get('test'), 1)        }),
    EV::timer(0.2, 0, sub { $cache2->del('test')               }),
    EV::timer(0.3, 0, sub { is($cache1->get('test'), 1)        }),
    EV::timer(0.3, 0, sub { is($cache2->get('test'), undef)    }),
    EV::timer(0.3, 0, sub { is($cache5->get('test'), 5)        }),
    EV::timer(0.4, 0, sub { is($cache1->get('test'), 1)        }),
    EV::timer(0.7, 0, sub { is($cache1->get('test'), undef)    }),
    EV::timer(1.5, 0, sub { is($cache5->get('test'), undef)    }),
    EV::timer(2,   0, sub { EV::unloop                         }),
);

EV::loop;
