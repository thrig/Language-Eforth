# -*- Perl -*-

package Language::Eforth;
use strict;
use warnings;
our $VERSION = '0.01';
require XSLoader;
XSLoader::load('Language::Eforth', $VERSION);

1;
__END__

=head1 NAME

Language::Eforth - a tiny embedded Forth interpreter

=head1 SYNOPSIS

  use Language::Eforth;
  my $f = Language::Eforth->new;

  $f->eval("2 2 + .s\n");
  print $f->pop, "\n";

=head1 DESCRIPTION

This module embeds a tiny embeddable Forth interpreter.

=head1 METHODS

These may C<croak> should something be awry with the input, or if memory
allocation fails.

=over 4

=item B<depth>

Returns the data stack depth.

=item B<eval> I<expr>

Evaluates the string I<expr>. I<expr> MUST end with a newline.

=item B<new>

Constructor.

=item B<pop>

Pops an item off of the data stack. In list context this returns the
value and the return code.

=item B<push> I<integer>

Pushes I<integer> onto the data stack.

=item B<reset>

Resets the state of the interpreter.

=back

=head1 AUTHOR

Jeremy Mates

=head1 COPYRIGHT & LICENSE

Copyright 2022 Jeremy Mates, All Rights Reserved.

This program is distributed under the (Revised) BSD License.

=cut
