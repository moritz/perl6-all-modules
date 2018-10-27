use v6;
use DateTime::TimeZone::Zone;
unit class DateTime::TimeZone::Zone::Atlantic::Reykjavik does DateTime::TimeZone::Zone;
has %.rules = ( 
 Iceland => [{:adjust("1:00"), :date("19"), :letter("S"), :month(2), :time("23:00"), :years(1917..1918)}, {:adjust("0"), :date("21"), :letter("-"), :month(10), :time("1:00"), :years(1917..1917)}, {:adjust("0"), :date("16"), :letter("-"), :month(11), :time("1:00"), :years(1918..1918)}, {:adjust("1:00"), :date("29"), :letter("S"), :month(4), :time("23:00"), :years(1939..1939)}, {:adjust("0"), :date("29"), :letter("-"), :month(11), :time("2:00"), :years(1939..1939)}, {:adjust("1:00"), :date("25"), :letter("S"), :month(2), :time("2:00"), :years(1940..1940)}, {:adjust("0"), :date("3"), :letter("-"), :month(11), :time("2:00"), :years(1940..1940)}, {:adjust("1:00"), :date("2"), :letter("S"), :month(3), :time("1:00s"), :years(1941..1941)}, {:adjust("0"), :date("2"), :letter("-"), :month(11), :time("1:00s"), :years(1941..1941)}, {:adjust("1:00"), :date("8"), :letter("S"), :month(3), :time("1:00s"), :years(1942..1942)}, {:adjust("0"), :date("25"), :letter("-"), :month(10), :time("1:00s"), :years(1942..1942)}, {:adjust("1:00"), :dow({:dow(7), :mindate("1")}), :letter("S"), :month(3), :time("1:00s"), :years(1943..1946)}, {:adjust("0"), :dow({:dow(7), :mindate("22")}), :letter("-"), :month(10), :time("1:00s"), :years(1943..1948)}, {:adjust("1:00"), :dow({:dow(7), :mindate("1")}), :letter("S"), :month(4), :time("1:00s"), :years(1947..1967)}, {:adjust("0"), :date("30"), :letter("-"), :month(10), :time("1:00s"), :years(1949..1949)}, {:adjust("0"), :dow({:dow(7), :mindate("22")}), :letter("-"), :month(10), :time("1:00s"), :years(1950..1966)}, {:adjust("0"), :date("29"), :letter("-"), :month(10), :time("1:00s"), :years(1967..1967)}],
);
has @.zonedata = [{:baseoffset("-1:27:24"), :rules(""), :until(-4197052800)}, {:baseoffset("-1:27:48"), :rules(""), :until(-1956614400)}, {:baseoffset("-1:00"), :rules("Iceland"), :until(-54774000)}, {:baseoffset("0:00"), :rules(""), :until(Inf)}]<>;