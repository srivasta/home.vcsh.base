#!/usr/bin/perl -w
#                              -*- Mode: Cperl -*- 
# color-calc.pl --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.internal.golden-gryphon.com ) 
# Created On       : Sat Apr 10 22:52:10 2004
# Created On Node  : glaurung.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Thu Apr 15 13:12:52 2004
# Last Machine Used: glaurung.internal.golden-gryphon.com
# Update Count     : 5
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

use 5.008;
use strict;
use warnings;

use Carp;

# The Hue Saturation Value (or HSV) model defines a color space in terms
# of three constituent components; hue, saturation, and value. HSV is
# used in color progression s.

#     Hue , the color type (such as red, blue, or yellow);
#       Measured in values of 0-360 by the central tendency of its
#       wavelength (also called tint, or family).

#     Saturation , the 'intensity' of the color (or how much greyness
#       is present),
#       Measured in values of 0-100% by the amplitude of the
#       wavelength (also called shade or purity)

#     Value , the brightness of the color.
#       Measured in values of 0-100% by the spread of the wavelength
#       (tone or intensity)

# HSV is a non-linear transformation of the RGB color space .

# The coordinate system is cylindrical, and the colors are defined
# inside a hexcone. The hue value H runs from 0 to 360degrees. The
# saturation S is the degree of strength or purity and is from 0 to
# 1. Purity is how much white is added to the color, so S=1 makes the
# purest color (no white).  Brightness V also ranges from 0 to 1, where
# 0 is the black.

sub RGBtoHSV ($$$) {
  my ($r, $g, $b) = @_;
  my ($h, $s, $v);

  my $min = $r < $g ? ($r < $b ? $r : $b) : ($g < $b ? $g : $b);
  my $max = $r > $g ? ($r > $b ? $r : $b) : ($g > $b ? $g : $b);
  my $delta = $max - $min;

  $v   = $max;
  if ($max) {
    $s = $delta / $max;
  }
  else {
    # s = 0, v is undefined
    $s = 0;
    $h = -1;
    return ($h, $s, $v);
  }
  if ($r == $max) {
    $h = ($g - $b) / $delta;	# between yellow & magenta
  }
  elsif ($g == $max) {
    $h = 2 + ($b - $r) / $delta; # between cyan & yellow
  }
  else {
    $h = 4 + ($r - $g) / $delta; # between magenta & cyan
  }
  $h *= 60;			# degrees
  if ($h < 0) {
    $h += 360;
  }
  return ($h, $s, $v);
}

sub HSVtoRGB ($$$) {
  my ($h, $s, $v) = @_;
  my ($r, $g, $b);
  if (! $s) {
    # achromatic (grey)
    $r = $g = $b = $v;
    return ($r, $g, $b);
  }


  $h /= 60;			# sector 0 to 5
  my $i = int($h);
  my $f = $h - $i;
  my $p = $v * (1 - $s);
  my $q = $v * (1 - $s * $f);
  my $t = $v * (1 - $s * (1 - $f));

  if (! $i) {
    $r = $v;
    $g = $t;
    $b = $p
  }
  elsif ($i == 1) {
    $r = $q;
    $g = $v;
    $b = $p;
  }
  elsif ($i == 2) {
    $r = $p;
    $g = $v;
    $b = $t;
  }
  elsif ($i == 3) {
    $r = $p;
    $g = $q;
    $b = $v;
  }
  elsif ($i == 4) {
    $r = $t;
    $g = $p;
    $b = $v;
  }
  else {
    $r = $v;
    $g = $p;
    $b = $q;
  }
  return ($r, $g, $b);
}

sub main {
  my ($red, $green, $blue) = map {hex $_}
    ( substr($ARGV[0],0,2), substr($ARGV[0],2,2), substr($ARGV[0],4,2) );
  my ($hue, $sat, $val) = RGBtoHSV($red, $green, $blue);
  print "Hue=$hue Saturation = $sat, Value = $val\n"
}


&main();

__END__

1;
