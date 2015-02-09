#!/usr/local/perl

use strict;
use warnings;

use Getopt::Std qw(getopts);
use DBI;

use vars qw($opt_t);

getopts('t:') or die "Usage: command [-t timestamp]";

if ( $opt_t and $opt_t !~ /^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$/ ) {
  die "Bad timestamp: $opt_t";
}

my $got_timestamp;
$got_timestamp = 1 if ! $opt_t;

@ARGV = ("I204AddLog.txt");

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

my @premise;
while (<>) {
 if ( $opt_t ) {
   if ( /<wsu:Created>([^<]+)/ ) {
     $got_timestamp = 1 if $1 lt $opt_t;
   }
 }

 if (/PremiseID="(\d+)" PremiseNumber="(\d+)"/) {
	$_ = readline;
	print "Found Task Operation $_\n" if /TaskInfo TaskOperation="Add"/;
	# if /TaskInfo TaskOperation="Add"/
 } 
 {
   push @premise, [ $1, $2, $got_timestamp ];
 }
 next unless @premise;

 my ( $transaction_id ) = /TransactionID="(\d+)"/ or next;
 my ( $pr_id, $pr_num, $past_start ) = @{shift @premise};
 next unless $past_start;

 my ( $submitted_date ) = $dbh->selectrow_array( $sth, undef, $transaction_id );
 $submitted_date =~ s/\.000$//;
 print "$pr_num,I204,$transaction_id,$submitted_date\n";
 #print "$pr_id $pr_num $transaction_id\n";
}
