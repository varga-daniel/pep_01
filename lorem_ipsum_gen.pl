#!/usr/bin/env perl

use Text::Lorem;

my $text = Text::Lorem->new();
my ($name, $number) = @ARGV;

$paragraphs = $text->paragraphs($ARGV[number]);

print $paragraphs;