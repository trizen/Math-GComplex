package Math::GComplex;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.01';

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
  log  => \&ln,
  int  => \&int,
  abs  => \&abs,
  sqrt => \&sqrt;

sub new {
    my ($class, $x, $y) = @_;
    bless {a => $x, b => $y}, $class;
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

    __PACKAGE__->new($x->{a} * $y->{a} - $x->{b}*$y->{b}, $x->{a}*$y->{b} + $x->{b}*$y->{a});
}

#
## (a + b*i) / (x + y*i) = (a*x + b*y)/(x*x + y*y) + (b*x - a*y)/(x*x + y*y) * i
#

sub div {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

    # TODO: try to optimize this

    my $num = $x * $y->conj;
    my $den = $y->{a} * $y->{a} + $y->{b}*$y->{b};

    __PACKAGE__->new($num->{a} / $den, $num->{b} / $den);
}

sub conj {
    my ($x) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;

    __PACKAGE__->new($x->{a}, -$x->{b});
}

sub eq {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

        $x->{a} == $y->{a}
    and $x->{b} == $y->{b};
}

sub ne {
    my ($x, $y) = @_;

    $x = __PACKAGE__->new($x) if ref($x) ne __PACKAGE__;
    $y = __PACKAGE__->new($y) if ref($y) ne __PACKAGE__;

       $x->{a} != $y->{a}
    or $x->{b} != $y->{b};
}

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

1; # End of Math::GComplex
