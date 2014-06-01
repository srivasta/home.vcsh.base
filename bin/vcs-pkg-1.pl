#! /usr/bin/perl -w
# File: vcs-pkg-1.pl
# Created 2009-04-23
#
# Copyright (C) 2009 by Manoj Srivastava
#
# Author: Manoj Srivastava
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Description:
# This script attempt to perform the following tasks in as VCS
# agnostic a manner possible:
#
# 1. Provide a copy of one or more upstream source tar-balls in the
#    staging area where the package will be built. This staging area may
#    or may not be the working directory checked out from the underlying
#    VCS; my experience has been that most tools of the ilk have a
#    temporary staging directory of some kind.
# 2. Provide a directory tree of the sources from which the package is
#    to be built in the staging area
# 3. Run one or more commands or shell scripts in the staging area to
#    create the package. These series of commands might be very
#    complex, creating and running virtual machines, chroot jails,
#    satisfying build dependencies, using copy-on-write mechanisms,
#    running unit tests and lintian/puiparts checks on the results. But
#    the building a package script may just punt on these scripts to a
#    user specified hook.


use warnings;
use strict;
use Getopt::Long;
use Cwd qw(abs_path cwd);
use File::Temp qw/ tempfile tempdir /;

use Carp;
use FindBin ();
use Data::Dumper;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;

=head1 NAME

vcs-pkg-git - build  packages from a git working dir.

=cut
($main::MYNAME     = $main::0) =~ s|.*/||;
$main::Author      = "Manoj Srivastava";
$main::AuthorMail  = "srivasta\@debian.org";
$main::Version     = '0.001';

## Detect which VCS, if any, is being used, and setup varisout common
## variables

# This hash holds a set of functions that detect whether we are in a
# working directory for a particular VCS. The functions must have these
# characteristics:
my %VCS_SetUp = ();

my %setup = ();


# 1. Each function tests for one or more VCS types, and retyrns
#    non-zero if called in a working directory for the supported VCS.
#    Otherwise, the funtion returns 0.
# 2. The functions is passed an array reference. At the very least,
#    $params{'vcs_type'} and $params{'base_dir'} must be filled in, and
#    any other VCS specific information can also be stored in the hash
#    for future use.
# 3. Another common key value is 'cur_branch'

sub register_setup ($$) {
  my ($vcs, $coderef) = @_;

  die "Need a reference to a subroutine" unless
    ref $coderef eq 'CODE';
  $VCS_SetUp{$vcs} = $coderef ;
}

### Git
sub git_setup ($) {
  my $params = shift;
  return 0 unless 
    (system("git rev-parse --is-inside-work-tree > /dev/null 2>&1") == 0);
  $params->{'vcs_type'} = 'git';

  my $base_dir='';
  chomp($base_dir=`git rev-parse --show-cdup 2>/dev/null`);
  if ($base_dir) {
    $base_dir = abs_path($base_dir);
  }
  else {
    $base_dir = cwd();
  }
  $params->{'base_dir'} = $base_dir;

  my $cur_branch = '';
  chomp($cur_branch=`git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null`);
  $cur_branch =~ s,refs/heads/,,;
  $params->{'cur_branch'} = $cur_branch;

  chomp(my $git_dir = `git rev-parse --git-dir`);
  $params->{'git_dir'} = abs_path($git_dir);

  return 1;
}
register_setup ('git', \&git_setup );


### bzr
sub bzr_setup ($) {
  my $params = shift;
  return 0 unless
    (system("bzr info >/dev/null 2>&1") == 0);
  $params->{'vcs_type'} = 'bzr';

  my $base_dir='';
  chomp($base_dir=`bzr info 2>/dev/null`);
  if ($base_dir) {
    $base_dir =~ s,\s*branch root:\s*,,g;
    $base_dir = abs_path($base_dir);
  }
  else {
    $base_dir = cwd();
  }
  $params->{'base_dir'} = $base_dir;

  return 1;
}
register_setup ('bzr', \&bzr_setup );

# Arch
sub arch_setup ($) {
  my $params = shift;
  return 0 unless
    (system("tla tree-root >/dev/null 2>&1") == 0);
  $params->{'vcs_type'} = 'arch';

  my $base_dir='';
  chomp($base_dir=`tla tree-root 2>/dev/null`);
  $base_dir = abs_path($base_dir);
  $params->{'base_dir'} = $base_dir;

  my $cur_branch = '';
  chomp($cur_branch=`tla tree-id`);
  $cur_branch =~ s,^[^/]*/,,g;
  $params->{'cur_branch'} = $cur_branch;

  return 1;
}
register_setup ('arch', \&arch_setup );

# SVN

sub svn_setup ($) {
  my $params = shift;
  return 0 unless -d '.svn';
  $params->{'vcs_type'} = 'svn';

  my $base_dir='';
  $base_dir=cwd();
  while (-d "$base_dir/../.svn") {
    $base_dir="$base_dir/..";
  }
  $base_dir = abs_path($base_dir);
  $params->{'base_dir'} = $base_dir;

  my $cur_branch = '';
  my $br='';
  my $rev='';
  open(INFO, "svn info $base_dir") or die "Could not run svn info $base_dir:$!";
  while (<INFO>) {
    chomp;
    if (/^URL/) {
      s,.*/,,g;
      $br="$_";
    }
    if (/Revision/) {
      s,[^\d]*,,;
      $rev="$_";
    }
  }
  close (INFO);
  $cur_branch="$br:$rev";
  $params->{'cur_branch'} = $cur_branch;

  return 1;
}
register_setup ('svn', \&svn_setup );

