From: "Ralf E. Stranzenbach" <ralf@reswi.en.open.de>
Subject: (agent-users 436) a simple but useful extension to mailagent
To: agent-users@foretune.co.jp
Date: Thu, 24 Aug 95 00:21:13 +0200
Reply-To: agent-users@foretune.co.jp
X-From-Line: owner-agent-users@foretune.co.jp  Wed Aug 23 19:02:03 1995
Received: from lizard.foretune.co.jp (lizard.foretune.co.jp [133.123.1.2]) by plymouth.pilgrim.umass.edu (8.6.12/8.6.12) with ESMTP id TAA15650 for <srivasta@pilgrim.umass.edu>; Wed, 23 Aug 1995 19:01:59 -0400
Received: (from shigeya@localhost) by lizard.foretune.co.jp (8.6.12+2.5Wb7/3.3W4-lizard950703) id HAA13906; Thu, 24 Aug 1995 07:56:31 +0900
Message-Id: <m0slOAc-000FpJC@reswi.ruhr.de>
Content-Type: text/plain
MIME-Version: 1.0 (NeXT Mail 3.3 v118.2)
Precedence: list
X-Distribute: distribute [version 2.1 (Alpha) patchlevel=19]
X-Sequence: agent-users 436
Errors-To: owner-agent-users@foretune.co.jp
Sender: owner-agent-users@foretune.co.jp
X-Filter: mailagent [version 3.0 PL41] for srivasta@pilgrim.umass.edu
Message-ID: <viro9epo@totally-fudged-out-message-id>
Lines: 127
Xref: belthil.pilgrim.umass.edu agent:96

Hi,

here it is: a simple extension module for "mailagent" (my first one).

At work, i have to track the state of some (a still increasing  
count) of our customers systems and i've installed mailagent to get  
those mails sorted for me. This worked well but i begun to worry as  
i reached my 160-th filter rule.

So i started using my brain and this is my result: i've added a  
LOOKUP command to mailagent to map system names and customer numbers  
to their mailboxes.

This LOOKUP command takes three parameters; the first names a  
variable (either local or persistent), the second the map-file and  
the third the key. The map-file consists of lines with key/valye  
pairs, delimited by one or more white-space characters.

If "key" is listed in the map-file, the value will be assigned to  
the named "variable" and LOOKUP succeeds. In any other case LOOKUP  
"fails" --- so you may use "REJECT -f" or something like this after  
LOOKUP.

It's a very simple addition. It would be much more interesing to  
set-up some sort of SQL-LOOKUP thus using the SQL databases to get  
those mappings... Using perl5, this should be possible require-ing  
Sybperl.pm in the middle of the execution...

Anyway, the code below works with mailagent-3.0@41 (perl5.001l) and  
with slight modifications (replace :: with ') with mailagent-3.0@23  
(perl4.036).

If you'll find this code useful in any way, feel free to get and  
use it. but drop me a mail if you do so: i'm just interested if it's  
useable for anyone but me.

	- ralf

P.S.:	You've to add the line
		LOOKUP ~/somewhere/lookup.pl lookup true true
	tou your "newcmd" file.

---
Ralf E. Stranzenbach  <ralf@reswi.ruhr.de>
    at Home:	+49 2302 / 96200-3
    at Work:	+49 231 / 75892-15

Object-oriented means that the objects displayed on the screen - such
as buttons, boxes or lists - mean something to the operating system,
just as words mean something to DOS.
					- Ron White, How Software Works

---- CODE STARTS HERE
#
# (c)1995 Ralf E. Stranzenbach <ralf@reswi.ruhr.de>
#
# $Id: lookup.pl,v 1.2 1995/08/23 21:58:45 ralf Publ $
#
# $Log: lookup.pl,v $
# Revision 1.2  1995/08/23  21:58:45  ralf
# released to public domain after some final checking
#
# Revision 1.1  1995/08/23  21:54:49  ralf
# Initial revision
#
#

sub lookup {			# maps a KEY string to some other values
				# using map-Files.
				# It's a *very* simple imlementation but
				# this solution drops my rule count from
				# something around 150 to 6 --- and this
				# makes my mailagent run *much* better.
				#
				# Use it like this
				# { LOOKUP mailbox num_to_mbox %1;
				#   REJECT -f punknown;
				#   SAVE %#mailbox;
				#   DELETE };
				# <punknown> { LEAVE };

				# check the arg-count
    if ($#ARGV != 3) {
	&::add_log ("ERROR: insufficient number of args.") if $::loglvl;
	&::add_log ("USAGE: LOOKUP var table key") if $::loglvl;
	return 1;
    }

				# guess the file's name
    local ($file) =
	($ARGV[2] =~ /^\//) ? $ARGV [2] : ($cf::spool . '/' . $ARGV[2]);

				# open the data file
    unless (open (LOOKUPF, "< $file")) {
	&::add_log ("ERROR: LOOKUP can't open file $file") if $::loglvl;
	return 1;
    }
    &::add_log ("LOOKUP: reading from $file") if $::loglvl == 20;

				# read the lines
    while (<LOOKUPF>) {
	next if /^\s*#/;
	next if /^\s*$/;
	next unless /^(\S+)\s+(.*)$/;

				# is this the key we've searched for ?
	if ($1 eq $ARGV[3]) {
	    # yup, it is..
	    if ($ARGV[1] =~ /^:/) {
				# set a persistent variable
		&extern::set ($ARGV[1], $2);
	    } else {
				# set a simple "internal" variable
		$::Variable{$ARGV[1]} = $2;
	    }
	    &::add_log ("LOOKUP matched $1 -> $2") if $::loglvl == 20;
	    close (LOOKUPF);
	    return 0;
	}
    }
				# no math found...
    &::add_log ("LOOKUP no match found for $ARGV[3]") if $::loglvl == 20;
    close (LOOKUPF);
    return 1;
}
1;
---- CODE ENDS HERE


