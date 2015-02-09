#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("ItronAMI_5.txt");

my $task_id;
my $meter_id;
my $add_time;

while (<>) {
  #chomp;
      #2009-02-03 18:16:26,335 23046 WARN     [9] Itron.EE.Service.AMIDataStorageInterface.AmiDataAndEventImportAdapter:0 BuildChannelData TaskID: 63541 - Service point channel not found. Channel type: Register, Recording device id: Number of Power Outages, Quantity 102RD1_20029683./) {
  if (/Itron.EE.Service.AMIDataStorageInterface.AmiDataAndEventImportAdapter:0 BuildChannelData TaskID: (\d+) - Service point channel not found. Channel type: Register, Recording device id: Number of Power Outages, Quantity 102RD1_(\d+)/) { # print "match found $_";
    $task_id = $1;
	$meter_id = $2;
	s/,.*//; 
    $add_time = $_;
    chomp($add_time);
    print "$meter_id,I41a,$task_id,$add_time\n";
    next;
	}
  }