# cvs
sub cvs_setup ($) {
  my $params = shift;
  return 0 unless -d 'CVS';
  $params->{'vcs_type'} = 'cvs';

  my $base_dir='';
  $base_dir=cwd();
  while (-d "$base_dir/../CVS") {
    $base_dir="$base_dir/..";
  }
  $base_dir = abs_path($base_dir);
  $params->{'base_dir'} = $base_dir;
  # may use cvs tatus to get brnch information
  return 1;
}
register_setup ('cvs', \&cvs_setup );

#hg
sub hg_setup ($) {
  my $params = shift;
  return 0 unless  (system("hg root >/dev/null 2>&1") == 0);

  my $base_dir='';
  chomp($base_dir=`hg root 2>/dev/null`);
  $base_dir = abs_path($base_dir);
  $params->{'base_dir'} = $base_dir;

  my $cur_branch = '';
  chomp($cur_branch='hg:' . `hg branch`);
  $params->{'cur_branch'} = $cur_branch;

  return 1;
}
register_setup ('hg', \&hg_setup );

#  Do option parsing here
my $help_opt    = 0;
my $config_file = '/etc/vcs-pkg.conf';
my %option_ctl  =
  (
   "help"                => \$help_opt,
   "config"              => \$config_file,
  );

=head1 SYNOPSIS

 usage: vcs-pkg-git [options] treeish [treeish treeish ]

=cut

=head1 DESCRIPTION

This manual page explains the B<vcs-pkg-git> utility, which is used to
create packages from a git working directory.  This utility needs to
be run from a git working directory.


=cut

=head1 OPTIONS

=over 3

=item B<--help> Print out a usage message.

=back

=over 3

=item B<--config> C<file> The configuration file to use

=over 2

This is the the configuration file to use instead of
C</etc/vcs-pkg.conf>. The file is expected to be a leggal Perl library
file.

=back

=back

=over 3

=item B<--dest-dir> C<directory> The build directory

=over 2

This is the directory where the sources are exported to, and the build
command is executed from. (overrides the environment variable
C<DEST_DIR> and theconfiguration variable C<conf_dest_dir>. )

=back

=back



=over 3

=item B<--upstream-tar-dir> C<directory> The directory where suptream tarballs are kept

=over 2

This is the directory where one can find the upstream C<.orig.tar.gz>
file. Defaults to the parent of the working directory.

=back

=back

=cut

my $usage = << "EOUSAGE";
This program should be run in a working directory for the software
to be packaged.

usage: $main::MYNAME [options] treeish [treeish treeish ]
  where options are:
 --help               This message.
 --dest-dir <dir>     The directory where the sources are exported to,
                      and the build command is executed from. (overrides
                      the environment variable DEST_DIR  and the
                      configuration variable conf_dest_dir )
 --upstream-tar-dir <dir>
                      The directory i which to look for upstream orig,tar.gz
                      files. The default is to look in the parent directory of
                      the working directory.

 
The rest of the arguments depend on the type of VCS being used. For
Git, the required argument is a treeish (a commit, tag, or branch) for
the integration branch, from which the package is to be built.

$main::MYNAME $main::Version         $main::Author <$main::AuthorMail>

EOUSAGE

my $ret = GetOptions(\%option_ctl, "help", "config=s", "upstream-tar-dir=s",
                     "dest-dir=s");

if ($help_opt) {
  print "$usage";
  exit 0;
}

# Load the configuration file, if it exists
require $config_file if -r $config_file;

# Set variables
my $conf_dest_dir = '';
my $destdir = '';
if (defined $option_ctl{'dest-dir'} && -d $option_ctl{'dest-dir'} ) {
  $destdir = $option_ctl{'dest-dir'};
}
elsif ($ENV{'VCS_PKG_DEST_DIR'}) {
  $destdir = $ENV{'VCS_PKG_DEST_DIR'};
}
elsif ($conf_dest_dir) {
  $destdir = $conf_dest_dir;
}
#  Some sanity checking
if (! $destdir) {
  die "Could not find where to build packages.\n";
}

# We must be in a working directory
my ($key, $value);
while (($key, $value) = each %VCS_SetUp) {
  next unless &{$value}(\%setup);
  last;
}

die "Not in working dir or unsupported VCS\n" unless
  (defined $setup{'vcs_type'} && $setup{'vcs_type'});
die "Could not find working srectory" unless
  (defined $setup{'base_dir'} && $setup{'base_dir'} && -d $setup{'base_dir'});

if (cwd() ne  $setup{'base_dir'}) {
  chdir $setup{'base_dir'};
}

print Dumper(\%VCS_SetUp, \%setup);

#my $tempdir = tempdir ( 'vcs-pkg-XXXXXXX', DIR => $destdir, CLEANUP => 0 );

# git ls-tree master .gitmodules   <--- if not empty, <mode> SP <type> SP <object> TAB <file>
# git show ad915e6d535d4a66258a350815ae35597475aa77 <-- object from above
# Look for  path = <modpath>
# git ls-tree master debian  <-- modpath from above


