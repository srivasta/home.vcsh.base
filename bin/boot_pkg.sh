#                               -*- Mode: Sh -*- 
# boot_pkg.sh --- 
# Author           : Manoj Srivastava ( srivasta@anzu.internal.golden-gryphon.com ) 
# Created On       : Sat Jul 21 08:08:50 2007
# Created On Node  : anzu.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Sat Jul 21 12:32:18 2007
# Last Machine Used: anzu.internal.golden-gryphon.com
# Update Count     : 5
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# A script to determine which packages are involved in the booting process. 
# 

set -e

for file in /etc/init.d/*; do
    pkg=$(dlocate $file | sed -e 's/:.*$//')
    prio=$(grep-status -X -sPriority -P $pkg | sed -e 's/^[^:]*: *//')
    case $prio in
        optional|extra)
            grep-status -X -sPackage,Status,Description -P $pkg
            ;;
        *)
            :
    esac
done
