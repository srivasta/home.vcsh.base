#! /bin/bash
#                               -*- Mode: Sh -*- 
# convert_html.sh --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.internal.golden-gryphon.com ) 
# Created On       : Sun Jan 15 23:02:12 2006
# Created On Node  : glaurung.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Tue Sep 15 08:23:09 2009
# Last Machine Used: anzu.internal.golden-gryphon.com
# Update Count     : 9
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# arch-tag: 1adc75df-09f9-4de3-adc4-f93e3085dc2b
# 
DIR="/home/ftp/incoming/Web MTSU"
progname="`basename \"$0\"`"
set -e

withecho () {
    echo " $@" >&2
    "$@"
}
action='withecho'
usageversion () {
        cat >&2 <<END
Usage: $progname  [options] <package>
Options: 
  -h           print this message
  -n           "Dry-run" mode - No action taken, only print commands.
  -v           Make the command verbose

END
}
# parse Command line
# Note that we use `"$@"' to let each command-line parameter expand to a 
# separate word. The quotes around `$@' are essential!
# We need TEMP as the `eval set --' would nuke the return value of getopt.
TEMP=$(getopt -a -s bash -o hnv -n 'arch_update' -- "$@")
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -h|--help) usageversion; exit 0   ; shift   ;;
        -n)      action='echo';docmd='NO' ; shift   ;;
        -v)      VERBOSE=1                ; shift   ;;
        --)      shift ; break ;;
        *) echo >&2 "Internal error!($i)"
            usageversion; exit 1           ;;
    esac
done

if [[ -d "$DIR" ]]; then
    find "$DIR" -type f -name \*.html | grep -v nonav | while read i; do
        j=${i%%.html}_nonav.html
				k=${i##$DIR/}
        if [[ -e "$j" ]]; then
            if [[ "$i" -nt "$j" ]]; then
                $action $HOME/bin/create_nonav.pl "$i"
								echo action "$i" jshardo@frank.mtsu.edu:public_html/$k
            fi
        else
            $action $HOME/bin/create_nonav.pl "$i"
						echo action "$i" jshardo@frank.mtsu.edu:public_html/$k
        fi
    done
fi

