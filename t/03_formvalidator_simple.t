use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use CGI;
use FormValidator::Simple qw(HTML5);

use HTML5::ValidationRules;

my $parser = HTML5::ValidationRules->new;
my $rules  = $parser->load_rules(file => 't/data/form.html');
my $query = CGI->new;
   $query->param(url => 'http://example.com/');

my $result = FormValidator::Simple->check($query => $rules);
ok $result->valid('url');

done_testing;
