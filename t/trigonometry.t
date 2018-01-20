#!perl -T

use 5.010;
use strict;
use warnings;
use Test::More;

## Tests from Math::Complex / Math::Trig (+ some additional ones)
## https://metacpan.org/source/ZEFRAM/Math-Complex-1.59/t/Trig.t

use Math::GComplex qw(:trig :special i);

plan tests => 214;

my $eps = 1e-10;

sub near ($$;$) {
    my $e = $_[2] // $eps;
    my $d = $_[1] ? abs($_[0] / $_[1] - 1) : abs($_[0]);
    $_[1] ? ($d < $e) : abs($_[0]) < $e;
}

ok(near(sin(1), 0.841470984807897));
ok(near(cos(1), 0.54030230586814));
ok(near(tan(1), 1.5574077246549));

ok(near(sec(1), 1.85081571768093));
ok(near(csc(1), 1.18839510577812));
ok(near(cot(1), 0.642092615934331));

ok(near(asin(1), 1.5707963267949));
ok(near(acos(1), 0));
ok(near(atan(1), 0.785398163397448));

ok(near(asec(1), 0));
ok(near(acsc(1), 1.5707963267949));
ok(near(acot(1), 0.785398163397448));

ok(near(sinh(1), 1.1752011936438));
ok(near(cosh(1), 1.54308063481524));
ok(near(tanh(1), 0.761594155955765));

ok(near(sech(1), 0.648054273663885));
ok(near(csch(1), 0.850918128239322));
ok(near(coth(1), 1.31303528549933));

ok(near(asinh(1),   0.881373587019543));
ok(near(acosh(1),   0));
ok(near(atanh(0.9), 1.47221948958322));

ok(near(asech(0.9), 0.467145308103262));
ok(near(acsch(2),   0.481211825059603));
ok(near(acoth(2),   0.549306144334055));

my $x = 0.9;
ok(near(tan($x), sin($x) / cos($x)));

ok(near(sinh(2),    3.62686040784702));
ok(near(acsch(0.1), 2.99822295029797));

$x = asin(2);
is(ref($x), 'Math::GComplex');

my ($y, $z) = $x->reals;
ok(near($y, 1.5707963267949));
ok(near($z, -1.31695789692482));

ok(near(deg2rad(90), atan2(0, -1) / 2));
ok(near(rad2deg(atan2(0, -1)), 180));

is(deg2rad(0), '(0 0)');
is(rad2deg(0), '(0 0)');

ok(near(deg2rad(-45), -atan2(0, -1) / 4));
ok(near(rad2deg(-atan2(0, -1) / 4), -45));

is(deg2rad(rad2deg(-10)), '(-10 0)');
is(rad2deg(deg2rad(-10)), '(-10 0)');

is(deg2rad(rad2deg(0)), '(0 0)');
is(rad2deg(deg2rad(0)), '(0 0)');

ok(near(sinh(100), 1.3441e+43, 1e-3));
ok(near(sech(100), 7.4402e-44, 1e-3));
ok(near(cosh(100), 1.3441e+43, 1e-3));
ok(near(csch(100), 7.4402e-44, 1e-3));
ok(near(tanh(100), 1));
ok(near(coth(100), 1));

ok(near(sinh(-100), -1.3441e+43, 1e-3));
ok(near(sech(-100), 7.4402e-44,  1e-3));
ok(near(cosh(-100), 1.3441e+43,  1e-3));
ok(near(csch(-100), -7.4402e-44, 1e-3));
ok(near(tanh(-100), -1));
ok(near(coth(-100), -1));

#cmp_ok(sech(1e5), '==', 0);
#cmp_ok(csch(1e5), '==', 0);
#cmp_ok(tanh(1e5), '==', 1);
#cmp_ok(coth(1e5), '==', 1);

cmp_ok(sech(-1e5), '==', 0);
cmp_ok(csch(-1e5), '==', 0);
cmp_ok(tanh(-1e5), '==', -1);
cmp_ok(coth(-1e5), '==', -1);

#~ ok(acos(-2.0)->real == 4 * atan2(4, 4));
#~ ok(acos(-1.0)->real == 4 * atan2(4, 4));
#~ ok(acos(-0.5)->real == acos(-0.5));
#~ ok(acos(0.0)->real == 2 * atan2(4, 4));
#~ ok(acos(0.5)->real == acos(0.5));
#~ ok(acos(1.0)->real == 0);
#~ ok(near(acos(2.0)->real, 0));

#~ ok(asin(-0.5)->real == asin(-0.5));
#~ ok(asin(0.0)->real == asin(0.0));
#~ ok(asin(0.5)->real == asin(0.5));

