package FormValidator::Simple::Plugin::HTML5;
use strict;
use warnings;

our $VERSION = '0.01';

use FormValidator::Simple::Constants;

sub HTML5_URL {
    my ($self, $params, $args) = @_;
    $self->HTTP_URL($params, $args);
}

sub HTML5_EMAIL     { SUCCESS }
sub HTML5_NUMBER    { SUCCESS }
sub HTML5_RANGE     { SUCCESS }
sub HTML5_MAXLENGTH { SUCCESS }
sub HTML5_MAX       { SUCCESS }
sub HTML5_MIN       { SUCCESS }
sub HTML5_REQUIRED  { SUCCESS }

!!1;
