# perl6-CSS-Properties

<a href="https://travis-ci.org/p6-css/CSS-Properties-p6"><img src="https://travis-ci.org/p6-css/CSS-Properties-p6.svg?branch=master"></a>
 <a href="https://ci.appveyor.com/project/dwarring/CSS-Properties-p6/branch/master"><img src="https://ci.appveyor.com/api/projects/status/github/p6-css/CSS-Properties-p6?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true"></a>

CSS::Properties is a class for parsing and generation of CSS property lists, including box-model, inheritance, and defaults.


## Basic Construction
```
use v6;
use CSS::Properties::Units :pt;
use CSS::Properties;

my $style = "color:red !important; padding: 1pt";
my CSS::Properties $css .= new( :$style );
say $css.important("color"); # True
$css.border-color = 'red';

$css.margin = [5pt, 2pt, 5pt, 2pt];
$css.margin = 5pt;  # set margin on all 4 sides

# set text alignment
$css.text-align = 'right';

say ~$css; # border-color:red; color:red!important; margin:5pt; padding:1pt; text-align:right;
```

## CSS Property Accessors 

- color values are converted to Color objects
- other values are converted to strings or numeric, as appropriate
- the .type method returns additional type information
- box properties are arrays that contain four sides. For example, 'margin' contains 'margin-top', 'margin-right', 'margin-bottom' and 'margin-left';
- there are also some compound properties that may be accessed directly or via a hash; for example, The 'font' accessor returns a hash containing 'font-size', 'font-family', and other font properties.

```
use CSS::Properties;

my CSS::Properties $css .= new: :style("color: orange; text-align: CENTER; margin: 2pt; font: 12pt Helvetica");

say $css.color.hex;       # (FF A5 00)
say $css.color.type;      # 'rgb'
say $css.text-align;      # 'center'
say $css.text-align.type; # 'keyw' (keyword)

# access margin-top, directly and through margin container
say $css.margin-top;      # '2'
say $css.margin-top.type; # 'pt'
say $css.margin;          # [2 2 2 2]
say $css.margin[0];       # '2'
say $css.margin[0].type;  # 'pt'

# access font-family directly and through font container
say $css.font-family;       # 'Helvetica'
say $css.font-family.type;  # 'ident'
say $css.font<font-family>; # 'Helvetica;
```

- The simplest ways of setting a property is to assign a string value which is parsed as CSS.
- Unit values are also recognized. E.g. `16pt`.
- Colors can be assigned to color objects
- Also the type and value can be assigned as a pair.

```
use CSS::Properties;
use CSS::Properties::Units :pt;
use Color;
my CSS::Properties $css .= new;

# assign to container
$css.font = "14pt Helvetica";

# assign to simple properties
$css.font-weight = 'bold'; # string
$css.line-height = 16pt;   # unit value
$css.border-color = Color.new(0, 255, 0);
$css.font-style = :keyw<italic>; # type/value pair

say ~$css; # font:italic bold 14pt/16pt Helvetica;
```

## CSS Modules

## Conformance Levels

Processing defaults to CSS level 3 (class CSS::Module::CSS3). This can be configured via the :module option:

```
use CSS::Properties;
use CSS::Module::CSS1;
use CSS::Module::CSS21;

my $style = 'color: red; azimuth: left';

my $module = CSS::Module::CSS1.module;
my CSS::Properties $css1 .= new( :$style, :$module);
## warnings: dropping unknown property: azimuth

$module = CSS::Module::CSS21.module;
my CSS::Properties $css21 .= new( :$style, :$module);
## (no warnings)
```

### '@font-face' Properties

`@font-face` is a sub-module of `CSS3`. To process a set of `@font-face` declarations, such as:

```
@font-face {
    font-family: myFirstFont;
    src: url(sansation_light.woff);
}
```

```
use CSS::Properties;
use CSS::Module::CSS3;

my $style = "font-family: myFirstFont; src: url(sansation_light.woff)";
my $module = CSS::Module::CSS3.module.sub-module<@font-face>;
my CSS::Properties $font-face-css .= new( :$style, :$module);
```