for my $iter (1 .. 3) {

    my $z = Math::GComplex->new(rand(5), rand(5));
    my $n = Math::GComplex->new(rand(5), rand(5));

    if ($iter == 2) {
        eval { require Math::AnyNum; };

        if (!$@) {
            $z->{a} = Math::AnyNum::rand(5);
            $z->{b} = Math::AnyNum::rand(5);

            $n->{a} = Math::AnyNum::rand(5);
            $n->{b} = Math::AnyNum::rand(5);
        }
    }

    if (rand(1) < 0.5) {
        $z->{a} = -$z->{a};
    }

    if (rand(1) < 0.5) {
        $z->{b} = -$z->{a};
    }

    ok(near(cbrt($z), $z**(1 / 3)));
    ok(near(cbrt($z), root($z, 3)));

    ok(near(logn($z, $n), log($z) / log($n)));

    ok(near(tan($z), sin($z) / cos($z)));

    ok(near(csc($z), 1 / sin($z)));
    ok(near(sec($z), 1 / cos($z)));

    ok(near(cot($z), 1 / tan($z)));

    ok(near(asin($z), -i * log(i * $z + sqrt(1 - $z**2))));
    ok(near(acos($z), -i * log($z + i * sqrt(1 - $z**2))));

    ok(near(atan($z), i / 2 * log((i + $z) / (i- $z))));

    ok(near(acsc($z), asin(1 / $z)));
    ok(near(asec($z), acos(1 / $z)));
    ok(near(acot($z), atan(1 / $z)));
    ok(near(acot($z), -i / 2 * log((i + $z) / ($z -i))));

    ok(near(sinh($z), 1 / 2 * (exp($z) - exp(-$z))));
    ok(near(cosh($z), 1 / 2 * (exp($z) + exp(-$z))));
    ok(near(tanh($z), sinh($z) / cosh($z)));
    ok(near(tanh($z), (exp($z) - exp(-$z)) / (exp($z) + exp(-$z))));

    ok(near(csch($z), 1 / sinh($z)));
    ok(near(sech($z), 1 / cosh($z)));
    ok(near(coth($z), 1 / tanh($z)));

    ok(near(asinh($z), log($z + sqrt($z**2 + 1))));
    ok(near(acosh($z), log($z + sqrt($z - 1) * sqrt($z + 1))));
    ok(near(atanh($z), 1 / 2 * log((1 + $z) / (1 - $z))));

    ok(near(acsch($z), asinh(1 / $z)));
    ok(near(asech($z), acosh(1 / $z)));
    ok(near(acoth($z), atanh(1 / $z)));
    ok(near(acoth($z), 1 / 2 * log((1 + $z) / ($z - 1))));
}

# More trigonometric tests
#   http://rosettacode.org/wiki/Trigonometric_functions#Perl

{
    my $theta = atan2(0, -1) / 4;

    ok(near(sin($theta), 0.707106781186547), 'sin(x)');
    ok(near(cos($theta), 0.707106781186548), 'cos(x)');

    is(tan($theta), '(1 0)', 'tan(x)');
    is(cot($theta), '(1 0)', 'cot(x)');

    ok(near(asin(sin($theta)), 0.785398163397448), 'asin(sin(x))');
    ok(near(acos(cos($theta)), 0.785398163397448), 'acos(cos(x))');
    ok(near(atan(tan($theta)), 0.785398163397448), 'atan(tan(x))');
    ok(near(acot(cot($theta)), 0.785398163397448), 'acot(cot(x))');
    ok(near(asec(sec($theta)), 0.785398163397448), 'asec(sec(x))');
    ok(near(acsc(csc($theta)), 0.785398163397448), 'acsc(csc(x))');
}

