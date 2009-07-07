use inc::Module::Install;

name     'Cache-Sliding';
all_from 'lib/Cache/Sliding.pm';
author   'Alex Efros <powerman-asdf@ya.ru>';
license  'perl';

requires 'version';
requires 'EV';

build_requires 'Test::More';

auto_install;

WriteAll;

