#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("ItronEvents_5.txt");

my $task_id;
my $meter_id;
my $add_time;

while (<>) {
  #chomp;
  # Itron.EE.Service.AMIDataStorageInterface.AmiDataAndEventImportAdapter:0 BuildChannelData  # (\d+).+Quantity (\w+)/)
  if (/Itron.EE.Service.AMIDataStorageInterface.AmiDataAndEventImportAdapter:0 BuildChannelData TaskID:/) {
     if ( /^(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d).*?Number of ([^,]+).*?(\d+)\.$/ ) {
    my ($tmstmp, $event, $meter_id) = ($1, $2, $3);
	$tmstmp =~ s/,.*//;
    print "$meter_id,I41aEvents,$event,$tmstmp\n";
      }
	}
  }