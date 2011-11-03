use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use HTML::ValidationRules;
use HTML::ValidationRules::Parser;

for my $file (qw(form.html form.tt)) {
    my $parser1 = HTML::ValidationRules->new;
    my $rules1  = $parser1->load_rules(file => 't/data/' . $file);

    my $parser2 = HTML::ValidationRules::Parser->new;
    my $rules2  = $parser2->load_rules(file => 't/data/' . $file);

    is_deeply $_ => [
        text     => [ [ HTML_PATTERN => '[[:alnum:]]+' ], [ HTML_MAXLENGTH => 255 ] ],
        url      => [ HTML_URL    => [ HTML_MAXLENGTH => 255 ], 'NOT_BLANK'     ],
        email    => [ HTML_EMAIL  => [ HTML_MAXLENGTH => 255 ], 'NOT_BLANK'     ],
        number   => [ HTML_NUMBER => [ HTML_MIN => 200 ], [ HTML_MAX => 800 ]       ],
        textarea => [ [ HTML_MAXLENGTH => 1000 ], 'NOT_BLANK'                   ],
    ] for ($rules1, $rules2);
}

done_testing;
