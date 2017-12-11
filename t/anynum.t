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

plan tests => 71;

use Math::GComplex;
use Math::AnyNum qw(:overload);

my $x = Math::GComplex->new(3, 4);
my $y = Math::GComplex->new(7, 5);

is(join(' ', ($x + $y)->reals), '10 9');
is(join(' ', ($x - $y)->reals), '-4 -1');
is(join(' ', ($x * $y)->reals), '1 43');
is(join(' ', ($x / $y)->reals), '41/74 13/74');

is(join(' ', $x->conj->reals), '3 -4');
is(join(' ', (-$y)->reals), '-7 -5');

is(join(' ', log($x)->reals), join(' ', log(3 + 4 * i)->reals));
is(join(' ', log($y)->reals), join(' ', log(7 + 5 * i)->reals));

is(join(' ', log($x->conj)->reals),    join(' ', log(3 - 4 * i)->reals));
is(join(' ', log(-$x)->reals),         join(' ', log(-3 - 4 * i)->reals));
is(join(' ', log(-($x->conj))->reals), join(' ', log(-3 + 4 * i)->reals));

is(join(' ', abs($x)->reals), '5 0');
is(join(' ', abs($y)->reals), join(' ', abs(7 + 5 * i)->reals));

is(join(' ', $x->sgn->reals),      '0.6 0.8');
is(join(' ', $x->neg->sgn->reals), '-0.6 -0.8');
is(join(' ', Math::GComplex->new(0, 0)->sgn->reals), '0 0');

is(join(' ', sin($x)->reals),            join(' ', sin(3 + 4 * i)->reals));
is(join(' ', sin($x->conj)->reals),      join(' ', sin(3 - 4 * i)->reals));
is(join(' ', sin($x->neg->conj)->reals), join(' ', sin(-3 + 4 * i)->reals));

is(join(' ', cos($x)->reals),            join(' ', cos(3 + 4 * i)->reals));
is(join(' ', cos($x->conj)->reals),      join(' ', cos(3 - 4 * i)->reals));
is(join(' ', cos($x->neg->conj)->reals), join(' ', cos(-3 + 4 * i)->reals));

is(join(' ', ($x**$y)->reals), join(' ', ((3 + 4 * i)**(7 + 5 * i))->reals));
is(join(' ', Math::GComplex->new(-0.123, 0)->pow(0.42)->reals), join(' ', ((-0.123)**0.42)->reals));
is(join(' ', Math::GComplex->new(3, 0)->pow(Math::GComplex->new(0, 5))->reals), join(' ', (3**(5 * i))->reals));
is(join(' ', Math::GComplex->new(3, 0)->pow(Math::GComplex->new(5, 0))->reals), '243 0');

is(join(' ', exp($x)->reals),      join(' ', exp(3 + 4 * i)->reals));
is(join(' ', exp($x->neg)->reals), join(' ', exp(-3 - 4 * i)->reals));

is(join(' ', Math::GComplex->new(13, 0)->sin->reals),  join(' ', sin(13)->reals));
is(join(' ', Math::GComplex->new(0,  13)->sin->reals), join(' ', sin(13 * i)->reals));

is(join(' ', Math::GComplex->new(13, 0)->cos->reals),  join(' ', cos(13)->reals));
is(join(' ', Math::GComplex->new(0,  13)->cos->reals), join(' ', cos(13 * i)->reals));

is(join(' ', map { $_->round(-50) } sqrt(Math::GComplex->new(-1, 0))->reals), '0 1');
is(join(' ', map { $_->round(-50) } sqrt(Math::GComplex->new(-4, 0))->reals), '0 2');

is(join(' ', $x->sqrt->reals), '2 1');
is(join(' ', $y->neg->sqrt->reals),       join(' ', sqrt(-7 - 5 * i)->reals));
is(join(' ', $y->neg->conj->sqrt->reals), join(' ', sqrt(-7 + 5 * i)->reals));

