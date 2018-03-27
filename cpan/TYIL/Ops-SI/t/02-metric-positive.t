#! /usr/bin/env perl6

use v6.c;

use Ops::SI;
use Test;

my %prefixes = %(
	"deca"   => ((1da, 10¹,  "1da"), (0.1da, 10⁰,  "0.1da"), ((1/10)da, 10⁰,  "1/10th da")),
	"hecto"  => ((1h,  10²,  "1h"),  (0.1h,  10¹,  "0.1h"),  ((1/10)h,  10¹,  "1/10th h")),
	"kilo"   => ((1k,  10³,  "1k"),  (0.1k,  10²,  "0.1k"),  ((1/10)k,  10²,  "1/10th k")),
	"mega"   => ((1M,  10⁶,  "1M"),  (0.1M,  10⁵,  "0.1M"),  ((1/10)M,  10⁵,  "1/10th M")),
	"giga"   => ((1G,  10⁹,  "1G"),  (0.1G,  10⁸,  "0.1G"),  ((1/10)G,  10⁸,  "1/10th G")),
	"tera"   => ((1T,  10¹², "1T"),  (0.1T,  10¹¹, "0.1T"),  ((1/10)T,  10¹¹, "1/10th T")),
	"peta"   => ((1P,  10¹⁵, "1T"),  (0.1P,  10¹⁴, "0.1P"),  ((1/10)P,  10¹⁴, "1/10th P")),
	"eksa"   => ((1E,  10¹⁸, "1E"),  (0.1E,  10¹⁷, "0.1E"),  ((1/10)E,  10¹⁷, "1/10th E")),
	"zetta"  => ((1Z,  10²¹, "1Z"),  (0.1Z,  10²⁰, "0.1Z"),  ((1/10)Z,  10²⁰, "1/10th Z")),
	"yotta"  => ((1Y,  10²⁴, "1Y"),  (0.1Y,  10²³, "0.1Y"),  ((1/10)Y,  10²³, "1/10th Y")),
);

plan %prefixes.elems;

for %prefixes.kv -> $prefix, @tests {
	subtest $prefix => {
		plan @tests.elems;

		for @tests -> @case {
			is |@case;
		}
	}
}

# vim: ft=perl6 noet
