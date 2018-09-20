#!/usr/bin/perl

use strict;
use warnings;

my $count = 0;
my $free_energy_file1 = "RNADNA_extended_12_18.txt";
my $free_energy_file2 = "RNADNA_extended_PAM.txt";
my $sum_free_energy_file_towrite = "RNADNA_extended_sum.txt";
my $free_energy1;
my $free_energy2;
my $energy_sum;
my $sequence;
my $geneRank;
my $sgRNAScore;

open (my $read_free_energy_file1, '<:encoding(UTF-8)', $free_energy_file1)
  or die "Could not open file '$free_energy_file1' $!";

open (my $read_free_energy_file2, '<:encoding(UTF-8)', $free_energy_file2)
  or die "Could not open file '$free_energy_file2' $!";

open(my $filestream, '>', $sum_free_energy_file_towrite) or die "Could not write file '$sum_free_energy_file_towrite' $!";
print $filestream "delta_e\tsgScore\trank\tsequence\n";

while (defined(my $free_energy1_row = <$read_free_energy_file1>) and defined(my $free_energy2_row = <$read_free_energy_file2>)) {

  if ($free_energy1_row=~m/^([ATGCU]+-[ATGCU]+)/){
    $sequence = $1;
  }

  if ($free_energy1_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $free_energy1 = $4;
    $geneRank = $5;
    $sgRNAScore = $6;
  }

  if ($free_energy2_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $free_energy2 = $4;
    $energy_sum = $free_energy1+$free_energy2;
      printf $filestream "%.2f", "$energy_sum";
      printf $filestream "\t";
      printf $filestream "%.3f", "$sgRNAScore";
      printf $filestream "\t";
      printf $filestream "%.3f", "$geneRank";
      printf $filestream "\t";
      printf $filestream "$sequence";
      printf $filestream "\n";
      $count += 1;
  }

}
close $read_free_energy_file1;
close $read_free_energy_file2;
close $filestream;
print "calculated free energy difference sum of $count sequences and wrote to file $sum_free_energy_file_towrite\n";
