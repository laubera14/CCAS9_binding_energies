#!/usr/bin/perl

use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;
use Data::Dumper;
use POSIX;

my $hybrid_file = 'RNADNA_3prime_T.txt';
my $DNA_file = 'DNADNA_3prime_T.txt';
my $filetowrite = '1binding_ediff_rank_BLA.txt';
my $hybrid_energy;
my $DNA_energy;
my $energy_difference;
my $geneRank;
my $sgRNAScore;
my $sequence;
my $count = 0;

open (my $read_hybrid_file, '<:encoding(UTF-8)', $hybrid_file)
  or die "Could not open file '$hybrid_file' $!";

open (my $read_DNA_file, '<:encoding(UTF-8)', $DNA_file)
  or die "Could not open file '$DNA_file' $!";

open(my $filestream, '>', $filetowrite) or die "Could not open file '$filetowrite' $!";
print $filestream "delta_e\tsgScore\tgeneRank\n";

while ((my $hybrid_row = <$read_hybrid_file>) and (my $DNA_row = <$read_DNA_file>)) {

  if ($hybrid_row=~m/^([ATGCU]+-[ATGCU]+)/){
    $sequence = $1;
  }

  if ($hybrid_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/){
    $hybrid_energy = $4;
    $geneRank = $5;
    $sgRNAScore = $6;
    print "$hybrid_energy\n";
  }

  if ($DNA_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/){
    $DNA_energy = $4;
    print "$DNA_energy\n";
    $energy_difference = $hybrid_energy-$DNA_energy;
    #if ($geneRank > 0.8) {
      printf $filestream "%.2f", "$energy_difference";
      printf $filestream "\t";
      printf $filestream "%.3f", "$sgRNAScore";
      printf $filestream "\t";
      printf $filestream "%.3f", "$geneRank";
      printf $filestream "\t";
      printf $filestream "$sequence";
      printf $filestream "\n";
      print "energy difference: $energy_difference sgRNAScore: $sgRNAScore geneRank: $geneRank\n";
      $count += 1;
    #}
  }

}
close $read_hybrid_file;
close $read_DNA_file;
close $filestream;
print "calculated $count sequences";
