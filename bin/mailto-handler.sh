#!/bin/bash
#                               -*- Mode: Sh -*- 
# mailto-handler.sh --- 
# Author           : Manoj Srivastava ( srivasta@glaurung.internal.golden-gryphon.com ) 
# Created On       : Tue Aug 30 14:32:03 2005
# Created On Node  : glaurung.internal.golden-gryphon.com
# Last Modified By : Manoj Srivastava
# Last Modified On : Tue Aug 30 18:22:17 2005
# Last Machine Used: glaurung.internal.golden-gryphon.com
# Update Count     : 14
# Status           : Unknown, Use with caution!
# HISTORY          : 
# Description      : 
# 
# arch-tag: 42733a39-e4c5-4363-a487-fb01c8283193
# 

url="$1"

echo "In mailto-handler.sh ($@)" >> ~/tmp/mailto.log

if [ -z "$url" ]; then
    exec emacs -f gnus-init
else
	  if emacsclient -s gnus -c -e "(server-edit)" $HOME/junk  >/dev/null 2>&1; then
			exec emacsclient -s gnus -c -e "(progn (gnus-url-mailto \"$url\") (set-buffer-modified-p nil))"
    elif gnuclient -batch -eval t >/dev/null 2>&1; then
        exec gnuclient -batch -eval "(progn (gnus-url-mailto \"$url\") (set-buffer-modified-p nil))"
    else
        exec emacs -eval "(progn (require 'gnus-art) (gnus-url-mailto \"$url\") (font-lock-mode 1) (set-buffer-modified-p nil))"
    fi
fi

xmessage -center No "Emacs or gnuclient" &

# exec thunderbird if there's no instance running
thunderbird -remote 'ping()' 2>/dev/null || exec thunderbird -compose "$@" 
# otherwise raise window,
thunderbird -remote "xfeDoCommand(openInbox)"

# and maybe send the mailto:
type="$url"
type="${type%%:*}"
if [ "$type" = 'mailto' ]; then 
    thunderbird -compose $url
else
    thunderbird -remote "mailto($url)" 
fi

# mozilla-thunderbird -remote "mailto(${url#mailto:})" 

