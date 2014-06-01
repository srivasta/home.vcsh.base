#! /bin/zsh -f
#                               -*- Mode: Sh -*- 
# ipod.sh --- 
# Author           : Manoj Srivastava ( srivasta@anzu.internal.golden-gryphon.com ) 
# Created On       : Fri Sep 12 21:44:06 2008
# Created On Node  : anzu.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Fri Sep 12 21:45:20 2008
# Last Machine Used: anzu.internal.golden-gryphon.com
# Update Count     : 1
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# 

set -e

if [[ -e /dev/ipod ]]; then
    pmount-hal /dev/ipod; 
    cd $(hal-get-property --udi $( hal-find-by-property --key block.device --string $(realpath /dev/ipod)) --key volume.mount_point)
fi
