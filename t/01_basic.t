use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use HTML::ValidationRules;
use HTML::ValidationRules::Parser;

my $parser1 = HTML::ValidationRules->new;
my $rules1  = $parser1->load_rules(file => 't/data/form.html');

my $parser2 = HTML::ValidationRules::Parser->new;
my $rules2  = $parser2->load_rules(file => 't/data/form.html');

is_deeply $_ => [
    text     => [ [ HTML_PATTERN => '[[:alnum:]]+' ], [ HTML_MAXLENGTH => 255 ] ],
    url      => [ HTML_URL    => [ HTML_MAXLENGTH => 255 ], 'HTML_REQUIRED'     ],
    email    => [ HTML_EMAIL  => [ HTML_MAXLENGTH => 255 ], 'HTML_REQUIRED'     ],
    number   => [ HTML_NUMBER => [ HTML_MIN => 200 ], [ HTML_MAX => 800 ]       ],
    textarea => [ [ HTML_MAXLENGTH => 1000 ], 'HTML_REQUIRED'                   ],
] for ($rules1, $rules2);

done_testing;
