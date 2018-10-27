use v6;
use Test;
use python::itertools;

plan 21;

is count(10)[^5], (10,11,12,13,14);
is count(10, 2)[^5], (10,12,14,16,18);

dies-ok  { repeats("3",-1)[^5]; };
is repeats("3",0)[^5], [3,3,3,3,3];  
is repeats("3",3), [3,3,3];  

dies-ok  { cycle([]); };
is cycle(['a','b','c','d'])[^6], ['a','b','c','d','a','b'];

is compress(['a','b','c','d'], [True,False,True,False]), ['a','c'];
is compress(['a','b','c','d'], [1,1,0,1])[^3], ['a','b','d'];

is chain((1,2,3,4),("a","b","c"),("1",2)), (1,2,3,4,"a","b","c","1",2);

is groupby(['a','b','a','a','a','b','b','c','a']), (('a','a','a','a','a'),('b','b','b'),('c'));

is accumulate([1,2,3,4,5]),  [1, 3, 6, 10, 15];

is dropwhile([1,4,6,4,1], {$_ < 5;}), [6,4,1];
is takewhile([1,4,6,4,1], {$_ < 5;}), [1,4];

is product([0,1], :repeat(3)), ((0,0,0), (0,0,1), (0,1,0), (0,1,1), (1,0,0), (1,0,1), (1,1,0), (1,1,1));
is product([0,1], [0,1]), ((0,0), (0,1), (1,0), (1,1));
is product([0,1], [0,1], :repeat(2)), ((0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 1, 0), (0, 1, 1, 1), (1, 0, 0, 0), (1, 0, 0, 1), (1, 0, 1, 0), (1, 0, 1, 1), (1, 1, 0, 0), (1, 1, 0, 1), (1, 1, 1, 0), (1, 1, 1, 1));

is starmap(&sum, ((1,2,3), (4,5,6))), (6, 15);

is tee(1..5 ,3), (1..5, 1..5, 1..5);

is zip_longest((1,2,3,4),(1,2), (-1,-2,-3), :fillvalue("0")), ((1,1,-1), (2,2,-2), (3,"0",-3), (4, "0","0"));

is combinations_with_replacement(('a','b','c'), 2), (('a','a'), ('a','b'), ('a','c'), ('b','a'), ('b','b'), ('b','c'), ('c','a'), ('c','b'), ('c','c'));

done-testing;