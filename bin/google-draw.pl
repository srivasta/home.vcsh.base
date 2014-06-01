#!/usr/bin/perl -w

# reads comma separated absolute x,y coords, one per line
# spits out url suitable for google maps line drawing.

# Copyright (c) 2005, Neil Kandalgaonkar <neilk(a)brevity.org> 
# Released under the BSD license 
# http://www.opensource.org/licenses/bsd-license.php

use strict;

use constant END_OF_STREAM => 9999;

# the first pair are absolute coords, where to put down the pen
# subsequent pairs are relative. 
# so, a file like:
#    10,20
#    30,10
#    5,5
#
# becomes @coord = (10,20,20,-10,-25,-5,9999)
# 9999 is the end of stream marker.

my ($max_x, $max_y);
$max_x = $max_y = 0;
my ($old_x, $old_y);
my @coord;

while (<>) {
    chomp;
    s/\s//g;
    my ($x, $y) = split ',';
    
    $max_x < $x and $max_x = $x; 
    $max_y < $y and $max_y = $y;
    
    my ($diff_x, $diff_y);
    
    if (defined $old_x) {
        $diff_x = $x - $old_x;
        $diff_y = $y - $old_y;
    } else {
        $diff_x = $x;
        $diff_y = $y;
    }

    $old_x = $x;
    $old_y = $y;

    push @coord, $diff_x, $diff_y;
}

my $width = $max_x + 10;
my $height = $max_y + 10;

push @coord, END_OF_STREAM;
    

my $path;

for my $c (@coord) {
     
    # coord can be positive or negative (as it is the diff of last point)
    #
    # coord  0  -1 1  -2 2  -3 3  ...
    # f      0  1  2  3  4  5  6  ...
    my $f = (abs($c) << 1) - ($c < 0);

    # now, break $f into groups of five bits. starting from lowest to highest.
    # each of those groups gets a char.
    do {
        # get the last five bits of f.
        my $e = $f & 31;
        
        # shift $f over 5 bits, for next time
        # AND, if there's anything left of $f, add a high bit to $e. this 
        # tells the decoder to keep going.
        ($f >>= 5) && ($e |= 32);

        # put it into ascii
        $path .= chr($e+63);

    } while ($f != 0);
   
}



print "http://www.google.com/maplinedraw?width=$width&height=$height&path=$path\n";


# sample url that does work
# http://www.google.com/maplinedraw?width=361&height=545&path=SSsBCDqB@sB@mB@}A?O@iB@mBByBB}B?yBkFCqFEoB?}oR


