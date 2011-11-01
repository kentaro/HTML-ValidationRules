package HTML::ValidationRules;
use 5.008001;
use strict;
use warnings;

our $VERSION = '0.01';

use HTML::ValidationRules::Parser;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub parser {
    my ($self) = @_;
    $self->{parser} ||= HTML::ValidationRules::Parser->new(%$self);
}

sub load_rules {
    my ($self, %args) = @_;
    $self->parser->load_rules(%args);
}

!!1;

__END__

=encoding utf8

=head1 NAME

HTML::ValidationRules - Extract Validation Rules from HTML Form
Element

=head1 SYNOPSIS

  # form.html
  <!doctype html>
  <html>
    <head>
      <meta charset="UTF-8">
      <title>HTML5::ValidationRules</title>
    </head>
    <body>
      <form method="post" action="/post">
        <input type="text" name="text" pattern="[[:alnum:]]+" maxlength="255" />
        <input type="url" name="url" maxlength="255" required />
        <input type="email" name="email" maxlength="255" required="required" />
        <input type="number" name="number" min="200" max="800" />
        <textarea name="textarea" maxlength="1000" required></textarea>
        <input type="submit" value="submit" />
      </form>
    </body>
  </html>

  # in your code
  use HTML::ValidationRules;
  my $parser = HTML::ValidationRules->new;
  my $rules  = $parser->load_rules(file => 'form.html');

  # rules will be extracted as follows:
  [
      text     => [ [ HTML_PATTERN => '[[:alnum:]]+' ], [ HTML_MAXLENGTH => 255 ] ],
      url      => [ HTML_URL    => [ HTML_MAXLENGTH => 255 ], 'HTML_REQUIRED'     ],
      email    => [ HTML_EMAIL  => [ HTML_MAXLENGTH => 255 ], 'HTML_REQUIRED'     ],
      number   => [ HTML_NUMBER => [ HTML_MIN => 200 ], [ HTML_MAX => 800 ]       ],
      textarea => [ [ HTML_MAXLENGTH => 1000 ], 'HTML_REQUIRED'                   ],
  ]

  # then use the rules with, for example, FormValidator::Simple
  use FormValidator::Simple qw(HTML);

  my $query  = CGI->new;
  my $result = FormValidator::Simple->check($query => $rules);

=head1 DESCRIPTION

HTML::ValidationRules regards HTML form element as validation rules
definition and extract rules from it.

=head1 WARNING

B<This software is under the heavy development and considered ALPHA
quality now. Things might be broken, not all features have been
implemented, and APIs will be likely to change. YOU HAVE BEEN WARNED.>

=head1 METHODS

=head2 new(C<%args>)

=over

  my $parser = HTML::ValidationRules->new(
      options => { ... } #=> options for HTML::Parser
  );

Returns a new HTML::ValidationRules object.

=back

=head2 load_rules(C<%args>)

=over

  my $rules = $parser->load_rules(file => 'form.html');

Parse HTML and extract validation rules from form element (defined as
HTML5 client-side form validation spec, but not all of
them). C<$rules> has compatible form as args for
L<FormValidator::Simple>'s' check() method.

C<%args> are supposed to contain one of them below:

=over

=item * file

Path to a file or filehandle of it.

=item * html

String of HTML.

=back

=back

=head1 SUPPORTED ATTRIBUTES

C<input> and C<textare> can have some attributes related to
validation. This module haven't support all the attrs defined in HTML5
spec at all, just have done below yet:

=over

=item * max

=item * maxlength

=item * min

=item * pattern

=item * required

=item * type

=over

=item * type:url

=item * type:email

=item * type:number

=back

=back

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentarok@gmail.comE<gt>

=head1 SEE ALSO

=over

=item * L<http://dev.w3.org/html5/spec/Overview.html#client-side-form-validation>

=item * L<http://dev.w3.org/html5/spec/Overview.html#the-input-element>

=item * L<http://dev.w3.org/html5/spec/Overview.html#the-textarea-element>

=back

=head1 LICENSE

Copyright (C) Kentaro Kuribayashi

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
