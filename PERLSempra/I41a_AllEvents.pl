#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("ItronAMI_5.txt");

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
    print "$meter_id, $event, I41a, $tmstmp\n";
  }

	
#	$task_id = $1;
#	$meter_id = $2;
	#$meter_id =~ s/*._//;
 #   $add_time = $_;
#	$add_time =~ s/,.*//; 
 #   chomp($add_time);
  #  print "$meter_id,I41a,$task_id,$add_time\n";
   # next;
	}
  }


