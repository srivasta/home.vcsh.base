#                              -*- Mode: Perl -*- 
# distance.pl --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
# Created On       : Fri Oct  1 11:09:14 1999
# Created On Node  : glaurung.green-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Fri Oct  1 11:47:18 1999
# Last Machine Used: glaurung.green-gryphon.com
# Update Count     : 15
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 
#  perl -nl -e '/^\s*(\S+)\s+(\S+)\s+(\S+)\s+(.*)/ && printf "%
#  015.10f % 015.10f \"\" %s\n",  $1, $2, $4;' markers.dat >
#  developers.coords  
# perl -nl -e '/^\s*(\S+)\s+(\S+)\s+(\S+)\s+(.*)/ && printf "% 015.10f
# % 015.10f \"%d\" %s\n",  $1, $2, $., $4;' markers.dat >
# developers.coords 
#  xplanet --window --geometry 1200x600 --grid 6 --markers --sh 52
#  --marker_file developers.coords  

$default_latitude=30.75;
$default_longitude=-88.3047222222;

while (<>) {
  chomp;
  my ($lat, $lon, @comment) = split ' ';
  my $latdist  = $default_latitude - $lat;
  my $longdist = $default_longitude - $lon;
  
  my $dist = sqrt (($latdist * $latdist)  + ($longdist * $longdist));
  my $angle = atan2 ($latdist, $longdist) / 3.14159265358979 * 360;
  
  printf "%8.4f  %7.1f  %s\n", $dist, $angle, join ' ', @comment; 
}
