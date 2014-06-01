#! /bin/bash
#                               -*- Mode: Sh -*- 
# process-learn.sh --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
# Created On       : Sat Nov 22 11:12:27 2003
# Created On Node  : glaurung.green-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Tue Sep 15 08:23:57 2009
# Last Machine Used: anzu.internal.golden-gryphon.com
# Update Count     : 3
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

if [ -e $HOME/mail/learn-spam ]; then
    mv $HOME/mail/learn-spam $HOME/tmp/realspam
    sa-learn --spam --mbox $HOME/tmp/realspam
    rm $HOME/tmp/realspam
fi

if [ -e $HOME/mail/learn-ham ]; then
    mv $HOME/mail/learn-ham $HOME/tmp/ham
    sa-learn --ham --mbox $HOME/tmp/ham
    rm $HOME/tmp/ham
fi

#if [ -e $HOME/var/spool/mail/realspam ]; then
#    rm $HOME/var/spool/mail/realspam
#fi

