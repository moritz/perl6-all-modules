use v6;
use DateTime::TimeZone::Zone;
unit class DateTime::TimeZone::Zone::Asia::Tehran does DateTime::TimeZone::Zone;
has %.rules = ( 
 Iran => [{:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(1978..1980)}, {:adjust("0"), :date("21"), :letter("S"), :month(10), :time("0:00"), :years(1978..1978)}, {:adjust("0"), :date("19"), :letter("S"), :month(9), :time("0:00"), :years(1979..1979)}, {:adjust("0"), :date("23"), :letter("S"), :month(9), :time("0:00"), :years(1980..1980)}, {:adjust("1:00"), :date("3"), :letter("D"), :month(5), :time("0:00"), :years(1991..1991)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(1992..1995)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(1991..1995)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(1996..1996)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(1996..1996)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(1997..1999)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(1997..1999)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2000..2000)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2000..2000)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2001..2003)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2001..2003)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2004..2004)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2004..2004)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2005..2005)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2005..2005)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2008..2008)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2008..2008)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2009..2011)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2009..2011)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2012..2012)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2012..2012)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2013..2015)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2013..2015)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2016..2016)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2016..2016)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2017..2019)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2017..2019)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2020..2020)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2020..2020)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2021..2023)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2021..2023)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2024..2024)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2024..2024)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2025..2027)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2025..2027)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2028..2029)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2028..2029)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2030..2031)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2030..2031)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2032..2033)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2032..2033)}, {:adjust("1:00"), :date("22"), :letter("D"), :month(3), :time("0:00"), :years(2034..2035)}, {:adjust("0"), :date("22"), :letter("S"), :month(9), :time("0:00"), :years(2034..2035)}, {:adjust("1:00"), :date("21"), :letter("D"), :month(3), :time("0:00"), :years(2036..2037)}, {:adjust("0"), :date("21"), :letter("S"), :month(9), :time("0:00"), :years(2036..2037)}],
);
has @.zonedata = [{:baseoffset("3:25:44"), :rules(""), :until(-1704153600)}, {:baseoffset("3:25:44"), :rules(""), :until(-757382400)}, {:baseoffset("3:30"), :rules(""), :until(220924800)}, {:baseoffset("4:00"), :rules("Iran"), :until(283996800)}, {:baseoffset("3:30"), :rules("Iran"), :until(Inf)}]<>;
