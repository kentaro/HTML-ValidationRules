use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use t::lib::Object;
use HTML::ValidationRules;
use FormValidator::Simple qw(HTML);

my $parser = HTML::ValidationRules->new;
my $rules  = $parser->load_rules(file => 't/data/form.html');
my %params = (
    text     => 'testtest',
    url      => 'http://example.com/',
    email    => 'foo@example.com',
    number   => 300,
    textarea => 'text text',
);
my $query = t::lib::Object->new;
   $query->param($_ => $params{$_}) for keys %params;

my $result = FormValidator::Simple->check($query => $rules);

ok $result->valid($_), $_ for keys %params;

done_testing;
