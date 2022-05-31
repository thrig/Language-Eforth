#!perl
use Test2::V0;

use Language::Eforth;
my $f = Language::Eforth->new;

$f->eval("2 2 +\n");
my ( $value, $ret ) = $f->pop;
is( $value, 4 );
is( $ret,   0 );

( $value, $ret ) = $f->pop;
is( $value, 0 );
is( $ret,   -4 );    # see "Error Codes" in embed.fth

$f->push(39);
$f->push(3);
is( $f->depth, 2 );

$f->eval("+\n");
( $value, $ret ) = $f->pop;
is( $value, 42 );
is( $ret,   0 );

is( $f->depth, 0 );

$f->push(99);
$f->reset;
is( $f->depth, 0 );

# pretty sure this is a bug in embed, see KLUGE in Eforth.xs
my $e = Language::Eforth->new;
$e->push(7);
$e->push(1);
$e->eval("+\n");
is( scalar $e->pop, 8 );

# NOTE ->new may die but causing malloc to fail might be tricky

like( dies { $f->eval },        qr/Usage/ );
like( dies { $f->eval(undef) }, qr/empty expression/ );
like( dies { $f->eval("") },    qr/empty expression/ );

like( dies { $f->push(undef) },     qr/integer/ );
like( dies { $f->push("li vore") }, qr/integer/ );

done_testing 15
