use v6;
use Test;
use Test::Redis;
use Redis::Async;

plan 8;

my $port = 16379;

my $redis will leave { .finish } = Test::Redis.new(:$port);
$redis.start;

my $r = Redis::Async.new("localhost:$port");

my @list := $r.list('mylist');

ok @list, 'Make a list';

ok @list.push(1,2,3), 'Push items onto list';

is @list[*], [1, 2, 3], 'Correct list';

is @list.pop, 3, 'Pop';

ok @list.unshift(7), 'Unshift';

is @list[*], [7, 1, 2], 'Correct';

is @list.shift, 7, 'Shift';

is @list[*], [1, 2], 'Correct';

done-testing;