{
    my $z1 = Math::GComplex->new(0.5,  0.3);
    my $z2 = Math::GComplex->new(0.5,  -0.3);
    my $z3 = Math::GComplex->new(-0.5, 0.3);
    my $z4 = Math::GComplex->new(-0.5, -0.3);

    # asin(sin(x)) = x  for |x| < 1
    is(join(' ', sin($z1)->asin->reals), '0.5 0.3');
    is(join(' ', sin($z2)->asin->reals), '0.5 -0.3');
    is(join(' ', sin($z3)->asin->reals), '-0.5 0.3');
    is(join(' ', sin($z4)->asin->reals), '-0.5 -0.3');

    # acos(cos(x)) = x  for |x| < 1
    is(join(' ', cos($z1)->acos->reals), '0.5 0.3');
    is(join(' ', cos($z2)->acos->reals), '0.5 -0.3');
    is(join(' ', cos($z3)->acos->reals), '0.5 -0.3');    # this is correct
    is(join(' ', cos($z4)->acos->reals), '0.5 0.3');     # =//=

    # sin(asin(x)) = x  for |x| < pi/2
    is(join(' ', sin($z1->asin)->reals), '0.5 0.3');
    is(join(' ', sin($z2->asin)->reals), '0.5 -0.3');
    is(join(' ', sin($z3->asin)->reals), '-0.5 0.3');
    is(join(' ', sin($z4->asin)->reals), '-0.5 -0.3');

    # cos(acos(x)) = x  for |x| < pi/2
    is(join(' ', cos($z1->acos)->reals), '0.5 0.3');
    is(join(' ', cos($z2->acos)->reals), '0.5 -0.3');
    is(join(' ', cos($z3->acos)->reals), '-0.5 0.3');
    is(join(' ', cos($z4->acos)->reals), '-0.5 -0.3');

    # atan(tan(x)) = x
    is(join(' ', $z1->atan->tan->reals), '0.5 0.3');
    is(join(' ', $z2->atan->tan->reals), '0.5 -0.3');
    is(join(' ', $z3->atan->tan->reals), '-0.5 0.3');
    is(join(' ', $z4->atan->tan->reals), '-0.5 -0.3');

    # tan(atan(x)) = x
    is(join(' ', $z1->tan->atan->reals), '0.5 0.3');
    is(join(' ', $z2->tan->atan->reals), '0.5 -0.3');
    is(join(' ', $z3->tan->atan->reals), '-0.5 0.3');
    is(join(' ', $z4->tan->atan->reals), '-0.5 -0.3');

    # acot(cot(x)) = x
    is(join(' ', $z1->acot->cot->reals), '0.5 0.3');
    is(join(' ', $z2->acot->cot->reals), '0.5 -0.3');
    is(join(' ', $z3->acot->cot->reals), '-0.5 0.3');
    is(join(' ', $z4->acot->cot->reals), '-0.5 -0.3');

    # cot(acot(x)) = x
    is(join(' ', $z1->cot->acot->reals), '0.5 0.3');
    is(join(' ', $z2->cot->acot->reals), '0.5 -0.3');
    is(join(' ', $z3->cot->acot->reals), '-0.5 0.3');
    is(join(' ', $z4->cot->acot->reals), '-0.5 -0.3');

    # asec(sec(x)) = x
    is(join(' ', $z1->sec->asec->reals), '0.5 0.3');
    is(join(' ', $z2->sec->asec->reals), '0.5 -0.3');
    is(join(' ', $z3->sec->asec->reals), '0.5 -0.3');    # this is correct
    is(join(' ', $z4->sec->asec->reals), '0.5 0.3');     # =//=

    # sec(asec(x)) = x
    is(join(' ', $z1->asec->sec->reals), '0.5 0.3');
    is(join(' ', $z2->asec->sec->reals), '0.5 -0.3');
    is(join(' ', $z3->asec->sec->reals), '-0.5 0.3');
    is(join(' ', $z4->asec->sec->reals), '-0.5 -0.3');

    # csc(acsc(x)) = x
    is(join(' ', $z1->acsc->csc->reals), '0.5 0.3');
    is(join(' ', $z2->acsc->csc->reals), '0.5 -0.3');
    is(join(' ', $z3->acsc->csc->reals), '-0.5 0.3');
    is(join(' ', $z4->acsc->csc->reals), '-0.5 -0.3');

    # acsc(csc(x)) = x
    is(join(' ', $z1->csc->acsc->reals), '0.5 0.3');
    is(join(' ', $z2->csc->acsc->reals), '0.5 -0.3');
    is(join(' ', $z3->csc->acsc->reals), '-0.5 0.3');
    is(join(' ', $z4->csc->acsc->reals), '-0.5 -0.3');

    # tan(x) = sin(x)/cos(x)
    is(join(' ', (sin($z1) / cos($z1))->reals), join(' ', $z1->tan->reals));
    is(join(' ', (sin($z2) / cos($z2))->reals), join(' ', $z2->tan->reals));
    is(join(' ', (sin($z3) / cos($z3))->reals), join(' ', $z3->tan->reals));
    is(join(' ', (sin($z4) / cos($z4))->reals), join(' ', $z4->tan->reals));

    # sec(x) = 1/cos(x)
    is(join(' ', $z1->sec->reals), join(' ', cos($z1)->inv->reals));
    is(join(' ', $z2->sec->reals), join(' ', cos($z2)->inv->reals));
    is(join(' ', $z3->sec->reals), join(' ', cos($z3)->inv->reals));
    is(join(' ', $z4->sec->reals), join(' ', cos($z4)->inv->reals));

    # csc(x) = 1/sin(x)
    is(join(' ', $z1->csc->reals), join(' ', sin($z1)->inv->reals));
    is(join(' ', $z2->csc->reals), join(' ', sin($z2)->inv->reals));
    is(join(' ', $z3->csc->reals), join(' ', sin($z3)->inv->reals));
    is(join(' ', $z4->csc->reals), join(' ', sin($z4)->inv->reals));

    # cot(x) = 1/tan(x)
    is(join(' ', $z1->cot->reals), join(' ', $z1->tan->inv->reals));
    is(join(' ', $z2->cot->reals), join(' ', $z2->tan->inv->reals));
    is(join(' ', $z3->cot->reals), join(' ', $z3->tan->inv->reals));
    is(join(' ', $z4->cot->reals), join(' ', $z4->tan->inv->reals));
}
