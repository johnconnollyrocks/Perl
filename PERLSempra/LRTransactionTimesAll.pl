#!/usr/local/perl

use strict;
use warnings;

@ARGV = glob("*.log");
my %meter;
my $first_time;
while (<>) {
	   # TRANSACTION START TIME = 2009-01-27 19:20:21
	   #                          2009-01-28 18:34:09 20020535
  if (/TRANSACTION START TIME = (\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d) (\d+)/)
  { # print "$1\n";
    my ($date, $meter_id) = ($1, $2);
    $meter{$meter_id}{START} = $date;
    $first_time ||= $date;
	#print $first_time;
    #print "$1 $2\n" if $2;
  }
}

chomp(my @cm = `perl I41a_Events.pl`);
# die "referenced PERL script returned no results" if !(@cm);
for my $meter_start (@cm) {
  # my ($meter_id, $tr_id, $start_time) = split /,/, $meter_start;
  my ($meter_id, undef, $tr_id, $start_time) = split /,/, $meter_start;
  $meter{$meter_id}{END} = $start_time;
  $meter{$meter_id}{TRANS_ID} = $tr_id;
}

my $output_file = "LRTransactionResults.csv";
open(my $fh, ">", $output_file) or die "Error opening $output_file: $^E";
print $fh "UniqueIdentifer,TaskID,StartTime,EndTime,TotalTime\n";
for my $meter_id (sort keys %meter) {
  my ($start, $end, $tr_id) = @{$meter{$meter_id}}{qw(START END TRANS_ID)};
  my $diff = time_diff($start, $end);
  #s/T/ /, s/Z// for $start;
  print $fh "$meter_id,$tr_id,$start,$end,$diff\n";
  print "$meter_id,$tr_id,$start,$end,$diff\n";
  # print "$meter_id,$tr_id,$start,$end\n";
}
close $fh;

sub time_diff {
 my ($s, $e) = @_;

 $s =~ /(\d+):(\d+):(\d+)/
   or die "Bad start time: $s";
 my ($h1, $m1, $s1) = ($1, $2, $3);
 $e =~ /(\d+):(\d+):(\d+)/  
   or die "Bad end time: $e";
 my ($h2, $m2, $s2) = ($1, $2, $3);
 my ($dh, $dm, $ds) = ($h2-$h1, $m2-$m1, $s2-$s1);
 my $seconds = 3600*$dh + 60*$dm + $ds;

 return $seconds;
}
