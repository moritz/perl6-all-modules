use v6.c;
use Test;
use P5getgrnam;

my @supported = <
  endgrent getgrgid getgrent getgrnam setgrent
>.map: '&' ~ *;

plan @supported * 2;

for @supported {
    ok defined(::($_)),          "is $_ imported?";
    nok P5getgrnam::{$_}:exists, "is $_ NOT externally accessible?";
}

# vim: ft=perl6 expandtab sw=4
