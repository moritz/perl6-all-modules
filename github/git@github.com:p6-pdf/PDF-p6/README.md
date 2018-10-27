PDF-p6
========

 <a href="https://travis-ci.org/p6-pdf/PDF-p6"><img src="https://travis-ci.org/p6-pdf/PDF-p6.svg?branch=master"></a>
 <a href="https://ci.appveyor.com/project/dwarring/PDF-p6/branch/master"><img src="https://ci.appveyor.com/api/projects/status/github/p6-pdf/PDF-p6?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true"></a>

## Overview

This is a low-level tool-kit for accessing and manipulating data from PDF documents.

It presents a seamless view of the data in PDF or FDF documents; behind the scenes handling indexing, compression, encryption, fetching of indirect objects and unpacking of object streams. It is capable of reading, editing and creation or incremental update of PDF files.

This module understands physical data structures rather than the logical document structure. It is primarily intended as base for higher level modules; or to explore or patch data in PDF or FDF files.

It is possible to construct basic documents and perform simple edits by direct manipulation of PDF data. This requires some knowledge of how PDF documents are structured. Please see 'The Basics' and 'Recommended Reading' sections below.

Classes/roles in this module include:

- `PDF` - PDF document root (trailer)
- `PDF::Reader` - for indexed random access to PDF files
- `PDF::IO::Filter` - a collection of standard PDF decoding and encoding tools for PDF data streams
- `PDF::IO::IndObj` - base class for indirect objects
- `PDF::IO::Serializer` - data marshalling utilities for the preparation of full or incremental updates
- `PDF::IO::Crypt` - decryption / encryption
- `PDF::Writer` - for the creation or update of PDF files
- `PDF::COS` - Perl 6 Bindings to PDF objects [Carousel Object System, see <a href="http://jimpravetz.com/blog/2012/12/in-defense-of-cos/">COS</a>]

## Example Usage

To create a one page PDF that displays 'Hello, World!'.

```
#!/usr/bin/env perl6
# creates examples/helloworld.pdf
use v6;
use PDF;
use PDF::COS;
use PDF::COS::Type::Info;
use PDF::COS::Stream;

sub prefix:</>($name){ PDF::COS.coerce(:$name) };

# construct a simple PDF document from scratch
my PDF $pdf .= new;
my $root     = $pdf.Root       = { :Type(/'Catalog') };

my @MediaBox  = 0, 0, 250, 100;

# define font /F1 as core-font Helvetica
my %Resources = :Procset[ /'PDF', /'Text'],
                :Font{
                    :F1{
                        :Type(/'Font'),
                        :Subtype(/'Type1'),
                        :BaseFont(/'Helvetica'),
                        :Encoding(/'MacRomanEncoding'),
                    },
                };

my $pages    = $root<Pages>    = { :Type(/'Pages'), :@MediaBox, :%Resources, :Kids[], :Count(0) };
# add some standard metadata
my PDF::COS::Type::Info $info = $pdf.Info //= {};
$info.CreationDate = DateTime.now;
$info.Producer = "Perl 6 PDF";

# define some basic content
my PDF::COS::Stream $Contents .= coerce: :stream{ :decoded("BT /F1 24 Tf  15 25 Td (Hello, world!) Tj ET" ) };

# create a new page. add it to the page tree
$pages<Kids>.push: { :Type(/'Page'), :Parent($pages), :$Contents };
$pages<Count>++;

# save the PDF to a file
$pdf.save-as: 'examples/helloworld.pdf';
```

![example.pdf](examples/.previews/helloworld-001.png)

Then to update the PDF, adding another page:

```
use v6;
use PDF;

my PDF $pdf .= open: 'examples/helloworld.pdf';

# locate the document root and page tree
my $catalog = $pdf<Root>;
my $Parent = $catalog<Pages>;

# create additional content, use existing font /F1
my $Contents = PDF::COS.coerce( :stream{ :decoded("BT /F1 16 Tf  15 25 Td (Goodbye for now!) Tj ET" ) } );

# create a new page. add it to the page-tree
$Parent<Kids>.push: { :Type( :name<Page> ), :$Parent, :$Contents };
$Parent<Count>++;

# update or create document metadata. set modification date
my $info = $pdf.Info //= {};
$info.ModDate = DateTime.now;

# incrementally update the existing PDF
$pdf.update;
```

