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
 if ( /^(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d).*?Number of ([^,]+).*?(\d+)\.$/ ) {
    my ($tmstmp, $event, $meter_id) = ($1, $2, $3);
	$tmstmp =~ s/,.*//;
    print "$tmstmp, $event, I41a, $meter_id\n";
    next;
	}
  }


