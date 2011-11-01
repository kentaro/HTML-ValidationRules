package HTML5::ValidationRules::Parser;
use strict;
use warnings;
use autodie;
use HTML::Parser;

my %ELEMENTS = (
    input => [qw(
        max
        maxlength
        min
        pattern
        required
    ), {
        name   => 'type',
        values => [
            {
                name          => 'url',
                content_attrs => [qw(maxlength pattern required)],
            },
            {
                name          => 'email',
                content_attrs => [qw(maxlength pattern required)],
            },
            {
                name          => 'number',
                content_attrs => [qw(max min required)],
            },
            {
                name          => 'range',
                content_attrs => [qw(max min required)],
            },
        ],
    }],

    textarea => [qw(
        maxlength
        required
    )],
);

my $ELEMENTS_PATTERN = qr/(@{[join '|', (map { quotemeta } keys %ELEMENTS)]})/o;
my %ATTRS_MAP = map {
    my $attr = ref $_ ? $_->{name} : $_;
       $attr => +{ map { $_ => 1 } @{$ELEMENTS{$_}} };
} keys %ELEMENTS;
my %TYPE_ATTR_MAP = map {
    my $attr = $_;
    map { $_->{name} => $_->{content_attrs} } @{$attr->{values}};
} grep { ref $_ && $_->{name} eq 'type' } @{$ELEMENTS{input}};

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub parser {
    my ($self) = @_;
    $self->{parser} ||= HTML::Parser->new(
        api_version => 3,
        start_h     => [\&start, 'self, tagname, attr, attrseq'],
        %{$self->{options} || {}},
    );
}

sub load_rules {
    my ($self, %args) = @_;
    my $file = delete $args{file};
    my $html = delete $args{html};

    undef $self->parser->{rules};

    if ($file) {
        $self->parser->parse_file($file);
    }
    else {
        $self->parser->parse($html);
        $self->eof;
    }

    $self->parser->{rules};
}

sub start {
    my ($parser, $tag, $attr, $attrseq) = @_;
    return if $tag !~ $ELEMENTS_PATTERN;

    my $name = $attr->{name};
    return if !defined $name;

    my @rules;
    my $attrs = $ATTRS_MAP{lc $tag};

    # specific types (eg. url, email, etc)
    if (my $content_attrs = $TYPE_ATTR_MAP{$attr->{type} || ''}) {
        my $type = $attr->{type};

        for my $content_attr (@{$content_attrs || []}) {
            next if !exists $attr->{$content_attr};

            my $value = $attr->{$content_attr};

            if (defined $value && $content_attr ne $value) {
                push @rules, [ 'HTML5_' . uc $content_attr => $value ];
            }
            elsif ($content_attr eq $value) {
                push @rules, 'HTML5_' . uc $content_attr;
            }
        }

        unshift @rules, 'HTML5_' . uc $type;
    }

    # general types (eg. text, checkbox, etc)
    else {
        for my $key (@{$attrseq || []}) {
            next if !$attrs->{$key};

            my $value = $attr->{$key};
            if (defined $value && $key ne $value) {
                push @rules, [ 'HTML5_' . uc $key => $value ];
            }
            elsif ($key eq $value) {
                push @rules, 'HTML5_' . uc $key;
            }
        }
    }

    $parser->{rules} ||= [];
    push @{$parser->{rules}}, $name => \@rules;
}

!!1;