![example.pdf](examples/.previews/helloworld-002.png)


## Description

A PDF file consists of data structures, including dictionaries (hashes) arrays, numbers and strings, plus streams for holding data such as images, fonts and general content.

PDF files are also indexed for random access and may also have filters for stream compression and encryption of streams and strings.

They have a reasonably well specified structure. The document starts from the `Root` entry in the trailer dictionary, which is the main entry point into a PDF.

This module is based on the [PDF PDF 32000-1:2008 1.7](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/PDF32000_2008.pdf) specification. It implements syntax, basic data-types, serialization and encryption rules as described in the first four chapters of the specification. Read and write access to data structures is via direct manipulation of tied arrays and hashes.

## The Basics

The `examples/helloworld.pdf` file that we created above contains:
```
%PDF-1.3
%...(control characters)
1 0 obj <<
  /CreationDate (D:20151225000000Z00'00')
  /Producer (Perl 6 PDF)
>>
endobj

2 0 obj <<
  /Type /Catalog
  /Pages 3 0 R
>>
endobj

3 0 obj <<
  /Type /Pages
  /Count 1
  /Kids [ 4 0 R ]
  /MediaBox [ 0 0 250 100 ]
  /Resources <<
    /Font <<
      /F1 6 0 R
    >>
    /Procset [ /PDF /Text ]
  >>
>>
endobj

4 0 obj <<
  /Type /Page
  /Contents 5 0 R
  /Parent 3 0 R
>>
endobj

5 0 obj <<
  /Length 44
>> stream
BT /F1 24 Tf  15 25 Td (Hello, world!) Tj ET
endstream
endobj

6 0 obj <<
  /Type /Font
  /Subtype /Type1
  /BaseFont /Helvetica
  /Encoding /MacRomanEncoding
>>
endobj

xref
0 7
0000000000 65535 f 
0000000014 00000 n 
0000000103 00000 n 
0000000157 00000 n 
0000000336 00000 n 
0000000406 00000 n 
0000000503 00000 n 
trailer
<<
  /ID [ <d743a886fcdcf87b69c36548219ea941> <d743a886fcdcf87b69c36548219ea941> ]
  /Info 1 0 R
  /Root 2 0 R
  /Size 7
>>
startxref
610
%%EOF
```

The PDF is composed of a series indirect objects, for example, the first object is:

```
1 0 obj <<
  /CreationDate (D:20151225000000Z00'00')
  /Producer (Perl 6 PDF)
>> endobj
```

It's an indirect object with object number `1` and generation number `0`, with a `<<` ... `>>` delimited dictionary containing the author and the date that the document was created. This PDF dictionary is roughly equivalent to a Perl 6 hash:

``` { :CreationDate("D:20151225000000Z00'00'"), :Producer("Perl 6 PDF"), } ```

The bottom of the PDF contains:

```
trailer
<<
  /ID [ <d743a886fcdcf87b69c36548219ea941> <d743a886fcdcf87b69c36548219ea941> ]
  /Info 1 0 R
  /Root 2 0 R
  /Size 7
>>
startxref
610
%%EOF
```

The `<<` ... `>>` delimited section is the trailer dictionary and the main entry point into the document. The entry `/Info 1 0 R` is an indirect reference to the first object (object number 1, generation 0) described above.

Immediately above this is the cross reference table:

```
xref
0 7
0000000000 65535 f 
0000000014 00000 n 
0000000103 00000 n 
0000000157 00000 n 
0000000336 00000 n 
0000000406 00000 n 
0000000503 00000 n 
```

This indexes the indirect objects in the PDF by byte offset (generation number) for random access.

