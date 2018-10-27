# Perl6-Math-Matrix

[![Build Status](https://travis-ci.org/pierre-vigier/Perl6-Math-Matrix.svg?branch=master)](https://travis-ci.org/pierre-vigier/Perl6-Math-Matrix)
[![Build status](https://ci.appveyor.com/api/projects/status/github/pierre-vigier/Perl6-Math-Matrix?svg=true)](https://ci.appveyor.com/project/pierre-vigier/Perl6-Math-Matrix/branch/master)

NAME
====

Math::Matrix - create, compare, compute and measure 2D matrices

VERSION
=======

0.3.6

!MOVING!
========

This repo will be moved to a [different place](https://github.com/lichtkind/Perl6-Math-Matrix) soon.

SYNOPSIS
========

Matrices are tables with rows and columns (index counting from 0) of numbers (Numeric type - Bool or Int or Num or Rat or FatRat or Complex): 

    transpose, invert, negate, add, multiply, dot product, tensor product, 22 ops, determinant, rank,
    trace, norm, 15 boolean properties, 3 decompositions, submatrix, splice, map, reduce and more

Table of Content:

  * [Methods](#methods)

  * [Export Tags](#export-tags)

  * [Operators](#operators)

  * [Authors](#authors)

  * [License](#license)

DESCRIPTION
===========

Because the list based, functional toolbox of Perl 6 is not enough to calculate matrices comfortably, there is a need for a dedicated data type. The aim is to provide a full featured set of structural and mathematical operations that integrate fully with the Perl 6 conventions. This module is pure perl and we plan to use native shaped arrays one day.

Matrices are readonly - operations and functions do create new matrix objects. All methods return readonly data or deep clones - also the constructor does a deep clone of provided data. In that sense the library is thread safe.

All computation heavy properties will be calculated lazily and will be cached.

[METHODS](#synopsis)
====================

  * [constructors](#constructors): [new []](#new--), [new ()](#new---1), [new ""](#new---2), [new-zero](#new-zero), [new-identity](#new-identity), [new-diagonal](#new-diagonal), [new-vector-product](#new-vector-product)

  * [accessors](#accessors): [cell](#cell), [AT-POS](#at-pos), [row](#row), [column](#column), [diagonal](#diagonal), [submatrix](#submatrix)

  * [converter](#type-conversion-and-output-formats): [Bool](#bool), [Numeric](#numeric), [Str](#str), [Array](#array), [Hash](#hash), [Range](#range), [list](#list), [list-rows](#list-rows), [list-columns](#list-columns), [gist](#gist), [perl](#perl)

  * [boolean properties](#boolean-properties): [is-zero](#is-zero), [is-identity](#is-identity), [is-square](#is-square), [is-diagonal](#is-diagonal), [is-diagonally-dominant](#is-diagonally-dominant), [is-upper-triangular](#is-upper-triangular), [is-lower-triangular](#is-lower-triangular), [is-invertible](#is-invertible), [is-symmetric](#is-symmetric), [is-antisymmetric](#is-antisymmetric), [is-unitary](#is-unitary), [is-self-adjoint](#is-self-adjoint), [is-orthogonal](#is-orthogonal), [is-positive-definite](#is-positive-definite), [is-positive-semidefinite](#is-positive-semidefinite)

  * [numeric properties](#numeric-properties): [size](#size), [density](#density), [trace](#trace), [determinant](#determinant), [rank](#rank), [nullity](#nullity), [norm](#norm), [condition](#condition), [minor](#minor), [narrowest-cell-type](#narrowest-cell-type), [widest-cell-type](#widest-cell-type)

  * [derived matrices](#derived-matrices): [transposed](#transposed), [negated](#negated), [conjugated](#conjugated), [adjugated](#adjugated), [inverted](#inverted), [reduced-row-echelon-form](#reduced-row-echelon-form)

  * [decompositions](#decompositions): [decompositionLUCrout](#decompositionlucrout), [decompositionLU](#decompositionlu), [decompositionCholesky](#decompositioncholesky)

  * [matrix math ops](#matrix-math-operations): [equal](#equal), [add](#add), [subtract](#subtract), [add-row](#add-row), [add-column](#add-column), [multiply](#multiply), [multiply-row](#multiply-row), [multiply-column](#multiply-column), [dot-product](#dot-product), [tensor-product](#tensor-product)

  * [list like ops](#list-like-matrix-operations): [elems](#elems), [elem](#elem), [cont](#cont), [map-index](#map-index), [map-with-index](#map-with-index), [map](#map), [map-row](#map-row), [map-column](#map-column), [reduce](#reduce), [reduce-rows](#reduce-rows), [reduce-columns](#reduce-columns)

  * [structural ops](#structural-matrix-operations): [move-row](#move-row), [move-column](#move-column), [swap-rows](#swap-rows), [swap-columns](#swap-columns), [splice-rows](#splice-rows), [splice-columns](#splice-columns)

  * [shortcuts](#shortcuts): [T](#transposed), [conj](#conjugated), [det](#determinant), [rref](#reduced-row-echelon-form)

  * [operators](#operator-methods): MM, ?, ~, |, @, %, +, -, *, **, dot, ⋅, ÷, X*, ⊗, ==, ~~, ❘ ❘, ‖ ‖, [ ]

[Constructors](#methods)
------------------------

Methods that create a new Math::Matrix object. The default is of course .new, which can take array of array of values (fastest) or one string. Additional constructers: [new-zero](#new-zero), [new-identity](#new-identity), [new-diagonal](#new-diagonal) and [new-vector-product](#new-vector-product) are there for convenience and to optimize property calculation.

### [new( [[...],...,[...]] )](#constructors)

The default constructor, takes arrays of arrays of numbers as the only required parameter. Each second level array represents a row in the matrix. That is why their length has to be the same. Empty rows or columns we not be accepted. 

    say Math::Matrix.new( [[1,2],[3,4]] ) :

    1 2
    3 4

    Math::Matrix.new([<1 2>,<3 4>]); # does the same, WARNING: doesn't work with complex numbers
    Math::Matrix.new( [[1]] );       # one cell 1*1 matrix (exception where you don't have to mind comma)
    Math::Matrix.new( [[1,2,3],] );  # one row 1*3 matrix, mind the trailing comma
    Math::Matrix.new( [$[1,2,3]] );  # does the same, if you don't like trailing comma
    Math::Matrix.new( [[1],[2]] );   # one column 2*1 matrix

    use Math::Matrix :MM;            # tag :ALL works too
    MM [[1,2],[3,4]];                # shortcut

### [new( ((...),...,(...)) )](#constructors)

Instead of square brackets you can use round ones too and use a list of lists as argument too.

    say Math::Matrix.new( ((1,2),(3,4)) ) :

    1 2
    3 4

### [new( "..." )](#constructors)

Alternatively you can define the matrix from a string, which makes most sense while using heredocs.

    Math::Matrix.new("1 2 \n 3 4"); # our demo matrix as string
    Math::Matrix.new: q:to/END/;    # indent as you wish
        1 2
        3 4
      END

    use Math::Matrix :ALL;          # 
    MM '1';                         # this case begs for a shortcut

### [new-zero](#constructors)

This method is a constructor that returns an zero (sometimes called empty) matrix (as checked by is-zero) of the size given by parameter. If only one parameter is given, the matrix is quadratic. All the cells are set to 0.

    say Math::Matrix.new-zero( 3, 4 ) :

    0 0 0 0
    0 0 0 0
    0 0 0 0

    say Math::Matrix.new-zero( 2 ) :

    0 0
    0 0

### [new-identity](#constructors)

This method is a constructor that returns an identity matrix (as checked by is-identity) of the size given in the only and required parameter. All the cells are set to 0 except the top/left to bottom/right diagonale is set to 1.

    say Math::Matrix.new-identity( 3 ) :
      
    1 0 0
    0 1 0
    0 0 1

### [new-diagonal](#constructors)

This method is a constructor that returns an diagonal matrix (as checked by is-diagonal) of the size given by count of the parameter. All the cells are set to 0 except the top/left to bottom/right diagonal, set to given values.

    say Math::Matrix.new-diagonal( 2, 4, 5 ) :

    2 0 0
    0 4 0
    0 0 5

### [new-vector-product](#constructors)

This method is a constructor that returns a matrix which is a result of the matrix product (method dotProduct, or operator dot) of a column vector (first argument) and a row vector (second argument). It can also be understood as a tensor product of row and column.

    say Math::Matrix.new-vector-product([1,2,3],[2,3,4]) :

    2  3  4     1*2  1*3  1*4
    4  6  8  =  2*2  2*3  2*4
    6  9 12     3*2  3*3  3*4

[Accessors](#methods)
---------------------

Methods that return the content of selected elements (cells).

### [cell](#accessors)

Gets value of element in row (first parameter) and column (second parameter). (counting always from 0)

    my $matrix = Math::Matrix.new([[1,2],[3,4]]);
    say $matrix.cell(0,1)               : 2
    say $matrix[0][1]                   # array syntax alias

### [AT-POS](#accessors)

Gets row as array to enable direct postcircumfix syntax as shown in last example.

    say $matrix.AT-POS(0)     : [1,2]
    say $matrix[0]            # operator alias
    say $matrix.Array[0]      # long alias with converter method Array

### [row](#accessors)

Gets values of specified row (first required parameter) as a list.

    say Math::Matrix.new([[1,2],[3,4]]).row(0) : (1, 2)

### [column](#accessors)

Gets values of specified column (first required parameter) as a list.

    say Math::Matrix.new([[1,2],[3,4]]).column(0) : (1, 3)

### [diagonal](#accessors)

Gets values of diagonal elements as a list. 

    say Math::Matrix.new([[1,2],[3,4]]).diagonal : (1, 4)

### [submatrix](#accessors)

Returns a matrix that might miss certain rows and columns of the original. This method accepts arguments in three different formats. The first follows the strict mathematical definition of a submatrix, the second supports a rather visual understanding of the term and the third is a way to get almost any combination rows and columns you might wish for. To properly present these functions, we base the next examples upon this matrix:

    say $m:    1 2 3 4
               2 3 4 5
               3 4 5 6
               4 5 6 7

In mathematics, a submatrix is built by leaving out one row and one column. In the two argument format you name these by their index ($row, $column).

    say $m.submatrix(1,2) :    1 2 4
                               3 4 6
                               4 5 7

If you provide two ranges (row-min .. row-max, col-min .. col-max) to the appropriately named arguments, you get the two dimensional excerpt of the matrix that is defined by these ranges.

    say $m.submatrix( rows => 1..1, columns => 0..*) :    3 4 5

When provided with two lists (or arrays) of values (to the arguments named "rows" and "columns") a new matrix will be created with that selection of rows and columns. Please note, that you can pick any row/column in any order and as many times you prefer. They will displayed in the order they are listed in the arguments.

    $m.submatrix(rows => (1,2), columns => (3,2)):    5 4
                                                      6 5
                                                      
    $m.submatrix(rows => (1...2), columns => (3,2))  # same thing

The named arguments of both types can be mixed and are in both cases optional. If you provide none of them, the result will be the original matrix.

    say $m.submatrix( rows => (1,) )              :   3 4 5        

    $m.submatrix(rows => (1..*), columns => (3,2)):   5 4
                                                      6 5

[Type Conversion And Output Formats](#methods)
----------------------------------------------

Methods that convert a matrix into other types or allow different views on the overall content.

### [Bool](#type-conversion-and-output-formats)

Conversion into Bool context. Returns False if matrix is zero (all cells equal zero as in is-zero), otherwise True.

    $matrix.Bool
    ? $matrix           # alias op
    if $matrix          # matrix in Bool context too

### [Numeric](#type-conversion-and-output-formats)

Conversion into Numeric context. Returns Euclidean [norm](#norm). Please note, only a prefix operator + (as in: + $matrix) will call this Method. An infix (as in $matrix + $number) calls $matrix.add($number).

    $matrix.Numeric
    + $matrix           # alias op

### [Str](#type-conversion-and-output-formats)

Returns all cell values separated by one whitespace, rows by new line. This is the same format as expected by [Math::Matrix.new("")](#new---2). Str is called implicitly by put and print. A shortened version is provided by [gist](#gist)

    say Math::Matrix.new([[1,2],[3,4]]).Str:

    1 2                 # meaning: "1 2\n3 4"
    3 4                

    ~$matrix            # alias op

### [Array](#type-conversion-and-output-formats)

Content of all cells as an array of arrays (same format that was put into [Math::Matrix.new([...])](#new--)).

    say Math::Matrix.new([[1,2],[3,4]]).Array : [[1 2] [3 4]]
    say @ $matrix       # alias op, space between @ and $ needed

### [list](#type-conversion-and-output-formats)

Returns a flat list with all cells (same as .list-rows.flat.list).

    say $matrix.list    : (1 2 3 4)
    say |$matrix        # alias op

### [list-rows](#type-conversion-and-output-formats)

Returns a list of lists, reflecting the row-wise content of the matrix. Same format as [new ()](#new---1) takes in.

    say Math::Matrix.new( [[1,2],[3,4]] ).list-rows      : ((1 2) (3 4))
    say Math::Matrix.new( [[1,2],[3,4]] ).list-rows.flat : (1 2 3 4)

### [list-columns](#type-conversion-and-output-formats)

Returns a list of lists, reflecting the row-wise content of the matrix.

    say Math::Matrix.new( [[1,2],[3,4]] ).list-columns : ((1 3) (2 4))
    say Math::Matrix.new( [[1,2],[3,4]] ).list-columns.flat : (1 3 2 4)

### [Hash](#type-conversion-and-output-formats)

Gets you a nested key - value hash.

    say $matrix.Hash : { 0 => { 0 => 1, 1 => 2}, 1 => {0 => 3, 1 => 4} } 
    say % $matrix       # alias op, space between % and $ still needed

### [Range](#type-conversion-and-output-formats)

Returns an range object that reflects the content of all cells. Please note that complex number can not be endpoints of ranges.

    say $matrix.Range: 1..4

To get single endpoints you could write:

    say $matrix.Range.min: 1
    say $matrix.list.max:  4

### [gist](#type-conversion-and-output-formats)

Limited tabular view, optimized for shell output. Just cuts off excessive columns that do not fit into standard terminal and also stops after 20 rows. If you call it explicitly, you can add width and height (char count) as optional arguments. Might even not show all decimals. Several dots will hint that something is missing. It is implicitly called by say. For a full view use [Str](#str).

    say $matrix;      # output when matrix has more than 100 cells

    1 2 3 4 5 ..
    3 4 5 6 7 ..
    ...

    say $matrix.gist(max-chars => 100, max-rows => 5 );

max-chars is the maximum amount of characters in any row of output (default is 80). max-rows is the maximum amount of rows gist will put out (default is 20). After gist ist called once (with or without arguments) the output will be cached. So next time you call:

    say $matrix       # 100 x 5 is still the max

You change the cache by calling gist with arguments again.

### [perl](#type-conversion-and-output-formats)

Conversion into String that can reevaluated into the same object later using default constructor.

    my $clone = eval $matrix.perl;       # same as: $matrix.clone

[Boolean Properties](#methods)
------------------------------

These are mathematical properties a matrix can have or not.

### [is-square](#boolean-properties)

True if number of rows and colums are the same.

### [is-zero](#boolean-properties)

True if every cell (element) has value of 0 (as created by new-zero).

### [is-identity](#boolean-properties)

True if every cell on the diagonal (where row index equals column index) is 1 and any other cell is 0.

    Example:    1 0 0
                0 1 0
                0 0 1

### [is-upper-triangular](#boolean-properties)

True if every cell below the diagonal (where row index is greater than column index) is 0.

    Example:    1 2 5
                0 3 8
                0 0 7

### [is-lower-triangular](#boolean-properties)

True if every cell above the diagonal (where row index is smaller than column index) is 0.

    Example:    1 0 0
                2 3 0
                5 8 7

### [is-diagonal](#boolean-properties)

True if only cells on the diagonal differ from 0. .is-upper-triangular and .is-lower-triangular would also be True.

    Example:    1 0 0
                0 3 0
                0 0 7

### [is-diagonally-dominant](#boolean-properties)

True if cells on the diagonal have a bigger (strict) or equal absolute value than the sum of the other absolute values in the column or row.

    if $matrix.is-diagonally-dominant {
    $matrix.is-diagonally-dominant(:!strict)   # same thing (default)
    $matrix.is-diagonally-dominant(:strict)    # diagonal elements (DE) are stricly greater (>)
    $matrix.is-diagonally-dominant(:!strict, :along<column>) # default
    $matrix.is-diagonally-dominant(:strict,  :along<row>)    # DE > sum of rest row
    $matrix.is-diagonally-dominant(:!strict, :along<both>)   # DE >= sum of rest row and rest column

### [is-symmetric](#boolean-properties)

True if every cell with coordinates x y has same value as the cell on y x. In other words: $matrix and $matrix.transposed (alias T) are the same.

    Example:    1 2 3
                2 5 4
                3 4 7

### [is-antisymmetric](#boolean-properties)

Means the transposed and negated matrix are the same.

    Example:    0  2  3
               -2  0  4
               -3 -4  0

### [is-self-adjoint](#boolean-properties)

A Hermitian or self-adjoint matrix is equal to its [transposed](#transposed) and complex [conjugated](#conjugated).

    Example:    1   2   3+i
                2   5   4
                3-i 4   7

### [is-invertible](#boolean-properties)

Also called nonsingular or nondegenerate. Is True if number of rows and colums are the same ([is-square](#is-square)) and [determinant](#determinant) is not zero. All rows or colums have to be independent vectors. Please use this method before $matrix.inverted, or you will get an exception.

### [is-orthogonal](#boolean-properties)

An orthogonal matrix multiplied ([dot-product](#dot-product)) with its transposed derivative (T) is an identity matrix or in other words: [transposed](#transposed) and [inverted](#inverted) matrices are equal.

### [is-unitary](#boolean-properties)

An unitery matrix multiplied ([dot-product](#dot-product)) with its concjugate transposed derivative (.conj.T) is an identity matrix, or said differently: the concjugate transposed matrix equals the inverted matrix.

### [is-positive-definite](#boolean-properties)

True if all main minors or all Eigenvalues are strictly greater zero.

### [is-positive-semidefinite](#boolean-properties)

True if all main minors or all Eigenvalues are greater equal zero.

[Numeric Properties](#methods)
------------------------------

Matrix properties that are expressed with a single number.

### [size](#numeric-properties)

List of two values: number of rows and number of columns.

    say $matrix.size();
    my $dim = min $matrix.size;

### [density](#numeric-properties)

Density is the percentage of cell which are not zero.

    my $d = $matrix.density;

### [trace](#numeric-properties)

The trace of a square matrix is the sum of the cells on the main diagonal. In other words: sum of cells which row and column value is identical.

    my $tr = $matrix.trace;

### [determinant](#numeric-properties)

If you see the columns as vectors, that describe the edges of a solid, the determinant of a square matrix tells you the volume of that solid. So if the solid is just in one dimension flat, the determinant is zero too.

    my $det = $matrix.determinant;
    my $d = $matrix.det;                # same thing
    my $d = ❘ $matrix ❘;                # unicode operator shortcut

### [rank](#numeric-properties)

Rank is the number of independent row or column vectors or also called independent dimensions (thats why this command is sometimes calles dim)

    my $r = $matrix.rank;

### [nullity](#numeric-properties)

Nullity of a matrix is the number of dependent rows or columns (rank + nullity = dim). Or number of dimensions of the kernel (vector space mapped by the matrix into zero).

    my $n = $matrix.nullity;

### [norm](#numeric-properties)

A norm is a single positive number, which is an abstraction to the concept of size. Most common form for matrices is the p-norm, where in step 1 the absolute value of every cell is taken to the power of p. The sum of these results is taken to the power of 1/p. The p-q-Norm extents this process. In his step 2 every column-sum is taken to the power of (p/q). In step 3 the sum of these are taken to the power of (1/q).

    my $norm = $matrix.norm( );           # euclidian norm aka L2 (p = 2, q = 2)
    my $norm = + $matrix;                 # context op shortcut
    my $norm = ‖ $matrix ‖;               # unicode op shortcut
    my $norm = $matrix.norm(1);           # p-norm aka L1 = sum of all cells absolute values (p = 1, q = 1)
    my $norm = $matrix.norm(p:<4>,q:<3>); # p,q - norm, p = 4, q = 3
    my $norm = $matrix.norm(p:<2>,q:<2>); # L2 aka Euclidean aka Frobenius norm
    my $norm = $matrix.norm('euclidean'); # same thing, more expressive to some
    my $norm = $matrix.norm('frobenius'); # same thing, more expressive to some
    my $norm = $matrix.norm('max');       # maximum norm - biggest absolute value of a cell
    $matrix.norm('row-sum');              # row sum norm - biggest abs. value-sum of a row
    $matrix.norm('column-sum');           # column sum norm - same column wise

### [condition](#numeric-properties)

Condition number of a matrix is L2 norm * L2 of inverted matrix.

    my $c = $matrix.condition( );

### [minor](#numeric-properties)

Arguments are row and column of an existing cell. A Minor is the determinant of a submatrix (2 argument variant).

    my $m = $matrix.minor(1,2);

### [narrowest-cell-type](#numeric-properties)

### [widest-cell-type](#numeric-properties)

Matrix cells can be (from most narrow to widest), of type (Bool), (Int), (Num), (Rat), (FatRat) or (Complex). The widest type of any cell will returned as type object.

In the next example the smartmatch returns true, because no cell of our default example matrix has wider type than (Int). After such a test all cells can be safely treated as Int or Bool.

    if $matrix.widest-cell-type ~~ Int { ...

You can also check if all cells have the same type:

    if $matrix.widest-cell-type eqv $matrix.narrowest-cell-type

[Derived Matrices](#methods)
----------------------------

Single matrices that can be computed with only our original matrix as input.

### [transposed](#derived-matrices)

Returns a new, transposed Matrix, where rows became colums and vice versa.

    Math::Matrix.new([[1,2,3],[3,4,6]]).transposed :

    [[1 2 3]     = [[1 4]
     [4 5 6]].T     [2 5]
                    [3 6]]

### [negated](#derived-matrices)

Creates a matrix where every cell has the negated value of the original (invertion of sign).

    my $new = $matrix.negated();     # invert sign of all cells
    my $neg = - $matrix;             # operator alias

    say $neg:  -1 -2
               -3 -4

### [conjugated](#derived-matrices)

Creates a matrix where every cell has the complex conjugated of the original.

    my $c = $matrix.conjugated();    # change every value to its complex conjugated
    my $c = $matrix.conj();          # short alias (official Perl 6 name)

    say Math::Matrix.new([[1+i,2],[3,4-i]]).conj :

    1-1i  2   
    3     4+1i

### [adjugated](#derived-matrices)

Creates a matrix out of the properly signed [minors](#minor) of the original. It is called adjugate, classical adjoint or sometimes adjunct.

    $matrix.adjugated.say :

     4 -3
    -2  1

### [inverted](#derived-matrices)

Matrices that have a square form and a full rank can be inverted (see [is-invertible](#is-invertible)). Inverse matrix regarding to matrix multiplication (see [dot-product](#dot-product)). The dot product of a matrix with its inverted results in a [identity](#is-identity) matrix (neutral element in this group).

    my $i = $matrix.inverted();      # invert matrix
    my $i = $matrix ** -1;           # operator alias

    say $i:

     -2    1
    1.5 -0.5

### [reduced-row-echelon-form](#derived-matrices)

Return the reduced row echelon form of a matrix, a.k.a. row canonical form

    my $rref = $matrix.reduced-row-echelon-form();
    my $rref = $matrix.rref();       # short alias

[Decompositions](#methods)
--------------------------

Methods that return lists of matrices, which in their product or otherwise can be recombined to the original matrix. In case of cholesky only one matrix is returned, becasue the other one is its transposed.

### [decompositionLU](#decompositions)

    my ($L, $U, $P) = $matrix.decompositionLU( );
    $L dot $U eq $matrix dot $P;         # True
    my ($L, $U) = $matrix.decompositionLUC(:!pivot);
    $L dot $U eq $matrix;                # True

$L is a left triangular matrix and $R is a right one Without pivotisation the marix has to be invertible (square and full ranked). In case you whant two unipotent triangular matrices and a diagonal (D): use the :diagonal option, which can be freely combined with :pivot.

    my ($L, $D, $U, $P) = $matrix.decompositionLU( :diagonal );
    $L dot $D dot $U eq $matrix dot $P;  # True

### [decompositionLUCrout](#decompositions)

    my ($L, $U) = $matrix.decompositionLUCrout( );
    $L dot $U eq $matrix;                # True

$L is a left triangular matrix and $R is a right one This decomposition works only on invertible matrices (square and full ranked).

### [decompositionCholesky](#decompositions)

This decomposition works only on symmetric and definite positive matrices.

    my $D = $matrix.decompositionCholesky( );  # $D is a left triangular matrix
    $D dot $D.T eq $matrix;                    # True

[Matrix Math Operations](#methods)
----------------------------------

Matrix math methods on full matrices and also parts (for gaussian table operations).

### [equal](#matrix-math-operations)

Checks two matrices for equality. They have to be of same size and every element of the first matrix on a particular position has to be equal to the element (on the same position) of the second matrix.

    if $matrixa.equal( $matrixb ) {
    if $matrixa == $matrixb {
    if $matrixa ~~ $matrixb {

### [add](#matrix-math-operations)

    Example:    1 2  +  5    =  6 7 
                3 4             8 9

                1 2  +  2 3  =  3 5
                3 4     4 5     7 9

    my $sum = $matrix.add( $matrix2 );  # cell wise addition of 2 same sized matrices
    my $s = $matrix + $matrix2;         # works too

    my $sum = $matrix.add( $number );   # adds number from every cell 
    my $s = $matrix + $number;          # works too

### [add-row](#matrix-math-operations)

Add a vector (row or col of some matrix) to a row of the matrix. In this example we add (2,3) to the second row. Instead of a matrix you can also give as parameter the raw data of a matrix as new would receive it.

    Math::Matrix.new([[1,2],[3,4]]).add-row(1,[2,3]);

    Example:    1 2  +       =  1 2
                3 4    2 3      5 7

### [add-column](#matrix-math-operations)

    Math::Matrix.new([[1,2],[3,4]]).add-column(1,[2,3]);

    Example:    1 2  +   2   =  1 4
                3 4      3      3 7

### [subtract](#matrix-math-operations)

Works analogous to add - it's just for convenance.

    my $diff = $matrix.subtract( $number );   # subtracts number from every cell (scalar subtraction)
    my $sd = $matrix - $number;               # works too
    my $sd = $number - $matrix ;              # works too

    my $diff = $matrix.subtract( $matrix2 );  # cell wise subraction of 2 same sized matrices
    my $d = $matrix - $matrix2;               # works too

### [multiply](#matrix-math-operations)

In scalar multiplication each cell of the matrix gets multiplied with the same number (scalar). In addition to that, this method can multiply two same sized matrices, by multipling the cells with the came coordinates from each operand.

    Example:    1 2  *  5    =   5 10 
                3 4             15 20

                1 2  *  2 3  =   2  6
                3 4     4 5     12 20

    my $product = $matrix.multiply( $number );   # multiply every cell with number
    my $p = $matrix * $number;                   # works too

    my $product = $matrix.multiply( $matrix2 );  # cell wise multiplication of same size matrices
    my $p = $matrix * $matrix2;                  # works too

### [multiply-row](#matrix-math-operations)

Multiply scalar number to each cell of a row.

    Math::Matrix.new([[1,2],[3,4]]).multiply-row(0,2);

    Example:    1 2  * 2     =  2 4
                3 4             3 4

### [multiply-column](#matrix-math-operations)

Multiply scalar number to each cell of a column.

    Math::Matrix.new([[1,2],[3,4]]).multiply-row(0,2);

    Example:    1 2   =  2 2
                3 4      6 4
            
               *2

### [dot-product](#matrix-math-operations)

Matrix multiplication of two fitting matrices (colums left == rows right).

    Math::Matrix.new( [[1,2],[3,4]] ).dot-product(  Math::Matrix.new([[2,3],[4,5]]) );

    Example:    2  3
           *    4  5

         1 2   10 13  =  1*2+2*4  1*3+2*5
         3 4   22 29     3*2+4*4  3*3+4*5

    my $product = $matrix1.dot-product( $matrix2 )
    my $c = $a dot $b;              # works too as operator alias
    my $c = $a ⋅ $b;                # unicode operator alias

    A shortcut for multiplication is the power - operator **
    my $c = $a **  3;               # same as $a dot $a dot $a
    my $c = $a ** -3;               # same as ($a dot $a dot $a).inverted
    my $c = $a **  0;               # created an right sized identity matrix

### [tensor-product](#matrix-math-operations)

The tensor product (a.k.a Kronecker product) between a matrix a of size (m,n) and a matrix b of size (p,q) is a matrix c of size (m*p,n*q). All matrices you get by multiplying an element (cell) of matrix a with matrix b (as in $a.multiply($b.cell(..,..)) concatinated result in matrix c. (Or replace in a each cell with its product with b.)

    Example:    1 2  *  2 3   =  1*[2 3] 2*[2 3]  =  2  3  4  6
                3 4     4 5        [4 5]   [4 5]     4  5  8 10
                                 3*[2 3] 4*[2 3]     6  9  8 12
                                   [4 5]   [4 5]     8 15 16 20

    my $c = $matrixa.tensor-product( $matrixb );
    my $c = $a X* $b;               # works too as operator alias
    my $c = $a ⊗ $b;                # unicode operator alias

[List Like Matrix Operations](#methods)
---------------------------------------

Selection of methods that are also provided by Lists and Arrays and make also sense in context a 2D matrix. 

### [elems](#list-like-matrix-operations)

Number (count) of elements = rows * columns.

    say $matrix.elems();

### [elem](#list-like-matrix-operations)

Asks if all cell values are part an element of the set/range provided.

    Math::Matrix.new([[1,2],[3,4]]).elem(1..4) :   True
    Math::Matrix.new([[1,2],[3,4]]).elem(2..5) :   False

### [cont](#list-like-matrix-operations)

Asks if the matrix contains a value equal to the only argument of the method. If a range is provided as argument, at least one cell value has to be within this range to make the result true.

    Math::Matrix.new([[1,2],[3,4]]).cont(1)   : True
    Math::Matrix.new([[1,2],[3,4]]).cont(5)   : False
    Math::Matrix.new([[1,2],[3,4]]).cont(3..7): True

    MM [[1,2],[3,4]] (cont) 1                 # True too

### [map-index](#list-like-matrix-operations)

Runs a code block (only required argument) for every cell of the matrix. Arguments to the anonymous block are current row and column index. The results for a new matrix.

    say Math::Matrix.new([[1,2],[3,4]]).map-index: {$^m == $^n ?? 1 !! 0 } :

    1 0
    0 1

### [map-with-index](#list-like-matrix-operations)

Runs a code block (only required argument) for every cell of the matrix. Arguments to the anonymous block are current row and column index and the content of the cell. The results for a new matrix.

    say Math::Matrix.new([[1,2],[3,4]]).map-with-index: {$^m == $^n ?? $^value !! 0 } :

    1 0
    0 4

### [map](#list-like-matrix-operations)

Like the built in map it iterates over all elements (cell values), running a code block (only required argument) that gets the cell value as argument. The results build a new matrix.

    say Math::Matrix.new([[1,2],[3,4]]).map(* + 1) :

    2 3
    4 5

### [map-row](#list-like-matrix-operations)

Map only specified row (row number is first parameter).

    say Math::Matrix.new([[1,2],[3,4]]).map-row(1, {$_ + 1}) :

    1 2
    4 5

### [map-column](#list-like-matrix-operations)

    say Math::Matrix.new([[1,2],[3,4]]).map-column(1, {0}) :

    1 0
    3 0

### [reduce](#list-like-matrix-operations)

Like the built in reduce method, it iterates over all elements and joins them into one value, by applying the given operator or method to the previous result and the next element. I starts with the cell [0][0] and moving from left to right in the first row and continue with the first cell of the next row.

    Math::Matrix.new([[1,2],[3,4]]).reduce(&[+]): 10
    Math::Matrix.new([[1,2],[3,4]]).reduce(&[*]): 10

### [reduce-rows](#list-like-matrix-operations)

Reduces (as described above) every row into one value, so the overall result will be a list. In this example we calculate the sum of all cells in a row:

    say Math::Matrix.new([[1,2],[3,4]]).reduce-rows(&[+]): (3, 7)

### [reduce-columns](#list-like-matrix-operations)

Similar to reduce-rows, this method reduces each column to one value in the resulting list:

    say Math::Matrix.new([[1,2],[3,4]]).reduce-columns(&[*]): (3, 8)

[Structural Matrix Operations](#methods)
----------------------------------------

Methods that reorder the rows and columns, delete some or even add new. The accessor .submatrix is also useful for that purpose.

### [move-row](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-row(0,1);  # move row 0 to 1
    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-row(0=>1); # same

    1 2 3           4 5 6
    4 5 6    ==>    1 2 3
    7 8 9           7 8 9

### [move-column](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-column(2,1);
    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).move-column(2=>1); # same

    1 2 3           1 3 2
    4 5 6    ==>    4 6 5
    7 8 9           7 9 8

### [swap-rows](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).swap-rows(2,0);

    1 2 3           7 8 9
    4 5 6    ==>    4 5 6
    7 8 9           1 2 3

### [swap-columns](#structural-matrix-operations)

    Math::Matrix.new([[1,2,3],[4,5,6],[7,8,9]]).swap-columns(0,2);

    1 2 3           3 2 1
    4 5 6    ==>    6 5 4
    7 8 9           9 8 7

### [splice-rows](#structural-matrix-operations)

Like the splice for lists: the first two parameter are position and amount (optional) of rows to be deleted. The third and alos optional parameter will be an array of arrays (line .new would accept), that fitting row lengths. These rows will be inserted before the row with the number of first parameter. The third parameter can also be a fitting Math::Matrix.

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(0,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka prepend
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(0,0,                  [[5,6],[7,8]]  ); # same result

    5 6
    7 8 
    1 2
    3 4

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka insert
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,0,                  [[5,6],[7,8]]  ); # same result

    1 2
    5 6
    7 8
    3 4

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,1, Math::Matrix.new([[5,6],[7,8]]) ); # aka replace
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(1,1,                  [[5,6],[7,8]]  ); # same result

    1 2
    5 6 
    7 8

    Math::Matrix.new([[1,2],[3,4]]).splice-rows(2,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka append
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(2,0,                  [[5,6],[7,8]]  ); # same result
    Math::Matrix.new([[1,2],[3,4]]).splice-rows(-1,0,                 [[5,6],[7,8]]  ); # with negative index

    1 2 
    3 4     
    5 6
    7 8

### [splice-columns](#structural-matrix-operations)

Same as splice-rows, just horizontally.

    Math::Matrix.new([[1,2],[3,4]]).splice-columns(2,0, Math::Matrix.new([[5,6],[7,8]]) ); # aka append
    Math::Matrix.new([[1,2],[3,4]]).splice-columns(2,0,                  [[5,6],[7,8]]  ); # same result
    Math::Matrix.new([[1,2],[3,4]]).splice-columns(-1,0,                 [[5,6],[7,8]]  ); # with negative index

    1 2  ~  5 6  =  1 2 5 6
    3 4     7 8     3 4 7 8

[Shortcuts](#methods)
---------------------

Summary of all shortcut aliases (first) and their long form (second). 

  * T --> [transposed](#transposed)

  * conj --> [conjugated](#conjugated)

  * det --> [determinant](#determinant)

  * rref --> [reduced-row-echelon-form](#reduced-row-echelon-form)

[Operator Methods](#methods)
----------------------------

Operators with method aliases, for more explanations loo into [ops chapter](#operators):

  * prefix ? --> [Bool](#bool)

  * prefix + --> [Numeric](#numeric)

  * prefix - --> [negated](#negated)

  * prefix ~ --> [Str](#str)

  * prefix | --> [list](#list)

  * prefix @ --> [Array](#array)

  * prefix % --> [Hash](#hash)

  * prefix MM --> [new](#new--)

  * infix == --> [equal](#equal)

  * infix ~~ --> [equal](#equal) ACCEPTS

  * infix + --> [add](#add)

  * infix - --> [subtract](#subtract)

  * infix * --> [multiply](#multiply)

  * infix ⋅ dot --> [dot-product](#dot-product)

  * infix ÷ --> dot-product [inverted](#inverted)

  * infix ** --> dot-product inverted

  * infix ⊗ X* --> [tensor-product](#tensor-product)

  * circumfix ｜..｜ --> [determinant](#determinant)

  * circumfix ‖..‖ --> [norm](#norm)

  * postcircumfix [..] --> [AT-POS](#at-pos)

[Export Tags](#synopsis)
========================

  * :MANDATORY (nothing is exported)

  * :DEFAULT (same as no tag, most [ops](#operators) will be exported)

  * :MM (only [MM](#new--) op exported)

  * :ALL

[Operators](#synopsis)
======================

The Module overloads or introduces a range of well and lesser known ops. ==, +, * are commutative, -, ⋅, dot, ÷, x, ⊗ and ** are not.

They are exported when using no flag or under the export flags :DEFAULT or :ALL, but not under :MANDATORY or :MM). The only exception is MM-operator, a shortcut to create a matrix. That has to be importet explicitly with the tag :MM or :ALL. The postcircumfix [] - op will always work.

    my $a   = +$matrix               # Num context, Euclidean norm
    my $b   = ?$matrix               # Bool context, True if any cell has a none zero value
    my $str = ~$matrix               # String context, matrix content, space and new line separated as table
    my $l   = |$matrix               # list context, list of all cells, row-wise
    my $a   = @ $matrix              # same thing, but as Array
    my $h   = % $matrix              # hash context, similar to .kv, so that %$matrix{0}{0} is first cell

    $matrixa == $matrixb             # check if both have same size and they are cell wise equal
    $matrixa ~~ $matrixb             # same thing

    my $sum =  $matrixa + $matrixb;  # cell wise sum of two same sized matrices
    my $sum =  $matrix  + $number;   # add number to every cell

    my $dif =  $matrixa - $matrixb;  # cell wise difference of two same sized matrices
    my $dif =  $matrix  - $number;   # subtract number from every cell
    my $neg = -$matrix               # negate value of every cell

    my $p   =  $matrixa * $matrixb;  # cell wise product of two same sized matrices
    my $sp  =  $matrix  * $number;   # multiply number to every cell

    my $dp  =  $a dot $b;            # dot product of two fitting matrices (cols a = rows b)
    my $dp  =  $a ⋅ $b;              # dot product, unicode (U+022C5)
    my $dp  =  $a ÷ $b;              # alias to $a dot $b.inverted, (U+000F7) 

    my $c   =  $a **  3;             # $a to the power of 3, same as $a dot $a dot $a
    my $c   =  $a ** -3;             # alias to ($a dot $a dot $a).inverted
    my $c   =  $a **  0;             # creats an right sized identity matrix

    my $tp  =  $a X* $b;             # tensor product 
    my $tp  =  $a ⊗ $b;              # tensor product, unicode (U+02297)

     ｜ $matrix ｜                     # determinant, unicode (U+0FF5C)
     ‖ $matrix ‖                     # L2 norm (euclidean p=2 to the square), (U+02016)

       $matrix[1][2]                 # cell in second row and third column, works even when used :MANDATORY tag

    MM [[1]]                         # a new matrix
    MM '1'                           # string alias

[Authors](#synopsis)
====================

  * Pierre VIGIER

  * Herbert Breunung

[Contributors](#synopsis)
=========================

  * Patrick Spek

[License](#synopsis)
====================

Artistic License 2.0