## Default values

Most properties have a default value. If a property is reset to its default value it will be omitted from stringification:

    my $css = (require CSS::Properties).new;
    say $css.background-image; # none
    $css.background-image = 'url(camellia.png)';
    say ~$css; # "background-image: url(camellia.png);"
    $css.background-image = $css.info("background-image").default;
    say ~$css; # ""

## Deleting properties

Properties can be deleted via the `delete` method, or by assigning the property to `Nil`:

    my CSS::Properties $css .= new: :style("background-position:top left; border-top-color:red; border-bottom-color: green; color: blue");
    # delete background position
    $css.background-position = Nil;
    # delete all border colors
    $css.delete: "border-color";

## Inheritance

A child class can inherit from one or more parent classes. This follows CSS standards:

- not all properties are inherited by default; for example `color` is, but `margin` is not.

- the `inherit` keyword can be used in the child property to ensure inheritance.

- `initial` will reset the child property to the default value

- the `!important` modifier can be used in parent properties to force the parent value to override the child. The property remains 'important' in the child and will be passed on to any CSS::Properties objects that inherit from it.

To inherit a css object or style string:

- pass it as a `:inherit` option, when constructing the object, or

- use the `inherit` method

```
use CSS::Properties;

my $parent-style = "margin-top:5pt; margin-left: 15pt; color:rgb(0,0,255) !important";
my $style = "margin-top:25pt; margin-right: initial; margin-left: inherit; color:purple";
my CSS::Properties $css .= new: :$style, :inherit($parent-style);

say $css.color;                     # #FF0000 (red)
say $css.handling("margin-left");   # inherit
say $css.margin-left;               # 15pt
```

## Optimization and Serialization

The `.write` or `.Str` methods can be used to produce CSS. Properties are optimized and normalized:

- properties with default values are omitted

- multiple component properties are consolidated to compound properties, where possible (e.g. `font-family` and `font-size`
  are consolidated to `font`).

- rgb masks are translated to color-names, where possible

```
use CSS::Properties;
my CSS::Properties $css .= new( :style("background-repeat:repeat; border-style: groove; border-width: 2pt 2pt; color: rgb(255,0,0);") );
# - 'border-width' and 'border-style' are consolidated to the 'border' compound property
# - rgb(255,0,0) is mapped to 'red'
say $css.write;  # "border:2pt groove; color: red;"
```

Notice that:

- `background-repeat` was omitted because it has the default value

- `border-style` and `border-width` have been consolidated to the `border` container property. This is possible
because all four borders have common values

- `color` has been translated from a color mask to a color

`$.write` Options include:

- `:!optimize` - turn off optimization. Don't, combine simple properties into compound properties (`border-style`, `border-width`, ... => `border`), or combine edges (`margin-top`, `margin-left`, ... => `margin`).

- `:!terse` - enable multi-line output

- `:!color-names` - don't translate RGB values to color-names

ASTs can also be directly optimized:
```
use CSS::Properties;
use CSS::Module::CSS3;
use CSS::Writer;

my CSS::Properties $css .= new;
my $module = CSS::Module::CSS3.module;
my $actions = $module.actions.new;
my CSS::Writer $writer .= new: :color-names, :terse;
my $declarations = "border-bottom-color:red; border-bottom-style:solid; border-bottom-width:1px; border-left-color:red; border-left-style:solid; border-left-width:1px; border-right-color:red; border-right-style:solid; border-right-width:1px; border-top-color:red; border-top-style:solid; border-top-width:1px;";
my $p = $module.grammar.parse($declarations, :$actions, :rule<declaration-list>);
my %ast = $css.optimize($p.ast);
say $writer.write(|%ast); # border:1px solid red;
```

## Property Meta-data

The `info` method gives property specific meta-data, on all simple of compound properties. It returns an object of type CSS::Properties::Property:

