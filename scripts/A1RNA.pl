#!/usr/bin/perl

use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;
use Data::Dumper;

my $transcript;
my $pos;
my $strand;
my $geneRank;
my $sgRNAScore;
my $duplex1;
my $duplex2;
my $startstopseq1;
my $startstopseq2;
my $energy;
my $count = 0;
my $seqio_obj = Bio::SeqIO->new(-file => "sequences.fasta",
                                -format => "fasta");
my $seq_obj = $seqio_obj->next_seq;
my $filetowrite = 'A1RNA.txt';

open(my $filestream, '>', $filetowrite) or die "Could not open file '$filetowrite' $!";

while ($seq_obj = $seqio_obj->next_seq){
  my $reversed_obj = $seq_obj->revcom;
  my $fasta_header = $seq_obj->primary_id."\n";

  #/* regex part */
  if ($fasta_header=~m/^([a-zA-Z0-9]+)\_(\d+)\_([a-z]+)\_(\d+\.\d+|0)\_(\d+\.\d+)/){
    $transcript = $1;
    $pos = $2;
    $strand = $3;
    $geneRank = $4;
    $sgRNAScore = $5;

    if($strand eq "sense"){
      $strand = "+";
    }
    else {
      $strand = "-";
    }
  }
  else {
    print $fasta_header; die "Cannot parse Fasta header";
  }
  #/* end of regex part */

  my $s1 = $seq_obj->seq;
  my $s2 = $reversed_obj->seq;

  print $filestream "$s1-$s2\n";
  print "$s1-$s2\n";

  my $cmd = "echo '$s1\n$s2' | RNAduplex";

  open(DUPLEX, $cmd."|");
  while(<DUPLEX>){
    chomp;
    if($_=~m/^([\.()]+)\&([()\.]+)\s+(\d+\,\d+)\s+(.)\s+(\d+\,\d+)\s+\((-?\d+\.\d+)\)/){
      $duplex1 = $1;
      $duplex2 = $2;
      $startstopseq1 = $3;
      $startstopseq2 = $5;
      $energy = $6;
    }
    else {
      print $_;
      die "cannot parse_";
    }
  }
close(DUPLEX);

print $filestream "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy\n\n";
print "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy\n";
$count += 1;
}
close $filestream;
print "succesfully wrote data of $count sequences to file: $filetowrite\n";
