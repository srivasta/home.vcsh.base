#!/usr/bin/perl 
#                              -*- Mode: Perl -*- 
# mailagent.decnet.pl --- 
# Author           : Manoj Srivastava ( srivasta@graceland ) 
# Created On       : Wed Dec 15 10:48:28 1993
# Created On Node  : graceland
# Last Modified By : Manoj Srivastava
# Last Modified On : Fri Dec 17 15:59:37 1993
# Last Machine Used: graceland
# Update Count     : 15
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

while (<>){
    chop;
    s/\w+:+IN.\"([^\"]+)\"\s*\(?([^\)]+)\)?\s*/"$2" <$1>/g;
    print "$_\n";
}
