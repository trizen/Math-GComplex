package Math::GComplex;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.01';

state $MONE = __PACKAGE__->new(-1, 0);
state $ZERO = __PACKAGE__->new(+0, 0);
state $ONE  = __PACKAGE__->new(+1, 0);
state $TWO  = __PACKAGE__->new(+2, 0);

state $I = __PACKAGE__->new(+0, 1);

use overload
  '""' => \&stringify,
  '0+' => \&numify,
  bool => \&boolify,

  '+' => \&add,
  '*' => \&mul,

  '==' => \&eq,
  '!=' => \&ne,

  '&' => \&and,
  '|' => \&or,
  '^' => \&xor,
  '~' => \&not,

  '>'  => sub { $_[2] ? (goto &lt) : (goto &gt) },
  '>=' => sub { $_[2] ? (goto &le) : (goto &ge) },
  '<'  => sub { $_[2] ? (goto &gt) : (goto &lt) },
  '<=' => sub { $_[2] ? (goto &ge) : (goto &le) },

  '<=>' => sub { $_[2] ? -(&cmp($_[0], $_[1]) // return undef) : &cmp($_[0], $_[1]) },

  '>>' => sub { @_ = ($_[1], $_[0]) if $_[2]; goto &rsft },
  '<<' => sub { @_ = ($_[1], $_[0]) if $_[2]; goto &lsft },
  '/'  => sub { @_ = ($_[1], $_[0]) if $_[2]; goto &div },
  '-'  => sub { @_ = ($_[1], $_[0]) if $_[2]; goto &sub },

  '**' => sub { @_ = $_[2] ? @_[1, 0] : @_[0, 1]; goto &pow },
  '%'  => sub { @_ = $_[2] ? @_[1, 0] : @_[0, 1]; goto &mod },

  atan2 => sub { @_ = $_[2] ? @_[1, 0] : @_[0, 1]; goto &atan2 },

  eq => sub { "$_[0]" eq "$_[1]" },
  ne => sub { "$_[0]" ne "$_[1]" },

  cmp => sub { $_[2] ? ("$_[1]" cmp $_[0]->stringify) : ($_[0]->stringify cmp "$_[1]") },

  neg  => \&neg,
  sin  => \&sin,
  cos  => \&cos,
  exp  => \&exp,
  log  => \&log,
  int  => \&int,
  abs  => \&abs,
  sqrt => \&sqrt;

sub new {
    my ($class, $x, $y) = @_;

    bless {
           a => $x // 0,
           b => $y // 0,
          }, $class;
}

#
## (a + b*i) + (x + y*i) = (a + x) + (b + y)*i
#

sub add {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    __PACKAGE__->new($x->{a} + $y->{a}, $x->{b} + $y->{b});
}

#
## (a + b*i) - (x + y*i) = (a - x) + (b - y)*i
#

sub sub {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    __PACKAGE__->new($x->{a} - $y->{a}, $x->{b} - $y->{b});
}

#
## (a + b*i) * (x + y*i) = i*(a*y + b*x) + a*x - b*y
#

sub mul {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    __PACKAGE__->new($x->{a} * $y->{a} - $x->{b} * $y->{b}, $x->{a} * $y->{b} + $x->{b} * $y->{a});
}

#
## (a + b*i) / (x + y*i) = (a*x + b*y)/(x*x + y*y) + (b*x - a*y)/(x*x + y*y) * i
#

sub div {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    my $d = $y->{a} * $y->{a} + $y->{b} * $y->{b};

    __PACKAGE__->new(($x->{a} * $y->{a} + $x->{b} * $y->{b}) / $d, ($x->{b} * $y->{a} - $x->{a} * $y->{b}) / $d);
}

#
## sqrt(a + b*i) = exp(log(a + b*i) / 2)
#

sub sqrt {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    $x->log->div($TWO)->exp;
}

#
## abs(a + b*i) = sqrt(a^2 + b^2)
#

sub abs {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    CORE::sqrt($x->{a} * $x->{a} + $x->{b} * $x->{b});
}

#
## sgn(a + b*i) = (a + b*i) / abs(a + b*i)
#

sub sgn {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    if ($x == $ZERO) {
        return $ZERO;
    }

    $x->div($x->abs);
}

#
## neg(a + b*i) = -a - b*i
#

sub neg {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    __PACKAGE__->new(-$x->{a}, -$x->{b});
}

#
## conj(a + b*i) = a - b*i
#

sub conj {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    __PACKAGE__->new($x->{a}, -$x->{b});
}

#
## log(a + b*i) = log(a^2 + b^2)/2 + atan(b/a)*i
#

sub log {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    __PACKAGE__->new(CORE::log($x->{a} * $x->{a} + $x->{b} * $x->{b}) / 2, CORE::atan2($x->{b}, $x->{a}));
}

#
## (a + b*i)^x = exp(log(a+b*i) * x)
#

sub pow {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->log->mul($y)->exp;
}

#
## exp(a + b*i) = exp(a)*cos(b) + exp(a)*sin(b)*i
#

sub exp {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    my $exp = CORE::exp($x->{a});

    __PACKAGE__->new($exp * CORE::cos($x->{b}), $exp * CORE::sin($x->{b}));
}

#
## sin(a + b*i) = i*(exp(b - i*a) - exp(-b + i*a))/2
#

sub sin {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    my $t1 = __PACKAGE__->new($x->{b},  -$x->{a})->exp;
    my $t2 = __PACKAGE__->new(-$x->{b}, $x->{a})->exp;

    __PACKAGE__->new(($t1->{b} - $t2->{b}) / -2, ($t1->{a} - $t2->{a}) / 2);
}

#
## cos(a + b*i) = (exp(-b + i*a) + exp(b - i*a))/2
#

sub cos {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    my $t1 = __PACKAGE__->new(-$x->{b}, $x->{a})->exp;
    my $t2 = __PACKAGE__->new($x->{b},  -$x->{a})->exp;

    __PACKAGE__->new(($t1->{a} + $t2->{a}) / 2, ($t1->{b} + $t2->{b}) / 2);
}

#
## reals(a + b*i) = (a, b)
#

sub reals {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    ($x->{a}, $x->{b});
}

#
## Equality
#

sub eq {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->{a} == $y->{a}
      and $x->{b} == $y->{b};
}

#
## Inequality
#

sub ne {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->{a} != $y->{a}
      or $x->{b} != $y->{b};
}

#
## Comparisons
#

sub cmp {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    ($x->{a} <=> $y->{a})
      or ($x->{b} <=> $y->{b});
}

sub lt {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->cmp($y) < 0;
}

sub le {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->cmp($y) <= 0;
}

sub gt {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->cmp($y) > 0;
}

sub ge {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    $x->cmp($y) >= 0;
}

sub stringify {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    "($x->{a} $x->{b})";
}

sub numify {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    $x->{a};
}

1;    # End of Math::GComplex
