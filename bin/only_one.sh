#!/bin/bash
#                               -*- Mode: Sh -*- 
# only_one.sh --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
# Created On       : Fri Apr 20 11:13:04 2001
# Created On Node  : glaurung.green-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Fri Apr 20 11:42:04 2001
# Last Machine Used: glaurung.green-gryphon.com
# Update Count     : 3
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

set X $(ls -a $HOME/public_html/packages/binary-all/*.deb | sort -u)
shift

for deb
do
  if [ $# -gt 1 ]; then 
      echo rm -f $deb; 
      rm -f $deb; 
      shift; 
  fi; 
done

exit 0
