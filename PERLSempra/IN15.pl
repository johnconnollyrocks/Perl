#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("IN15_1.txt");

my $programID;
my $ESN;
my $add_time;

while (<>) {
  #chomp;  
  if ( /Argument: 'Name' = '([\w\s]+)'/ ) {
    #print "$1,";
    $programID = $1;
    readline();
    $_ = readline();
    # $addTime = s/ TRACE.*//;
    # print $addTime;
    # s/ TRACE.*//;
    # s/,/./; 
	s/,.*//; 
    $add_time = $_;
    chomp($add_time);
    # print "$_";
    next;
  }

if (/Argument: 'ElectronicSerialNumber' = '([.\d]+)'/) {
   $ESN = $1;
   # Save the esn ($1) with what we've found above
   #   $programID{$1} = $programID if $programID;
   #   ($programID) = ();
   print "$ESN,IN15,$programID,$add_time\n";
   next;
 }
#print "$programID,$ESN\n" if $ESN; # && $programID;
}

