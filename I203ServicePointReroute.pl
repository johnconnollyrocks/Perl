#!/usr/local/perl

use strict;
use warnings;

use Getopt::Std qw(getopts);
use DBI;

use vars qw($opt_t);

getopts('t:') or die "Usage: command [-t timestamp]";

#getopts('p1:') or die "Usage: command [-p1 timestamp]";

#getopts('p2:') or die "Usage: command [-p2 timestamp]";

if ( $opt_t and $opt_t !~ /^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$/ ) {
  die "Bad timestamp: $opt_t";
}

my $got_timestamp;
my @route_id;
my @past_start;
$got_timestamp = 1 if ! $opt_t;

@ARGV = ("MDMS Log.txt");

my $conn = "dbi:Oracle:HOST=oramdmq1.sempra.com;SID=mdmq01;port=1521";
my $dbh = DBI->connect ( $conn, 'NSINGH', 'pas1234!', {
  RaiseError => 1,
  AutoCommit => 1,
});
 
my $sth = $dbh->prepare(<<EOT);
SELECT submitteddate
from MDMS.TASK
where taskid = ?
EOT

while (<>) {
 if ( $opt_t ) {
   if ( /<wsu:Created>([^<]+)/ ) {
     $got_timestamp = 1 if $1 ge $opt_t;
   }
 }

 if (/ServicePointID="(\w+)"/) {
   my $route_id = $1;
   $_ = readline();
   next unless /TaskOperation="CorrectRoute"/;
   push @route_id, $route_id;
   push @past_start, $got_timestamp;
 }
 next unless @route_id;

 my ( $transaction_id ) = /TransactionID="(\d+)"/ or next;
 my $rte_id = shift @route_id;
 my $past_st = shift @past_start;
 next unless $past_st;

 my ( $submitted_date ) = $dbh->selectrow_array( $sth, undef, $transaction_id );
 $submitted_date =~ s/\.000$//;
 print "$rte_id,I203Reroute,$transaction_id,$submitted_date\n";
 #print "$rte_id,I203SPRR,$transaction_id,\n";

}
