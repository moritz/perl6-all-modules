# Typesafe::XHTML::Writer
[![Build Status](https://travis-ci.org/gfldex/perl6-typesafe-xhtml-writer.svg?branch=master)](https://travis-ci.org/gfldex/perl6-typesafe-xhtml-writer)

Write XHTML elements utilising named arguments to guard against typos. Colons
in names of XHTML attributes are replaced with a hyphen (e.g. `xml:lang`). Use
the html element names as an import tag or `:ALL` to get them all. Please
note that there is a `dd`-tag what will overwrite `dd` from the settings.

The actual module is generated form the official XHTML 1.1 Schema. There is no
offical XML Schema for HTML5 (because it isn't XML), if you happen to come
across one that works please let me know.

It uses [Typesafe::HTML](https://github.com/gfldex/perl6-typesafe-xhtml-writer)
to guard against lack of quoting of HTML-tags. As a dropin-replacement of
`HTML::Writer`, it's about 5% slower then the former. See below how to "overload"
that module, see below.
 
[`Typesafe::HTML::Skeleton`](https://raw.githubusercontent.com/gfldex/perl6-typesafe-xhtml-writer/master/lib/Typesafe/XHTML/Skeleton.pm6)
provides the routine `xhtml-skeleton` that takes instances of `HTML` (the type)
as parameters and returns `HTML`. The named arguments takes a single or a list
of tags of type `HTML` to be added to the header of the resulting XHTML
document. `HTML` is a flat eager string that is about 5% slower then without
typesafety. If you need a DOM use a module that does not focus on speed.

## Usage:
```
use v6;
use Typesafe::XHTML::Writer :ALL;

put html( xml-lang=>'de', 
	body(
        div( id=>"uniq",
          p( class=>"abc", 'your text here'),
          p( 'more text' ),
          '<p>this will be quoted with &lt; and &amp;</p>'
        )
    ));

put span('<b>this will also be quoted with HTML-entities</b>');
```

With skeleton:

```
use v6;
use Typesafe::XHTML::Writer :p, :title, :style;
use Typesafe::XHTML::Skeleton;

put xhtml-skeleton(
        p('Hello Camelia!', class=>'foo'),
        'Camelia can quote all the <<<< and &&&&.', 
        header=>(title('Hello Camelia'), style('p.foo { color: #fff; }' ))
    );
```
## Enable typesafe concatenation

```
use v6;
use Typesafe::HTML;
use Typesafe::XHTML::Writer :p;
use Typesafe::XHTML::Skeleton;

my $inject = '<script src="http://dr.evil.ord/1337.js></script>';
put xhtml-skeleton(p('Hello Camelia!') ~ $inject);
```

Without `Typesafe::HTML` the p-tag would also be quoted. It would be secure but
would not do what you want.

## Provide your own type guard

You can provide your own type guard to replace `Typesafe::HTML` by providing a
type object as the first positional to `use`. To use the original operators
defined in `Typesafe::HTML` make sure to subclass from `HTML`.

```
use Typesafe::HTML;

class ExtendedHTML is HTML {	
	multi method utf8-to-htmlentity (Str:D \s) is export {
		s.subst('&', '&amp;', :g).subst('<', '&lt;', :g).subst('>', '&gt;', :g);
	}
}

use Typesafe::XHTML::Writer ExtendedHTML, :span;

put span(id=>'foo', "<span>Hello Camelia!</span>");

# OUTPUT:
# <span id="foo">
#   &lt;span&gt;Hello Camelia!&lt;/span&gt;
# </span>
```

## Enable indentation

```
use Typesafe::XHTML::Writer :writer-shall-indent; # :ALL will work too
writer-shall-indent True;
```

## License

(c) Wenzel P. P. Peppmeyer, Released under Artistic License 2.0.
