use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Math::GComplex',
    license             => 'artistic_2',
    dist_author         => q{Daniel "Trizen" Șuteu <trizen@protonmail.com>},
    dist_version_from   => 'lib/Math/GComplex.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => '0',
    },
    build_requires => {
        'Test::More' => '0',
    },
    requires => {
        #'ABC'              => '1.6',
        #'Foo::Bar::Module' => '5.0401',
    },
    add_to_cleanup     => [ 'Math-GComplex-*' ],
);

$builder->create_build_script();
