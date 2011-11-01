use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use HTML5::ValidationRules;

my $parser = HTML5::ValidationRules->new;
my $rules  = $parser->load_rules(file => 't/data/form.html');

is_deeply $rules, {
    text     => [[ maxlength => 255 ]],
    url      => [ url    => [ maxlength => 255 ], 'required'],
    email    => [ email  => [ maxlength => 255 ], 'required'],
    number   => [ number => [ max => 800 ], [ min => 200 ]],
    range    => [ range  => [ max => 80 ], [ min => 20 ]],
    textarea => [[ maxlength => 1000 ], 'required'],
};

done_testing;
