package HTML5::ValidationRules;
use 5.008001;
use strict;
use warnings;

our $VERSION = '0.01';

use HTML5::ValidationRules::Parser;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub parser {
    my ($self) = @_;
    $self->{parser} ||= HTML5::ValidationRules::Parser->new(%$self);
}

sub load_rules {
    my ($self, %args) = @_;
    $self->parser->load_rules(%args);
}

!!1;

__END__

=encoding utf8

=head1 NAME

HTML5::ValidationRules -

=head1 SYNOPSIS

  use HTML5::ValidationRules;

=head1 DESCRIPTION

HTML5::ValidationRules is

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentarok@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kentaro Kuribayashi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
