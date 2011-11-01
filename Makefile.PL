BEGIN {
    use inc::Module::Install;

    my @mip = qw(
        Module::Install::AuthorTests
        Module::Install::Repository
        Module::Install::ReadmeFromPod
    );
    for (@mip) {
        eval "require $_";
        if ($@) {
            eval "require inc::$_";
            if ($@) {
                warn $@;
                printf("# Install following (perl Makefile.PL | cpanm):\n%s", join("\n", @mip));
                exit 1;
            }
        }
    }
}

name        'HTML-ValidationRules';
all_from    'lib/HTML/ValidationRules.pm';
readme_from 'lib/HTML/ValidationRules.pm';

auto_set_repository;

requires 'autodie';
requires 'HTML::Parser';
requires 'Scalar::Util::Numeric';
requires 'FormValidator::Simple';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';

test_requires 'Test::More' => 0.96; # done_testing, subtest
test_requires 'Test::Requires';
test_requires 'Test::Name::FromLine';

author_tests('xt');
WriteAll;
