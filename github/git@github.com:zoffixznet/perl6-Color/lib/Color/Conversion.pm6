unit module Color::Conversion;

use Color::Utilities;

##############################################################################
# Conversion formulas
# The math was taken from http://www.rapidtables.com/
##############################################################################


sub rgb2hsv ( $r is copy, $g is copy, $b is copy ) is export {
    my ( $h, $Δ, $c_max ) = calc-hue( $r, $g, $b );

    my $s = $c_max == 0 ?? 0 !! $Δ / $c_max;
    my $v = $c_max;

    return ($h, $s*100, $v*100);
}

sub rgb2hsl ( $r is copy, $g is copy, $b is copy ) is export {
    my ( $h, $Δ, $c_max, $c_min ) = calc-hue( $r, $g, $b );
    my $l = ($c_max + $c_min) / 2;
    my $s = $Δ == 0 ?? 0 !! $Δ / (1 - abs(2*$l - 1));
    return ($h, $s*100, $l*100);
}

sub rgb2cmyk ( $r is copy, $g is copy, $b is copy ) is export  {
    $_ /= 255 for $r, $g, $b;

    # Formula cortesy http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    my $k = 1 - max $r, $g, $b;
    my $c = (1 - $r - $k) / (1 - $k);
    my $m = (1 - $g - $k) / (1 - $k);
    my $y = (1 - $b - $k) / (1 - $k);
    return ($c, $m, $y, $k);
}

sub cmyk2rgb ( @ ($c is copy, $m is copy, $y is copy, $k is copy) ) is export  {
    clip-to 0, $_, 1 for $c, $m, $y, $k;
    my $r = 255 * (1-$c) * (1-$k);
    my $g = 255 * (1-$m) * (1-$k);
    my $b = 255 * (1-$y) * (1-$k);
    return %(:$r, :$g, :$b);
}

sub hsl2rgb ( @ ($h is copy, $s is copy, $l is copy) ) is export {
    $s /= 100;
    $l /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $l, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsl-to-rgb.htm
    my $c = (1 - abs(2*$l - 1)) * $s;
    my $x = $c * (
        1 - abs( (($h/60) % 2) - 1 )
    );
    my $m = $l - $c/2;
    return rgb-from-c-x-m( $h, $c, $x, $m );
}

sub hsv2rgb ( @ ($h is copy, $s is copy, $v is copy) )  is export {
    $s /= 100;
    $v /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $v, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h/60) % 2) - 1 ) );
    my $m = $v - $c;
    return rgb-from-c-x-m( $h, $c, $x, $m );
}

sub rgb-from-c-x-m ($h, $c, $x, $m) is export {
    my ($r, $g, $b);
    given $h {
        when   0..^60  { ($r, $g, $b) = ($c, $x, 0) }
        when  60..^120 { ($r, $g, $b) = ($x, $c, 0) }
        when 120..^180 { ($r, $g, $b) = (0, $c, $x) }
        when 180..^240 { ($r, $g, $b) = (0, $x, $c) }
        when 240..^300 { ($r, $g, $b) = ($x, 0, $c) }
        when 300..^360 { ($r, $g, $b) = ($c, 0, $x) }
    }
    ( $r, $g, $b ) = map { ($_+$m) * 255 }, $r, $g, $b;
    return %(r => $r.Real, g => $g.Real, b => $b.Real);
}