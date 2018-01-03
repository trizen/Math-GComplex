#!perl -T

use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 18;

use Math::GComplex qw(:overload);

my @A097691 = qw(8 56 551 6930 105937 1905632 39424240);    # https://oeis.org/A097691

foreach my $n (3 .. 9) {
    my $y = abs((2**(-$n) * (sqrt(4 - $n**2) + i * $n)**$n - 2**$n * (-sqrt(4 - $n**2) - i * $n)**(-$n)) / sqrt(4 - $n**2));
    is(sprintf('%.0f', $y), shift(@A097691), "a($n) = $y");
}

my @A105309 = qw(1 1 2 5 9 20 41 85 178 369 769);           # https://oeis.org/A105309

foreach my $n (0 .. 10) {
    my $y =
      (abs(((sqrt(4 * i - 1) + i)**($n + 1) - (i - sqrt(4 * i - 1))**($n + 1)) / 2**($n + 1) / sqrt(4 * i - 1))**2)->real;
    is(sprintf('%.0f', $y), shift(@A105309), "a($n) = $y");
}