```
use CSS::Properties;
my CSS::Properties $css .= new;
my $margin-info = $css.info("margin");
say $margin-info.synopsis; # <margin-width>{1,4}
say $margin-info.edges;    # [margin-top margin-right margin-bottom margin-left]
say $margin-info.inherit;  # True (property is inherited)
```

## Data Introspection

The `properties` method, gives a list of current properties. Only simple properties
are returned. E.g. `font-family` is, if it has a value; but `font` isn't.

```
use CSS::Properties;

my $style = "margin-top: 10%; margin-right: 5mm; margin-bottom: auto";
my CSS::Properties $css .= new: :$style;

for $css.properties -> $prop {
    my $val = $css."$prop"();
    say "$prop: $val {$val.type}";
}

```
Gives:
```
margin-top: 10 percent
margin-bottom: auto keyw
margin-right: 5 mm
```

## Length Units

CSS::Declaration::Units is a convenience module that provides some simple post-fix length unit definitions.

The `:ops` export overloads  `+` and `-` to perform unit
calculations. `+css` and `-css` are also available as
more explicit infix operators:

All infix operators convert to the left-hand operand's units.

```
use CSS::Properties::Units :ops, :pt, :px, :in, :mm;
my $css = (require CSS::Properties).new: :margin[5pt, 10px, .1in, 2mm];

# display margins in millimeters
say "%.2f mm".sprintf(0mm + $_) for $css.margin.list;

# display padding in inches
say "%.2f in".sprintf(0in +css $_) for $css.padding.list;
```

## Box Model

### Overview

