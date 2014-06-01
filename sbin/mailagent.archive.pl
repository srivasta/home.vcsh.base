#                              -*- Mode: Cperl -*- 
# mailagent.archive.pl --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
# Created On       : Sat Oct  4 12:36:30 2003
# Created On Node  : glaurung.green-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Sat Oct  4 14:09:13 2003
# Last Machine Used: glaurung.green-gryphon.com
# Update Count     : 13
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 
%Discard_lists = 
  (
   "debian-boot" => 1,
   "debian-bugs" => 1,
   "debian-bugs-rc" => 1,
   "debian-changes" => 1,
   "debian-curiosa" => 1,
   "debian-firewall" => 1,
   "lsb-test" => 1,
   "newsletters" => 1,
   "outgoing" => 1,
   "linux-kernel" => 1,
  );

my $archive_root = "/backup/mail";

if ($ARGV[1]) {
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year +=1900;
  $mon = sprintf("%02d", $mon + 1);

  if ($#ARGV >= 3) {
    $year = $ARGV[3];
  }

  if ($#ARGV >= 4) {
    $mon = $ARGV[4];
  }

  if ($ARGV[2] =~ /anzu/io) {
    if (!(defined $Discard_lists{$ARGV[1]})) {
      if (! -d "$archive_root/$ARGV[1]") {
	mkdir "$archive_root/$ARGV[1]"
      }
      &save("$archive_root/$ARGV[1]/${year}_$mon");
    }
  }
}

&reject;
