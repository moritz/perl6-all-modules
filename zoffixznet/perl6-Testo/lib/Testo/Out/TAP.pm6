use Testo::Out;
unit class Testo::Out::TAP does Testo::Out;
use Testo::Test::Result;

my &colored = sub {
    return sub (Str $s, $) { $s } if Nil === try require Terminal::ANSIColor;
    ::('Terminal::ANSIColor::EXPORT::DEFAULT::&colored')
}();

has UInt:D $.group-level = 0;
has $.out = $*OUT;
has $.err = $*ERR;
has $!count = 0;

method !indents { "\c[SPACE]" x 4*$!group-level }

method plan (Int $n) { $!out.say: self!indents ~ "1..$n" }

multi method put ($) {}
multi method put (Testo::Test::Result:D $test --> Nil) {
    $!count++;
    my \ident = self!indents;
    if $test.so {
        $!out.say: ident ~ "ok $!count - $test.desc()";
    }
    else {
        $!out.say: ident ~ "not ok $!count - $test.desc()";
        $!err.say: $test.fail.lines.map({
            ident ~ '# ' ~ colored(.trans(['#'] => [' \#']), 'red')
        }).join: "\n";
    }
}
