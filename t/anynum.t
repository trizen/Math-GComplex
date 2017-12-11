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

plan tests => 13;

use Math::GComplex;
use Math::AnyNum qw(:overload);

my $x = Math::GComplex->new(3, 4);
my $y = Math::GComplex->new(7, 5);

is($x + $y, '(10 9)');
is($x - $y, '(-4 -1)');
is($x * $y, '(1 43)');
is($x / $y, '(41/74 13/74)');

is($x->conj, '(3 -4)');
is(-$y,      '(-7 -5)');

is(join(' ', log($x)->reals), join(' ', log(3 + 4 * i)->reals));
is(join(' ', log($y)->reals), join(' ', log(7 + 5 * i)->reals));

is(join(' ', log($x->conj)->reals),    join(' ', log(3 - 4 * i)->reals));
is(join(' ', log(-$x)->reals),         join(' ', log(-3 - 4 * i)->reals));
is(join(' ', log(-($x->conj))->reals), join(' ', log(-3 + 4 * i)->reals));

is(join(' ', abs($x)->reals), '5 0');
is(join(' ', abs($y)->reals), join(' ', abs(7 + 5 * i)->reals));
