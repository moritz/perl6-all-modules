unit module Foo::Bar:auth<github:tbrowder>;

sub foo($word = 'bar') is export(:foo) {
    say $word;
    return $word;
}
