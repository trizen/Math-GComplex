#!perl -T

use 5.010;
use strict;
use warnings;
use Test::More;

## Tests from Math::Complex / Math::Trig
## https://metacpan.org/source/ZEFRAM/Math-Complex-1.59/t/Trig.t

use Math::GComplex qw(:trig);

plan tests => 56;

my $eps = 1e-10;

sub near ($$;$) {
    my $e = $_[2] // $eps;
    my $d = $_[1] ? abs($_[0] / $_[1] - 1) : abs($_[0]);
    print "# near? $_[0] $_[1] : $d : $e\n";
    $_[1] ? ($d < $e) : abs($_[0]) < $e;
}

print "# Sanity checks\n";

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
ok(near(atanh(0.9), 1.47221948958322));    # atanh(1.0) would be an error.

ok(near(asech(0.9), 0.467145308103262));
ok(near(acsch(2),   0.481211825059603));
ok(near(acoth(2),   0.549306144334055));

print "# Basics\n";

my $x = 0.9;
ok(near(tan($x), sin($x) / cos($x)));

ok(near(sinh(2),    3.62686040784702));
ok(near(acsch(0.1), 2.99822295029797));

$x = asin(2);
is(ref($x), 'Math::GComplex');

my ($y, $z) = $x->reals;
ok(near($y, 1.5707963267949));
ok(near($z, -1.31695789692482));

#ok(near(deg2rad(90), pi/2));
#ok(near(rad2deg(pi), 180));

print "# sinh/sech/cosh/csch/tanh/coth unto infinity\n";

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

print "# asin_real, acos_real\n";

ok(acos(-2.0)->real == 4 * atan2(4, 4));
ok(acos(-1.0)->real == 4 * atan2(4, 4));
ok(acos(-0.5)->real == acos(-0.5));
ok(acos(0.0)->real == 2 * atan2(4, 4));
ok(acos(0.5)->real == acos(0.5));
ok(acos(1.0)->real == 0);
ok(near(acos(2.0)->real, 0));

ok(asin(-0.5)->real == asin(-0.5));
ok(asin(0.0)->real == asin(0.0));
ok(asin(0.5)->real == asin(0.5));