We can quickly put PDF to work using the Perl 6 REPL, to better explore the document:

    snoopy: ~/git/perl6-PDF $ perl6 -M PDF
    > my $pdf = PDF.open: "examples/helloworld.pdf"
    ID => [CÜ{ÃHADCN:C CÜ{ÃHADCN:C], Info => ind-ref => [1 0], Root => ind-ref => [2 0]
    > $pdf.keys
    (Root Info ID)

This is the root of the PDF, loaded from the trailer dictionary

    > $pdf<Info>
    {CreationDate => D:20151225000000Z00'00', Producer => Perl 6 PDF}

That's the document information entry, commonly used to store basic meta-data about the document.

(PDF::IO has conveniently fetched indirect object 1 from the PDF, when we dereferenced this entry).

    > $pdf<Root>
    {Pages => ind-ref => [3 0], Type => Catalog}

The trailer `Root` entry references the document catalog, which contains the actual PDF content. Exploring further; the catalog potentially contains a number of pages, each with content.

    > $pdf<Root><Pages>
    {Count => 1, Kids => [ind-ref => [4 0]], MediaBox => [0 0 420 595], Resources => Font => F1 => ind-ref => [6 0], Type => Pages}
    > $pdf<Root><Pages><Kids>[0]
    {Contents => ind-ref => [5 0], Parent => ind-ref => [3 0], Type => Page}
    > $pdf<Root><Pages><Kids>[0]<Contents>
    {Length => 44}
    BT /F1 24 Tf  15 25 Td (Hello, world!) Tj ET

The page `/Contents` entry is a PDF stream which contains graphical instructions. In the above example, to output the text `Hello, world!` at coordinates 100, 250.

## Reading and Writing of PDF files:

`PDF` is a base class for opening or creating PDF documents.

- `my $pdf = PDF.open("mydoc.pdf" :repair)`
 Opens an input `PDF` (or `FDF`) document.
  - `:!repair` causes the read to load only the trailer dictionary and cross reference tables from the tail of the PDF (Cross Reference Table or a PDF 1.5+ Stream). Remaining objects will be lazily loaded on demand.
  - `:repair` causes the reader to perform a full scan, ignoring and recalculating the cross reference stream/index and stream lengths. This can be handy if the PDF document has been hand-edited.

- `$pdf.update`
This performs an incremental update to the input pdf, which must be indexed `PDF` (not applicable to PDFs opened with `:repair`, FDF or JSON files). A new section is appended to the PDF that contains only updated and newly created objects. This method can be used as a fast and efficient way to make small updates to a large existing PDF document.
    - `:diffs(IO::Handle $fh)` - saves just the updates to an alternate location. This can be later appended to the base PDF to reproduce the updated PDF.

- `$pdf.save-as("mydoc-2.pdf", :compress, :rebuild, :preserve)`
Saves a new document, including any updates. Options:
  - `:compress` - compress objects for minimal size
  - `:!compress` - uncompress objects for human readability
  - `:preserve` - copy the input PDF, then incrementally update. This is generally faster and ensures that any digital signatures are not invalidated,
  - `:rebuild` - discard any unreferenced objects. renumber remaining objects. It may be a good idea to rebuild a PDF Document, that's been incrementally updated a number of times.

Note that the `:compress` and `:rebuild` options are a trade-off. The document may take longer to save, however file-sizes and the time needed to reopen the document may improve.

- `$pdf.save-as("mydoc.json", :compress, :rebuild); my $pdf2 = $pdf.open: "mydoc.json"`
Documents can also be saved and opened from an intermediate `JSON` representation. This can be handy for debugging, analysis and/or ad-hoc patching of PDF files.

### Reading PDF Files

The `.open` method loads a PDF index (cross reference table and/or stream). The document can then be access randomly via the
`.ind.obj(...)` method.

The document can be traversed by dereferencing Array and Hash objects. The reader will load indirect objects via the index, as needed. 

```
use PDF::Reader;
use PDF::COS;

my PDF::Reader $reader .= new;
$reader.open: 'examples/helloworld.pdf';

# objects can be directly fetched by object-number and generation-number:
my $page1 = $reader.ind-obj(4, 0).object;

# Hashes and arrays are tied. This is usually more convenient for navigating
my $pdf = $reader.trailer<Root>;
$page1 = $pdf<Pages><Kids>[0];

# Tied objects can also be updated directly.
$reader.trailer<Info><Creator> = PDF::COS.coerce( :name<t/helloworld.t> );
```

### Utility Scripts
- `pdf-rewriter.p6 [--repair] [--rebuild] [--[/]compress] [--password=Xxx] [--decrypt] <pdf-or-json-file-in> [<pdf-or-json-file-out>]`
This script is a thin wrapper for the `PDF` `.open` and `.save-as` methods. It can typically be used to:
  - uncompress a PDF for readability
  - repair a PDF who's cross-reference index or stream lengths have become invalid
  - convert between PDF and JSON

### Decode Filters

Filters are used to compress or decompress stream data in objects of type `PDF::COS::Stream`. These are implemented as follows:

*Filter Name* | *Short Name* | Filter Class
--- | --- | ---
ASCIIHexDecode  | AHx | PDF::IO::Filter::ASCIIHex
ASCII85Decode   | A85 | PDF::IO::Filter::ASCII85
CCITTFaxDecode  | CCF | _NYI_
Crypt           |     | _NYI_
DCTDecode       | DCT | _NYI_
FlateDecode     | Fl  | PDF::IO::Filter::Flate
LZWDecode       | LZW | PDF::IO::Filter::LZW (`decode` only)
JBIG2Decode     |     | _NYI_
JPXDecode       |     | _NYI_
RunLengthDecode | RL  | PDF::IO::Filter::RunLength

Input to all filters is byte strings, with characters in the range \x0 ... \0xFF. latin-1 encoding is recommended to enforce this.

Each filter has `encode` and `decode` methods, which accept and return latin-1 encoded strings, or binary blobs.

```
my Blob $encoded = PDF::IO::Filter.encode( :dict{ :Filter<RunLengthDecode> },
                                      "This    is waaay toooooo loooong!");
say $encoded.bytes;
 ```

### Encryption

PDF::IO::Crypt supports RC4 and AES encryption (revisions /R 2 - 4 and versions /V 1 - 4 of PDF Encryption).

To open an encrypted PDF document, specify either the user or owner password: `PDF.open( "enc.pdf", :password<ssh!>)`

A document can be encrypted using the `encrypt` method: `$pdf.encrypt( :owner-pass<ssh1>, :user-pass<abc>, :aes )`
   - `:aes` encrypts the document using stronger V4 AES encryption, introduced with PDF 1.6.

Note that it's quite common to leave the user-password blank. This indicates that the document is readable by anyone, but may have restrictions on update, printing or copying of the PDF.

An encrypted PDF can be saved as JSON. It will remain encrypted and passwords may be required, to reopen it.

## Data-types and Coercion

The `PDF::COS` name-space provides roles and classes for the representation and manipulation of PDF objects.

[COS (Carousel Object System) is the original name for the file structure and object system used for PDF and FDF files - see https://en.wikipedia.org/wiki/Portable_Document_Format#File_structure].

```
use PDF::COS::Stream;
my %dict = :Filter( :name<ASCIIHexDecode> );
my $obj-num = 123;
my $gen-num = 4;
my $decoded = "100 100 Td (Hello, world!) Tj";
my PDF::COS::Stream $stream-obj .= new( :$obj-num, :$gen-num, :%dict, :$decoded );
say $stream-obj.encoded;
```

`PDF::COS.coerce` is a method for the construction of objects.

It is used internally to build objects from parsed AST data, e.g.:

```
use v6;
use PDF::Grammar::COS;
use PDF::Grammar::COS::Actions;
use PDF::COS;
my PDF::Grammar::COS::Actions $actions .= new;
my \p = PDF::Grammar::COS.parse("<< /Type /Pages /Count 1 /Kids [ 4 0 R ] >>", :rule<object>, :$actions)
    or die "parse failed";
my %ast = p.ast;

say '#'~%ast.perl;
#:dict({:Count(:int(1)), :Kids(:array([:ind-ref([4, 0])])), :Type(:name("Pages"))})

my $reader = class { has $.auto-deref = False }.new; # dummy reader
my $object = PDF::COS.coerce( %ast, :$reader );

say '#'~$object.WHAT.gist;
#(PDF::COS::Dict)

say '#'~$object.perl;
#{:Count(1), :Kids([:ind-ref([4, 0])]), :Type("Pages")}

say '#'~$object<Type>.WHAT.^name;
#(Str+{PDF::COS::Name})
```
The `PDF::COS.coerce` method is also used to construct new objects from application data.

In many cases, AST tags will coerce if omitted. E.g. we can use `1`, instead of `:int(1)`:
```
# using explicit AST tags
use PDF::COS;
my $reader = class { has $.auto-deref = False }.new; # dummy reader

my $object2 = PDF::COS.coerce({ :Type( :name<Pages> ),
                                :Count(:int(1)),
                                :Kids[ :array[ :ind-ref[4, 0] ] ], },
				:$reader);

# same but with a casting from Perl types
my $object3 = PDF::COS.coerce({ :Type( :name<Pages> ),
                                :Count(1),
                                :Kids[ :ind-ref[4, 0],  ] },
				:$reader);

```

A table of Object types and coercements follows:

*AST Tag* | Object Role/Class | *Perl 6 Type Coercion | PDF Example | Description |
--- | --- | --- | --- | --- |
 `array` | PDF::COS::Array | Array | `[ 1 (foo) /Bar ]` | array objects
`bool` | PDF::COS::Bool | Bool | `true`
`int` | PDF::COS::Int | Int | `42`
`literal` | PDF::COS::ByteString (literal) | Str | `(hello world)`
`literal` | PDF::COS::DateString | DateTime | `(D:199812231952-08'00')`
`hex-string` | PDF::COS::ByteString (hex-string) | | `<736E6F6f7079>`
`dict` | PDF::COS::Dict | Hash | `<< /Length 42 /Apples(oranges) >>` | abstract class for dictionary based indirect objects. Root Object, Catalog, Pages tree etc.
`name` | PDF::COS::Name | | `/Catalog`
`null` | PDF::COS::Null | Any | `null`
`real` | PDF::COS::Real | Numeric | `3.14159`
`stream`| PDF::COS::Stream | | | abstract class for stream based indirect objects - base class from Xref and Object streams, fonts and general content.

`PDF::COS` also provides a few essential derived classes, that form part of the basic PDF infrastructure.

*Class* | *Base Class* | *Description*
--- | --- | --- |
PDF | PDF::COS::Dict | document entry point - the trailer dictionary
PDF::COS::Type::Encrypt | PDF::COS::Dict | PDF Encryption/Permissions dictionary
PDF::COS::Type::Info | PDF::COS::Dict | Document Information Dictionary
PDF::COS::Type::ObjStm | PDF::COS::Stream | PDF 1.5+ Object stream (packed indirect objects)
PDF::COS::Type::XRef | PDF::COS::Stream | PDF 1.5+ Cross Reference stream

## Further Reading

- [PDF Explained](http://shop.oreilly.com/product/0636920021483.do) By John Whitington (120pp) - Offers an excellent overview of the PDF format.
- [PDF Reference version 1.7](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/pdf_reference_1-7.pdf) Adobe Systems Incorporated - This is the main reference used in the construction of this module.

## See also
- [PDF::Lite](https://github.com/p6-pdf/PDF-Lite-p6) - basic graphics; including images, fonts, text and general graphics
- [PDF::API6](https://github.com/p6-pdf/PDF-API6) - general purpose PDF manipulation (under construction)
