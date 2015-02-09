#!/usr/local/perl

use strict;
use warnings;

use Getopt::Std qw(getopts);
use DBI;
use vars qw($opt_t);

getopts('t:') or die "Usage: command [-t yyyy-mm-ddThh:mm:ssZ]";

if ( $opt_t and $opt_t !~ /^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$/ ) {
  die "Bad timestamp: $opt_t";
}

my $got_timestamp;
$got_timestamp = 1 if ! $opt_t;

@ARGV = "I2_01_UpdateProgramID_UpdateMDMS Logs.txt";

my $conn = "dbi:Oracle:HOST=oramdmi1.sempra.com;SID=mdmi0;port=1521";
my $dbh = DBI->connect ( $conn, 'NSINGH', 'pas1234!', { 
  RaiseError => 1,
  AutoCommit => 1,
});
 
my $sth = $dbh->prepare(<<EOT);
SELECT submitteddate
from MDMS.TASK
where taskid = ?
EOT

my @meters;
while ( <> ) {
  if ( $opt_t ) {
    if ( /<wsu:Created>([^<]+)/ ) {
      $got_timestamp = 1 if $1 ge $opt_t;
    }
  }

  if ( /TaskInfo TaskOperation="Add"/ )  { 
    readline();
    $_ = readline();
    next unless /MeterID="(\w+)"/;
    my $meter_id1 = $1;
    $_ = readline();
    next unless /TaskInfo TaskOperation="RemoveDevice"/;
    readline() for 1..2;
    $_ = readline();
    next unless /MeterID="(\w+)".+?MeterProgramId="(\w+)"/;
    my ($meter_id2,$meter_prg_id2) = ($1,$2);
    $_ = readline();
    next unless /TaskInfo TaskOperation="SetDevice"/;
	if ($meter_id1 eq $meter_id2) {
    push @meters, [
      $meter_id1, 
      $meter_id2, $meter_prg_id2,
      $got_timestamp
    ];
   }
  }

  next unless @meters;
  next unless /TransactionID="(\d+)"/;
  my $trans_id=$1;
  my ($meter1, $meter2, $meter_prg2, $past_start)
  = @{shift @meters};

  # Got every thing
  # print("Transaction ID = $trans_id");
  my ( $submitted_date ) = $dbh->selectrow_array( $sth, undef, $trans_id ); 
  $submitted_date =~ s/\.000$//;
  print "$meter1, $meter_prg2, $trans_id, $submitted_date\n";
  #print "$meter1, $meter2, $meter_prg2, $trans_id\n";
}
