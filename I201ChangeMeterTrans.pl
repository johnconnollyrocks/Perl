#!/usr/local/perl

use strict;
use warnings;

use Getopt::Std qw(getopts);
use DBI;
use vars qw($opt_t $opt_s);

$opt_s=".";
getopts('t:s:') or die "Usage: command [-s <perl script name>]";

my $got_timestamp;
$got_timestamp = 1 if ! $opt_t;

if ( $opt_t and $opt_t !~ /^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$/ ) {
  die "Bad timestamp: $opt_t";
}

@ARGV = "InputTrace.webinfo";

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
my $meter_pgm_id;
my $status;
my $mult;

while ( <> ) {
  if ( $opt_t ) {
    if ( /<wsu:Created>([^<]+)/ ) {
	  $got_timestamp = 1 if $1 ge $opt_t;
    }
  }

  if ( /TaskOperation="Add"/ )  {
    readline();
    $_ = readline();
    next unless /MeterID="(\w+)".+MeterProgramId="(\w+)"/;
    my $meter_id = $1;
    $meter_pgm_id = $2;
    $_ = readline();
    next unless /TaskOperation="SetDevice"/;
    push @meters, [ $meter_id, $got_timestamp ];
  }

  next unless @meters;
  next unless /TransactionID="(\d+)"/;
  my $trans_id=$1;
  my ($meter_id, $past_start) = @{shift @meters};
  next unless $past_start;

  # Got every thing
  # print("Transaction ID = $trans_id");
  my ( $submitted_date ) = $dbh->selectrow_array( $sth, undef, $trans_id ); 
  #print "$meter_id,$trans_id,$submitted_date\n";
  print "$meter_id,$trans_id,$meter_pgm_id,$submitted_date\n";
  #print "$meter_id,$status,$mult,$trans_id,\n";
}
