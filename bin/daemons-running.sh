#! /bin/bash
#                               -*- Mode: Sh -*- 
# daemons-running.sh --- 
# Author           : Cameron Hutchison <lists@xdna.net>
# Created On       : Mon Sep 14 12:52:28 2009
# Created On Node  : anzu.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# HISTORY          : 
# Description      : 
# 
# 


main()
{
        ports_and_pids \
        | map_lines add_pkg_info \
        | map_lines pretty_print
}

ports_and_pids()
{
        netstat -lntup \
        | awk '/^tcp/ { print $4"/"$1, $7 } /^udp/ { print $4"/"$1, $6 }' \
        | sed -n 's|^[^ ]*:\([^ ]*\) \([0-9]*\)/.*|\1 \2|p' \
        | sort -u -t/ -k1n -k2
}

add_pkg_info()
{
        local port=$1 pid=$2 bin pkg version newer

        bin=$(get_exe_from_pid $pid) || return
        pkg=$(get_pkg $bin) && {
                version=$(get_installed_version "$pkg")
                newer=$(get_latest_version "$pkg")
                [ "$newer" != "$version" ] || newer=""
        }

        echo $port $pid $bin $pkg $version $newer
}

pretty_print()
{
        [ -n "$1" ] && [ -n "$3" ] || return
        echo "$3 on port $1 ${4+from package $4}" \
                "${5:+(version $5${6:+, $6 available})}"
}

get_exe_from_pid()
{
        [ -d /proc/$1 ] || return
        local bin=$(
                xargs -n 1 -0 echo < /proc/$1/cmdline 2>/dev/null \
                | awk '{print $1 ; exit}'
        )
        [ -x "$bin" ] || bin=$(readlink /proc/$1/exe | sed 's/ (deleted)//')
        echo $bin
}

get_pkg()
{
        local pkg=$(dpkg -S "$1" 2>/dev/null | cut -d: -f1)
        [ -n "$pkg" ] || return
        echo "$pkg"
}       
get_installed_version()
{
        dpkg-query -W --showformat='${Version}' "$1"
}

get_latest_version()
{
        apt-cache show -a $pkg \
        | awk '/^Version:/ {print $2}' \
        | foldl_lines latest_version ""
}

latest_version()
{
        dpkg --compare-versions "$1" gt "$2" && echo "$1" || echo "$2"
}

# map_lines func
# evaluate "func" for each line of input
map_lines()
{
        while read line ; do
                eval $1 $line
        done
}

# foldl_lines func lhs
# evaluate (func (func (func lhs line1) line2) line3) ... for lines of input
foldl_lines()
{
        func=$1
        lhs="$2"
        while read line ; do
                lhs=$(eval $func "$lhs" "$line")
        done
        echo $lhs
}

main
