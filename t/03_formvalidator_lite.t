use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;
use Test::Requires qw(FormValidator::Lite);

use t::lib::Object;
use HTML::ValidationRules;
use FormValidator::Lite;
FormValidator::Lite->load_constraints('HTML');

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

my $validator = FormValidator::Lite->new($query);
my $result    = $validator->check(@{$rules || []});

ok $result->is_valid($_), $_ for keys %params;

done_testing;
