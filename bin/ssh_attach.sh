#!/bin/bash
# 
#  This script will allow a user to attach to a previously running ssh-agent
#  session. Assume this is GPLv2 or later.
#
#  Caveats: This only assumes *one* ssh-agent is running and that it's running
#  as YOU. I could make it more robust... but I'll wait for this to become an
#  issue first.
# 
#  Usage: in your ~/.bashrc source this file and call ssh_attach_main
#--snip--snip--snip--
#if [ -f "$HOME/lib/ssh_attach.sh" ]; then
#		source "$HOME/lib/ssh_attach.sh"
#		ssh_attach_main
#fi
#--snip--snip--snip--
#
#						--timball@tux.org
# 
# $Id: ssh_attach.sh,v 1.1 2003/05/01 22:29:15 timball Exp timball $
#

# some useful aliases
alias ssh\-off="eval \`ssh-agent -k\`"
alias ssh\-on="eval \`ssh-agent -s\` && ssh-add"


# actually attaches to running ssh-agent process
function ssh_attach () 
{
			SSH_AGENT_PID=$(pidof ssh-agent)
			SSH_AUTH_PID=$(($SSH_AGENT_PID - 1))
			SSH_AUTH_SOCK=`/bin/ls /tmp/ssh*/agent.$SSH_AUTH_PID`
			export SSH_AGENT_PID SSH_AUTH_SOCK
			unset SSH_AUTH_PID
			unset ssh_attach
			echo "ssh-agent already running at $SSH_AGENT_PID $SSH_AUTH_SOCK"
}


# all the frontend work to connect to a running ssh-agent process
function ssh_attach_main ()
{
    if [ "$SSH_AGENT_PID" ]; then
        echo "ssh-agent already started at $SSH_AGENT_PID"
    else 
		# Figure out if ssh-agent is running
		if [ -f "$HOME/lib/is_running.sh" ]; then
			source "$HOME/lib/is_running.sh"
		fi
		PROGNAME="ssh-agent"
		if [ $(is_running) = "1" ]; then
			ssh_attach
		else 
			# fall thru and complain
			echo "turn ssh-agent on w/ 'ssh-on'"
		fi
    fi

	unset ssh_attach_main
}