Excerpt from [CSS 2.2 Specification Chapter 8 - Box Model](https://www.w3.org/TR/CSS22/box.html#box-dimensions):

![Box Model](doc/boxdim.png)

The margin, border, and padding can be broken down into top, right, bottom, and left segments (e.g., in the diagram, "LM" for left margin, "RP" for right padding, "TB" for top border, etc.).

The perimeter of each of the four areas (content, padding, border, and margin) is called an "edge", so each box has four edges:

- *Content Edge* or *Inner Edge* - 
  The content edge surrounds the rectangle given by the width and height of the box, which often depend on the element's rendered content. The four content edges define the box's content box.

- *Padding Edge* -
The padding edge surrounds the box padding. If the padding has 0 width, the padding edge is the same as the content edge. The four padding edges define the box's padding box.

- *Border Edge* -
The border edge surrounds the box's border. If the border has 0 width, the border edge is the same as the padding edge. The four border edges define the box's border box.

- *Margin Edge or Outer Edge* -
The margin edge surrounds the box margin. If the margin has 0 width, the margin edge is the same as the border edge. The four margin edges define the box's margin box.

### `CSS::Properties::Box`

`CSS::Properties::Box` is an abstract class for modelling Box Model elements.

    use CSS::Properties::Box;
    use CSS::Properties::Units :px, :pt, :em, :percent;
    use CSS::Properties;

    my $style = q:to"END";
        width:   300px;
        border:  25px solid green;
        padding: 25px;
        margin:  25px;
        font:    italic bold 10pt/12pt times-roman;
        END

    my CSS::Properties $css .= new: :$style;
    my $top    = 80pt;
    my $right  = 50pt;
    my $bottom = 10pt;
    my $left   = 10pt;

    my CSS::Properties::Box $box .= new( :$top, :$left, :$bottom, :$right, :$css );
    say $box.padding;           # dimensions of padding box;
    say $box.margin;            # dimensions of margin box;
    say $box.border-right;      # vertical position of right border
    say $box.border-width;      # border-right - border-left
    say $box.width("border");   # border-width
    say $box.height("content"); # height of content box

    say $box.font.family;        # 'times-roman'
    # calculate some relative font lengths
    say $box.font-length(1.5em);    # 15
    say $box.font-length(200%);     # 20
    say $box.font-length('larger'); # 12

### Box Methods

#### new

    my CSS::Properties::Box $box .= new( :$top, :$left, :$bottom, :$right, :$css );

The box `new` constructor accepts:

  - any two of `:top`, `:bottom` or `:height`,

  - and any two of `:left`, `:right` or `:width`.

#### font

    say "font-size is {$box.font.em}";

The '.font' accessor returns an object of type `CSS::Properties::Font`, with accessor methods: `em`, `ex`, `weight`, `family`, `style`, `leading`, `find-font` and `fontconfig-pattern`.

#### measure

This method converts various length units to normalized base units (default 'pt').

    use CSS::Properties::Units :mm, :in, :pt, :px;
    use CSS::Properties::Box;
    use CSS::Properties;
    my CSS::Properties::Box $box .= new;
    # default base units is points
    say [(1mm, 1in, 1pt, 1px).map: {$box.measure($_)}];
    # produces: [2.8346pt 72pt 1pt 0.75pt]
    # change base units to inches
    $box .= new: :units<in>;
    say [(1in, 72pt).map: {$box.measure($_)}];
    # produces: [1in, 1in]

#### top, right, bottom, left

These methods return measured positions of each of the four corners of the inner content box. They
are rw accessors, e.g.:

    $box.top += 5;

Outer boxes will grow and shrink, retaining their original width and height.

#### padding, margin, border

This returns all four corners (measured) of the given box, e.g.:

    my Numeric ($top, $right, $bottom, $left) = $box.padding


#### content

This returns all four corners (measured) of the content box, e.g.:

    my Numeric ($top, $right, $bottom, $left) = $box.content;

These values are rw. The box can be both moved and resized, by adjusting this array.

    $box.content = (10, 50, 35, 10); # 40x25 box, top-left @ 10,10

Outer boxes, will grow or shrink to retain their original widths.

#### [padding|margin|border|content]-[width|height]

     say "margin box is size {$box.margin-width} X {$box.margin-height}";

This family of accessors return the measured width, or height of the given box.

#### [padding|margin|border|content]-[top|right|bottom|left]

     say "margin left, top is ({$box.margin-left}, {$box.margin-top})";

This family of accessors return the measured x or y position of the given edge

#### translate, move

These methods can be used to adjust the position of the content box.

    $box.translate(10, 20); # translate box 10, 20 in X, Y directions
    $box.move(40, 50); # move top left corner to (X, Y) = (40, 50)

## Appendix : CSS3 Properties

Name | Default | Inherit | Type | Synopsis
--- | --- | --- | --- | ---
azimuth | center | Yes |  | \<angle\> \| [[ left-side \| far-left \| left \| center-left \| center \| center-right \| right \| far-right \| right-side ] \|\| behind ] \| leftwards \| rightwards
background |  |  | hash | ['background-color' \|\| 'background-image' \|\| 'background-repeat' \|\| 'background-attachment' \|\| 'background-position']
background-attachment | scroll |  |  | scroll \| fixed
background-color | transparent |  |  | \<color\> \| transparent
background-image | none |  |  | \<uri\> \| none
background-position | 0% 0% |  |  | [ [ \<percentage\> \| \<length\> \| left \| center \| right ] [ \<percentage\> \| \<length\> \| top \| center \| bottom ]? ] \| [ [ left \| center \| right ] \|\| [ top \| center \| bottom ] ]
background-repeat | repeat |  |  | repeat \| repeat-x \| repeat-y \| no-repeat
border |  |  | hash,box | [ 'border-width' \|\| 'border-style' \|\| 'border-color' ]
border-bottom |  |  | hash | [ 'border-bottom-width' \|\| 'border-bottom-style' \|\| 'border-bottom-color' ]
border-bottom-color | the value of the 'color' property |  |  | \<color\> \| transparent
border-bottom-style | none |  |  | \<border-style\>
border-bottom-width | medium |  |  | \<border-width\>
border-collapse | separate | Yes |  | collapse \| separate
border-color |  |  | box | [ \<color\> \| transparent ]{1,4}
border-left |  |  | hash | [ 'border-left-width' \|\| 'border-left-style' \|\| 'border-left-color' ]
border-left-color | the value of the 'color' property |  |  | \<color\> \| transparent
border-left-style | none |  |  | \<border-style\>
border-left-width | medium |  |  | \<border-width\>
border-right |  |  | hash | [ 'border-right-width' \|\| 'border-right-style' \|\| 'border-right-color' ]
border-right-color | the value of the 'color' property |  |  | \<color\> \| transparent
border-right-style | none |  |  | \<border-style\>
border-right-width | medium |  |  | \<border-width\>
border-spacing | 0 | Yes |  | \<length\> \<length\>?
border-style |  |  | box | \<border-style\>{1,4}
border-top |  |  | hash | [ 'border-top-width' \|\| 'border-top-style' \|\| 'border-top-color' ]
border-top-color | the value of the 'color' property |  |  | \<color\> \| transparent
border-top-style | none |  |  | \<border-style\>
border-top-width | medium |  |  | \<border-width\>
border-width |  |  | box | \<border-width\>{1,4}
bottom | auto |  |  | \<length\> \| \<percentage\> \| auto
caption-side | top | Yes |  | top \| bottom
clear | none |  |  | none \| left \| right \| both
clip | auto |  |  | \<shape\> \| auto
color | depends on user agent | Yes |  | \<color\>
content | normal |  |  | normal \| none \| [ \<string\> \| \<uri\> \| \<counter\> \| \<counters\> \| attr(\<identifier\>) \| open-quote \| close-quote \| no-open-quote \| no-close-quote ]+
counter-increment | none |  |  | none \| [ \<identifier\> \<integer\>? ]+
counter-reset | none |  |  | none \| [ \<identifier\> \<integer\>? ]+
cue |  |  | hash | [ 'cue-before' \|\| 'cue-after' ]
cue-after | none |  |  | \<uri\> \| none
cue-before | none |  |  | \<uri\> \| none
cursor | auto | Yes |  | [ [\<uri\> ,]* [ auto \| crosshair \| default \| pointer \| move \| e-resize \| ne-resize \| nw-resize \| n-resize \| se-resize \| sw-resize \| s-resize \| w-resize \| text \| wait \| help \| progress ] ]
direction | ltr | Yes |  | ltr \| rtl
display | inline |  |  | inline \| block \| list-item \| inline-block \| table \| inline-table \| table-row-group \| table-header-group \| table-footer-group \| table-row \| table-column-group \| table-column \| table-cell \| table-caption \| none
elevation | level | Yes |  | \<angle\> \| below \| level \| above \| higher \| lower
empty-cells | show | Yes |  | show \| hide
float | none |  |  | left \| right \| none
font |  | Yes | hash | [ [ \<‘font-style’\> \|\| \<font-variant-css21\> \|\| \<‘font-weight’\> \|\| \<‘font-stretch’\> ]? \<‘font-size’\> [ / \<‘line-height’\> ]? \<‘font-family’\> ] \| caption \| icon \| menu \| message-box \| small-caption \| status-bar
font-family | depends on user agent | Yes |  | [ \<generic-family\> \| \<family-name\> ]\#
font-feature-settings | normal | Yes |  | normal \| \<feature-tag-value\>\#
font-kerning | auto | Yes |  | auto \| normal \| none
font-language-override | normal | Yes |  | normal \| \<string\>
font-size | medium | Yes |  | \<absolute-size\> \| \<relative-size\> \| \<length\> \| \<percentage\>
font-size-adjust | none | Yes |  | none \| auto \| \<number\>
font-stretch | normal | Yes |  | normal \| ultra-condensed \| extra-condensed \| condensed \| semi-condensed \| semi-expanded \| expanded \| extra-expanded \| ultra-expanded
font-style | normal | Yes |  | normal \| italic \| oblique
font-synthesis | weight style | Yes |  | none \| [ weight \|\| style ]
font-variant | normal | Yes |  | normal \| none \| [ \<common-lig-values\> \|\| \<discretionary-lig-values\> \|\| \<historical-lig-values\> \|\| \<contextual-alt-values\> \|\| stylistic(\<feature-value-name\>) \|\| historical-forms \|\| styleset(\<feature-value-name\> \#) \|\| character-variant(\<feature-value-name\> \#) \|\| swash(\<feature-value-name\>) \|\| ornaments(\<feature-value-name\>) \|\| annotation(\<feature-value-name\>) \|\| [ small-caps \| all-small-caps \| petite-caps \| all-petite-caps \| unicase \| titling-caps ] \|\| \<numeric-figure-values\> \|\| \<numeric-spacing-values\> \|\| \<numeric-fraction-values\> \|\| ordinal \|\| slashed-zero \|\| \<east-asian-variant-values\> \|\| \<east-asian-width-values\> \|\| ruby ]
font-variant-alternates | normal | Yes |  | normal \| [ stylistic(\<feature-value-name\>) \|\| historical-forms \|\| styleset(\<feature-value-name\>\#) \|\| character-variant(\<feature-value-name\>\#) \|\| swash(\<feature-value-name\>) \|\| ornaments(\<feature-value-name\>) \|\| annotation(\<feature-value-name\>) ]
font-variant-caps | normal | Yes |  | normal \| small-caps \| all-small-caps \| petite-caps \| all-petite-caps \| unicase \| titling-caps
font-variant-east-asian | normal | Yes |  | normal \| [ \<east-asian-variant-values\> \|\| \<east-asian-width-values\> \|\| ruby ]
font-variant-ligatures | normal | Yes |  | normal \| none \| [ \<common-lig-values\> \|\| \<discretionary-lig-values\> \|\| \<historical-lig-values\> \|\| \<contextual-alt-values\> ]
font-variant-numeric | normal | Yes |  | normal \| [ \<numeric-figure-values\> \|\| \<numeric-spacing-values\> \|\| \<numeric-fraction-values\> \|\| ordinal \|\| slashed-zero ]
font-variant-position | normal | Yes |  | normal \| sub \| super
font-weight | normal | Yes |  | normal \| bold \| bolder \| lighter \| 100 \| 200 \| 300 \| 400 \| 500 \| 600 \| 700 \| 800 \| 900
height | auto |  |  | \<length\> \| \<percentage\> \| auto
left | auto |  |  | \<length\> \| \<percentage\> \| auto
letter-spacing | normal | Yes |  | normal \| \<length\>
line-height | normal | Yes |  | normal \| \<number\> \| \<length\> \| \<percentage\>
list-style |  | Yes | hash | [ 'list-style-type' \|\| 'list-style-position' \|\| 'list-style-image' ]
list-style-image | none | Yes |  | \<uri\> \| none
list-style-position | outside | Yes |  | inside \| outside
list-style-type | disc | Yes |  | disc \| circle \| square \| decimal \| decimal-leading-zero \| lower-roman \| upper-roman \| lower-greek \| lower-latin \| upper-latin \| armenian \| georgian \| lower-alpha \| upper-alpha \| none
margin |  |  | box | \<margin-width\>{1,4}
margin-bottom | 0 |  |  | \<margin-width\>
margin-left | 0 |  |  | \<margin-width\>
margin-right | 0 |  |  | \<margin-width\>
margin-top | 0 |  |  | \<margin-width\>
max-height | none |  |  | \<length\> \| \<percentage\> \| none
max-width | none |  |  | \<length\> \| \<percentage\> \| none
min-height | 0 |  |  | \<length\> \| \<percentage\>
min-width | 0 |  |  | \<length\> \| \<percentage\>
opacity | 1.0 |  |  | \<number\>
orphans | 2 | Yes |  | \<integer\>
outline |  |  | hash | [ 'outline-color' \|\| 'outline-style' \|\| 'outline-width' ]
outline-color | invert |  |  | \<color\> \| invert
outline-style | none |  |  | [ none \| hidden \| dotted \| dashed \| solid \| double \| groove \| ridge \| inset \| outset ]
outline-width | medium |  |  | thin \| medium \| thick \| \<length\>
overflow | visible |  |  | visible \| hidden \| scroll \| auto
padding |  |  | box | \<padding-width\>{1,4}
padding-bottom | 0 |  |  | \<padding-width\>
padding-left | 0 |  |  | \<padding-width\>
padding-right | 0 |  |  | \<padding-width\>
padding-top | 0 |  |  | \<padding-width\>
page-break-after | auto |  |  | auto \| always \| avoid \| left \| right
page-break-before | auto |  |  | auto \| always \| avoid \| left \| right
page-break-inside | auto |  |  | avoid \| auto
pause |  |  |  | [ [\<time\> \| \<percentage\>]{1,2} ]
pause-after | 0 |  |  | \<time\> \| \<percentage\>
pause-before | 0 |  |  | \<time\> \| \<percentage\>
pitch | medium | Yes |  | \<frequency\> \| x-low \| low \| medium \| high \| x-high
pitch-range | 50 | Yes |  | \<number\>
play-during | auto |  |  | \<uri\> [ mix \|\| repeat ]? \| auto \| none
position | static |  |  | static \| relative \| absolute \| fixed
quotes | depends on user agent | Yes |  | [\<string\> \<string\>]+ \| none
richness | 50 | Yes |  | \<number\>
right | auto |  |  | \<length\> \| \<percentage\> \| auto
size | auto |  |  | \<length\>{1,2} \| auto \| [ \<page-size\> \|\| [ portrait \| landscape] ]
speak | normal | Yes |  | normal \| none \| spell-out
speak-header | once | Yes |  | once \| always
speak-numeral | continuous | Yes |  | digits \| continuous
speak-punctuation | none | Yes |  | code \| none
speech-rate | medium | Yes |  | \<number\> \| x-slow \| slow \| medium \| fast \| x-fast \| faster \| slower
stress | 50 | Yes |  | \<number\>
table-layout | auto |  |  | auto \| fixed
text-align | a nameless value that acts as 'left' if 'direction' is 'ltr', 'right' if 'direction' is 'rtl' | Yes |  | left \| right \| center \| justify
text-decoration | none |  |  | none \| [ underline \|\| overline \|\| line-through \|\| blink ]
text-indent | 0 | Yes |  | \<length\> \| \<percentage\>
text-transform | none | Yes |  | capitalize \| uppercase \| lowercase \| none
top | auto |  |  | \<length\> \| \<percentage\> \| auto
unicode-bidi | normal |  |  | normal \| embed \| bidi-override
vertical-align | baseline |  |  | baseline \| sub \| super \| top \| text-top \| middle \| bottom \| text-bottom \| \<percentage\> \| \<length\>
visibility | visible | Yes |  | visible \| hidden \| collapse
voice-family | depends on user agent | Yes |  | [\<generic-voice\> \| \<specific-voice\> ]\#
volume | medium | Yes |  | \<number\> \| \<percentage\> \| silent \| x-soft \| soft \| medium \| loud \| x-loud
white-space | normal | Yes |  | normal \| pre \| nowrap \| pre-wrap \| pre-line
widows | 2 | Yes |  | \<integer\>
width | auto |  |  | \<length\> \| \<percentage\> \| auto
word-spacing | normal | Yes |  | normal \| \<length\>
z-index | auto |  |  | auto \| \<integer\>


The above markdown table was produced with the following code snippet

```
use v6;
say <Name Default Inherit Type Synopsis>.join(' | ');
say ('---' xx 5).join(' | ');

my $css = (require CSS::Properties).new;

for $css.properties(:all).sort -> $name {
    with $css.info($name) {
        my @type;
        @type.push: 'hash' if .children;
        @type.push: 'box' if .box;
        my $synopsis-escaped = .synopsis.subst(/<?before <[ < | > # ]>>/, '\\', :g); 

        say ($name,
             .default // '',
             .inherit ?? 'Yes' !! '',
             @type.join(','),
             $synopsis-escaped,
            ).join(' | ');
    }
}

```
