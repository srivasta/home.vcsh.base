#!/usr/bin/perl
#                              -*- Mode: Cperl -*- 
# sendback.pl --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.internal.golden-gryphon.com ) 
# Created On       : Thu Sep 23 15:48:02 2004
# Created On Node  : glaurung.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Thu Sep 23 15:52:18 2004
# Last Machine Used: glaurung.internal.golden-gryphon.com
# Update Count     : 2
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

sub sendback {
  local($cmd_line) = @_;
  local($reason) = join(’ ’, @ARGV[1..$#ARGV]);
  unless (open(MAILER, "|/usr/lib/sendmail ‐odq ‐t")) {
    &’add_log("ERROR cannot run sendmail to send message")
      if $’loglvl;
    return 1;
  }
  print MAILER <<EOF;
From: mailagent
To: $header{’Sender’}
Subject: Returned mail: Mailagent failure
$main’FILTER

  ‐‐‐ Transcript Of Session

$reason

  ‐‐‐ Unsent Message Follows

$header{’All’}
EOF
  close MAILER;
 # $ever_saved = 1;    # Don’t want it in mailbox
 $? == 0 ? 0 : 1;    # Failure status
}
