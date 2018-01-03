#!perl -T

use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 36;

use Math::GComplex qw(:overload acos cosh);

{
    my @A097691 = qw(8 56 551 6930 105937 1905632 39424240);    # https://oeis.org/A097691

    foreach my $n (3 .. 9) {
        my $y =
          abs((2**(-$n) * (sqrt(4 - $n**2) + i * $n)**$n - 2**$n * (-sqrt(4 - $n**2) - i * $n)**(-$n)) / sqrt(4 - $n**2));
        is(sprintf('%.0f', $y), shift(@A097691), "a($n) = $y");
    }
}

{
    my @A105309 = qw(1 1 2 5 9 20 41 85 178 369 769);           # https://oeis.org/A105309

    foreach my $n (0 .. $#A105309) {
        my $y =
          (abs(((sqrt(4 * i - 1) + i)**($n + 1) - (i - sqrt(4 * i - 1))**($n + 1)) / 2**($n + 1) / sqrt(4 * i - 1))**2)->real;
        is(sprintf('%.0f', $y), shift(@A105309), "a($n) = $y");
    }
}

{
    my @A001541 = qw(1 3 17 99 577 3363 19601 114243 665857);    # https://oeis.org/A001541

    foreach my $n (0 .. $#A001541) {

        my $t = shift(@A001541);

        my $x = cos($n * acos(3));
        my $y = cosh($n * log(3 + 2 * sqrt(2)));

        is(sprintf('%.0f', abs($x)), $t, "a($n) = $x");
        is(sprintf('%.0f', abs($y)), $t, "a($n) = $y");
    }
}
