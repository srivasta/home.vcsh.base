#! /usr/bin/perl -w
# File: process-mail-from-cache.pl
# Time-stamp: <2009-11-30 10:40:31 srivasta>
#
# Copyright (C) 2009 by Manoj Srivastava
#
# Author: Manoj Srivastava
#
# Description:
# 
use warnings;
use strict;
use Carp;

use FindBin ();
use Data::Dumper;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;


($main::MYNAME     = $main::0) =~ s|.*/||;
$main::Author      = "Manoj Srivastava";
$main::AuthorMail  = "srivasta\@debian.org";

require 5.002;
use Getopt::Long;

my $home = $ENV{'HOME'} || $ENV{'LOGDIR'} || (getpwuid($<))[7] || 
    die "You're homeless!\n";
my $crmdir = "$home/var/lib/crm114";



my $help_opt = '';
my $spam = '';
my $ham  = '';

my %option_ctl = 
    (
     "help"                => \$help_opt,
     "spam"                => \$spam,
     "ham"                 => \$ham,
    );

my $usage = <<"EOUSAGE";
usage: $main::MYNAME [options] filename
    where the options are:
    --help              This message
    --spam|--ham        Whether the file is ham or spam
 $main::Author <$main::AuthorMail>
EOUSAGE

sub main() {
  my $ret;
  my $type    = '';
  my $crmtype = '';
  my $seq_type= '';


  $ret = GetOptions(%option_ctl);
  if(!$ret) {
    print "use --help to display command line syntax help.\n" ;
    exit 1;
  }
  if ($help_opt){
    print "$usage";
    exit 0;
  }
  if (!($spam || $ham)) {
    die "At least one of ham or spam must be specified\n";
  }
  if ($spam && $ham) {
    die "Only one of ham or spam must be specified\n";
  }
  $type    = "ham"          if $ham;
  $type    = "spam"         if $spam;
  $crmtype = "good"         if $ham; # nonspam, is using mailfilter
  $crmtype = "spam"         if $spam;

  my $reaver_file = $ARGV[0] if -e "${crmdir}/reaver_cache/texts/$ARGV[0]";
  warn "Could not find ${crmdir}/reaver_cache/texts/$ARGV[0]"
    unless -e "${crmdir}/reaver_cache/texts/$ARGV[0]";
  die unless -e "${crmdir}/reaver_cache/texts/$ARGV[0]";

  if (! -e "${crmdir}/reaver_cache/known_${crmtype}/$reaver_file" ) {
  # let mailreaver decide whether or not to train
    warn "crm -u $crmdir ${crmdir}/mailreaver.crm --config=${crmdir}/mailfilter.cf --${crmtype} --fileprefix=${crmdir}/ < ${crmdir}/reaver_cache/texts/$reaver_file | egrep 'file reaver_cache|^X-CRM114-Action'\n";
    my @crmlog = `crm -u $crmdir ${crmdir}/mailreaver.crm --config=${crmdir}/mailfilter.cf --${crmtype} --fileprefix=${crmdir}/ < ${crmdir}/reaver_cache/texts/$reaver_file | egrep 'file reaver_cache|^X-CRM114-Action'`;

    foreach my $line (@crmlog) {
      print "$line";
      next unless $line =~ m/train/;
      # if we had to retrain crm, make sure link exists
      if (! -e "${crmdir}/reaver_cache/known_${crmtype}/$reaver_file" ) {
        warn "Linking " .   "${crmdir}/reaver_cache/texts/$reaver_file" .
          "to ${crmdir}/reaver_cache/known_${crmtype}/$reaver_file\n" ;
        link "${crmdir}/reaver_cache/texts/$reaver_file",
          "${crmdir}/reaver_cache/known_${crmtype}/$reaver_file" ;
      }
      else {
        warn "${crmdir}/reaver_cache/known_${crmtype}/$reaver_file exists\n";
      }
    }
    print "\n";
    warn "sa-learn --$type  < ${crmdir}/reaver_cache/texts/$reaver_file \n";
    my @salog = `sa-learn --$type  < ${crmdir}/reaver_cache/texts/$reaver_file`;
    for (@salog) {
      print;
    }
  }
  else {
    warn "Already trained $reaver_file\n";
  }
}

&main();
