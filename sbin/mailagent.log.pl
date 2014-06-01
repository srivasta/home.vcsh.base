#!/usr/bin/perl 
#                              -*- Mode: Perl -*- 
# mailagent.log.pl --- 
# Author           : Manoj Srivastava ( srivasta@graceland ) 
# Created On       : Tue Dec 14 19:47:25 1993
# Created On Node  : graceland
# Last Modified By : Manoj Srivastava
# Last Modified On : Fri Jan  3 12:26:18 1997
# Last Machine Used: tiamat.datasync.com
# Update Count     : 14
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

@Month_Name = 
    ( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
     'Nov', 'Dec', );
    
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year +=1900;
$mon++;


$message = "\nFrom: $from\nSender: $header{Sender}\n" .
    "To: $header{To}\nSubject: $subject\n";
$message .= "Message-ID: $header{Message-id}\n" if defined $header{Message-id};
#&usrlog::new ('INCOMING', "$year$Month_Name[$mon].inc", 0); #';
&usrlog::new ('INCOMING', "$year.$mon.inc", 0); #';
&main::usr_log(  'INCOMING', "$message" ); 
				

&reject;