is(join(' ', $x->asin->reals),            join(' ', (3 + 4 * i)->asin->reals));
is(join(' ', $x->conj->asin->reals),      join(' ', (3 - 4 * i)->asin->reals));
is(join(' ', $x->neg->conj->asin->reals), join(' ', (-3 + 4 * i)->asin->reals));

is(join(' ', $y->sinh->reals),            join(' ', (7 + 5 * i)->sinh->reals));
is(join(' ', $y->conj->sinh->reals),      join(' ', (7 - 5 * i)->sinh->reals));
is(join(' ', $y->neg->conj->sinh->reals), join(' ', (-7 + 5 * i)->sinh->reals));

is(join(' ', $y->cosh->reals),            join(' ', (7 + 5 * i)->cosh->reals));
is(join(' ', $y->conj->cosh->reals),      join(' ', (7 - 5 * i)->cosh->reals));
is(join(' ', $y->neg->conj->cosh->reals), join(' ', (-7 + 5 * i)->cosh->reals));

is(join(' ', $y->asinh->reals),            join(' ', (7 + 5 * i)->asinh->reals));
is(join(' ', $y->conj->asinh->reals),      join(' ', (7 - 5 * i)->asinh->reals));
is(join(' ', $y->neg->conj->asinh->reals), join(' ', (-7 + 5 * i)->asinh->reals));

is(join(' ', $y->acosh->reals),            join(' ', (7 + 5 * i)->acosh->reals));
is(join(' ', $y->conj->acosh->reals),      join(' ', (7 - 5 * i)->acosh->reals));
is(join(' ', $y->neg->conj->acosh->reals), join(' ', (-7 + 5 * i)->acosh->reals));

is(join(' ', $y->acos->reals),            join(' ', (7 + 5 * i)->acos->reals));
is(join(' ', $y->conj->acos->reals),      join(' ', (7 - 5 * i)->acos->reals));
is(join(' ', $y->neg->conj->acos->reals), join(' ', (-7 + 5 * i)->acos->reals));

is(join(' ', $y->tan->reals),            join(' ', (7 + 5 * i)->tan->reals));
is(join(' ', $y->tan->conj->reals),      join(' ', (7 - 5 * i)->tan->reals));
is(join(' ', $y->tan->neg->conj->reals), join(' ', (-7 + 5 * i)->tan->reals));

is(join(' ', $y->tanh->reals),            join(' ', (7 + 5 * i)->tanh->reals));
is(join(' ', $y->tanh->conj->reals),      join(' ', (7 - 5 * i)->tanh->reals));
is(join(' ', $y->tanh->neg->conj->reals), join(' ', (-7 + 5 * i)->tanh->reals));

is(join(' ', $y->atanh->reals),            join(' ', (7 + 5 * i)->atanh->reals));
is(join(' ', $y->atanh->conj->reals),      join(' ', (7 - 5 * i)->atanh->reals));
is(join(' ', $y->atanh->neg->conj->reals), join(' ', (-7 + 5 * i)->atanh->reals));

is(join(' ', $y->atan->reals),            join(' ', (7 + 5 * i)->atan->reals));
is(join(' ', $y->conj->atan->reals),      join(' ', (7 - 5 * i)->atan->reals));
is(join(' ', $y->neg->conj->atan->reals), join(' ', (-7 + 5 * i)->atan->reals));

is(join(' ', map { $_->round(-50) } Math::GComplex->new(1 / 2,  0)->asin->reals), join(' ', (0.5)->asin->reals));
is(join(' ', map { $_->round(-50) } Math::GComplex->new(-1 / 2, 0)->asin->reals), join(' ', (-0.5)->asin->reals));

is(join(' ', map { $_->round(-50) } Math::GComplex->new(0, 1 / 2)->asin->reals),  join(' ', (0.5 * i)->asin->reals));
is(join(' ', map { $_->round(-50) } Math::GComplex->new(0, -1 / 2)->asin->reals), join(' ', (-0.5 * i)->asin->reals));
