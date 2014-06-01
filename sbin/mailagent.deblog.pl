#!/usr/bin/perl 
#                              -*- Mode: Perl -*- 
# mailagent.log.pl --- 
# Author           : Manoj Srivastava ( srivasta@graceland ) 
# Created On       : Tue Dec 14 19:47:25 1993
# Created On Node  : graceland
# Last Modified By : Manoj Srivastava
# Last Modified On : Tue May 27 15:57:55 1997
# Last Machine Used: tiamat.datasync.com
# Update Count     : 21
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

@Month_Name =
    ( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
         'Nov', 'Dec', );

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
 $year +=1900;

$message = "\nFrom: $from $friendly\nSender: $header{Sender}\n" .
    "To: $header{To}\nSubject: $subject\n";

&usrlog'new ('DEBBUGS', "bugClosed.$year.$Month_Name[$mon]", 0); #';
&main'usr_log(  #';
    'DEBBUGS',
    "$message"
    ); 
				

&delete;
