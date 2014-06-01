#!/usr/bin/perl

#Author: Jack Vinson:  vinson@unagi.cis.upenn.edu
#Date: Tue Jun 28 1994

#Jack's attempt at parsing lisp objects via regexps in order to extract 
# interesting info.  In this case, I'm grabbing all the entries of the 
# .bbdb file and displaying name and phone number if they exist.

#This can be fairly easily extended to display addresses as well.

#NOTE:  The variable $nets will be filled improperly if the database 
# entry has notes AND user-defined fields.

while (<>) {
  ($first, $last, $aliases, $company, $phones, $addresses, $nets, $other) = /^\[(nil|\"[^\"]*\") (nil|\"[^\"]*\") (nil|\(\".*\"\)) (nil|\"[^\"]*\") (nil|\(.*\)) (nil|\(.*\)) (nil|\(\".*\"\)) (nil|.*) nil\]$/;
  if ($first !~ /^nil$/) {
    ($temp1, $first, $temp2) = split(/\"/,$first,3);
  }
  if ($last !~ /^nil$/) {
    ($temp1, $last, $temp2) = split(/\"/,$last,3);
  }
  # Print the phone numbers
  if ($phones =~ /^nil$/) {
    print "There are no phone numbers available for $first $last.\n";
  }
  else {
    @phentries = split(/\]/,$phones);
    $phentries = @phentries;
    if ($phentries > 2) {
      print "$first $last:\n";
    }
    else {
      print "$first $last:";
    }
    foreach $entry (@phentries) {
      if ($entry !~ /\)$/) {
        ($temp1, $loc, $usnum, $nonusnum) = split(/\"/,$entry);
        if ($usnum =~ /^\s*$/) { 
          printf("%10s: %-15s\n",$loc,$nonusnum);
        }
        else {
          @parts = split(/\s/,$usnum);
          if ($parts[1] == "1") {
            shift(@parts);
          }
          $num = "($parts[1]) $parts[2] $parts[3]";
          printf("%10s: (%3.3d) %3.3d %4.4d\n",$loc,$parts[1],$parts[2],$parts[3]);
        }
      }
    }
    print "\n";
  }
  # Now for email
  if ($nets !~ /^nil$/) {
    # So we have some email addresses
    $nets =~ s/\(\(creation.*$//og;
    $nets =~ s/[\(\)\"]//g;
    @addresses = split(/ /, $nets);
    printf("%10s\n",'Email:') if $#addresses > -1;
    foreach my $entry (@addresses) {
      print " " x 10, $entry, "\n";
    }
    print "\n";
  }
}
