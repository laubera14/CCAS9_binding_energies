#!/usr/bin/perl

use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;
use Data::Dumper;
use POSIX;

my $hybrid_file = 'RNADNA_extended_PAM.txt';
my $DNA_file = 'DNADNA_extended_PAM.txt';
my $filetowrite = 'binding_ediff_only_GPAM.txt';
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
print $filestream "delta_e\tsgScore\trank\tsequence\n";

while ((my $hybrid_row = <$read_hybrid_file>) and (my $DNA_row = <$read_DNA_file>)) {

  if ($hybrid_row=~m/^(.{20}G.{2}-.+)/){
    $sequence = $1;
    $hybrid_row = <$read_hybrid_file>;
    $DNA_row = <$read_DNA_file>;

    if ($hybrid_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
      $hybrid_energy = $4;
      $geneRank = $5;
      $sgRNAScore = $6;
      #print "$hybrid_energy\n";
    }
    #else {
    #  print "WARNING: Could not process sequence $count (Hybrid).";
    #}

    if ($DNA_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
      $DNA_energy = $4;
      #print "$DNA_energy\n";
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
        #print "energy difference: $energy_difference sgRNAScore: $sgRNAScore geneRank: $geneRank\n";
      $count += 1;
    }
    #else {
    #  print "WARNING: Could not process sequence $count (DNADNA).";
    #}
  }
  #else {
  #  print "WARNING: Could not process sequence $count (no_pos_20).";
  #}
}
close $read_hybrid_file;
close $read_DNA_file;
close $filestream;
print "calculated $count sequences";
