#!/usr/local/perl
 
use strict;
use warnings;
 
@ARGV = ("IN15_1.txt");
 
my $programID;
my $ESN;
my $addTime;
 
while (<>) {
  #chomp; 
  if ( /Argument: 'Name' = '([\w\s]+)'/ ) {
    print "$1,";
    $programID = $1;
    #print "$programID,";
    readline();
    $_ = readline();
    # $addTime = s/ TRACE.*//;
    # print $addTime;
    s/ TRACE.*//;
    s/,/./;
    $addTime = $_;
    chomp($addTime);
    print "$addTime,";
    # print "$_";
    next;
  }
 
  if (/Argument: 'ElectronicSerialNumber' = '([.\d]+)'/) {
   print "$1\n";
   $ESN = $1;
   # Save the esn ($1) with what we've found above
   #   $programID{$1} = $programID if $programID;
   #   ($programID) = ();
   print "$programID, $ESN";
   next;
  }
#print "$programID,$ESN\n" if $ESN; # && $programID;
}
