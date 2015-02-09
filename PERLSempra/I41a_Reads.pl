#!/usr/local/perl

use strict;
use warnings;

@ARGV = ("I41aReadsMDMSLog.txt");

my $task_id;
my $meter_id;
my $add_time;

while (<>) {
#  
 if (/Itron.EE.Facade.ImportExport.Adapter.Event.Helper.DocumentManagement:0 SaveEventDocument TaskID:/) { # (\d+) - Event from ObjectType RecordingDevice ID 'bak_([\.\d]+)'/) {
 # print "Itron.EE.Facade Matched\n";
 if ( /^(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d,\d\d\d).*?\.(\d+)'/ ) {
    my ($tmstmp, $meter_id) = ($1, $2, $3);
	$tmstmp =~ s/,.*//; 
    print "$meter_id,I41a,Reads,$tmstmp\n";
    }
  }
}


