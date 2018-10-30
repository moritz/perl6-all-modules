use v6;
use DateTime::TimeZone::Zone;
unit class DateTime::TimeZone::Zone::Australia::Sydney does DateTime::TimeZone::Zone;
has %.rules = ( 
 AN => [{:adjust("1:00"), :lastdow(7), :letter("-"), :month(10), :time("2:00s"), :years(1971..1985)}, {:adjust("0"), :date("27"), :letter("-"), :month(2), :time("2:00s"), :years(1972..1972)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(3), :time("2:00s"), :years(1973..1981)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(4), :time("2:00s"), :years(1982..1982)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(3), :time("2:00s"), :years(1983..1985)}, {:adjust("0"), :dow({:dow(7), :mindate("15")}), :letter("-"), :month(3), :time("2:00s"), :years(1986..1989)}, {:adjust("1:00"), :date("19"), :letter("-"), :month(10), :time("2:00s"), :years(1986..1986)}, {:adjust("1:00"), :lastdow(7), :letter("-"), :month(10), :time("2:00s"), :years(1987..1999)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(3), :time("2:00s"), :years(1990..1995)}, {:adjust("0"), :lastdow(7), :letter("-"), :month(3), :time("2:00s"), :years(1996..2005)}, {:adjust("1:00"), :lastdow(7), :letter("-"), :month(8), :time("2:00s"), :years(2000..2000)}, {:adjust("1:00"), :lastdow(7), :letter("-"), :month(10), :time("2:00s"), :years(2001..2007)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(4), :time("2:00s"), :years(2006..2006)}, {:adjust("0"), :lastdow(7), :letter("-"), :month(3), :time("2:00s"), :years(2007..2007)}, {:adjust("0"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(4), :time("2:00s"), :years(2008..Inf)}, {:adjust("1:00"), :dow({:dow(7), :mindate("1")}), :letter("-"), :month(10), :time("2:00s"), :years(2008..Inf)}],
 Aus => [{:adjust("1:00"), :date("1"), :letter("-"), :month(1), :time("0:01"), :years(1917..1917)}, {:adjust("0"), :date("25"), :letter("-"), :month(3), :time("2:00"), :years(1917..1917)}, {:adjust("1:00"), :date("1"), :letter("-"), :month(1), :time("2:00"), :years(1942..1942)}, {:adjust("0"), :date("29"), :letter("-"), :month(3), :time("2:00"), :years(1942..1942)}, {:adjust("1:00"), :date("27"), :letter("-"), :month(9), :time("2:00"), :years(1942..1942)}, {:adjust("0"), :lastdow(7), :letter("-"), :month(3), :time("2:00"), :years(1943..1944)}, {:adjust("1:00"), :date("3"), :letter("-"), :month(10), :time("2:00"), :years(1943..1943)}],
);
has @.zonedata = [{:baseoffset("10:04:52"), :rules(""), :until(-2366755200)}, {:baseoffset("10:00"), :rules("Aus"), :until(31536000)}, {:baseoffset("10:00"), :rules("AN"), :until(Inf)}]<>;