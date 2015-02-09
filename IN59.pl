#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("IN59_7.txt");

my $amd;
my $scg;
my $aagm;
my %AMD;
my %SCG;
my %AAGM;

while (<>) {
  chomp;
  ##### Block 1
  if ( /Enter AddMeterDefinition/ ) {
    #s/ TRACE.*//;
    #s/,/./;
	s/,.*//;
    $amd = $_;
    next;
  }
  if ( /Enter SetConfigurationGroup/ ) {
    #s/ TRACE.*//;
    #s/,/./;
	s/,.*//;
    $scg = $_;
    next;
  }
  if ( /Enter AddApplicationGroupMember/ ) {
    #s/ TRACE.*//;
    #s/,/./;
	s/,.*//;
    $aagm = $_;
    next;
  }
if (/'ElectronicSerialNumber' = '([.\d]+)'/) {
   # Save the esn ($1) with what we've found above
   $AMD{$1} = $amd if $amd;
   $SCG{$1} = $scg if $scg;
   $AAGM{$1} = $aagm if $aagm;
   ($amd, $scg, $aagm) = ();
   next;
 }

}

for my $esn (sort keys %AMD) {
  # If theres an SCG for this esn in the collection of AMD's
  
    my $rma_flag = ($SCG{$esn} and $AAGM{$esn}) ? "N" : "Y";
    print "$esn,IN59,Non-RMA,$AMD{$esn}\n";
    # print "$esn,IN59,Non-RMA,$AMD{$esn}\n"
}
