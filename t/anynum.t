#!perl -T

use 5.006;
use strict;
use warnings;
use Test::More;

BEGIN {
    eval { require Math::AnyNum };
    plan skip_all => "Math::AnyNum is not installed"
        if $@;
}

plan tests => 5;

use Math::GComplex;
use Math::AnyNum qw(:overload);

my $x = Math::GComplex->new(3, 4);
my $y = Math::GComplex->new(7, 5);

is($x + $y, '(10 9)');
is($x - $y, '(-4 -1)');
is($x * $y, '(1 43)');
is($x / $y, '(41/74 13/74)');

is($x->conj, '(3 -4)');
