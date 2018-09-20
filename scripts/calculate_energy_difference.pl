#!/usr/bin/perl

use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;

my $hybrid_file = 'A2DRNA219h.txt';
my $DNA_file = 'A3DNA.txt';
my $filetowrite = '1binding_ediff_new.txt';
my $hybrid_energy;
my $DNA_energy;
my $energy_difference;
my $geneRank;
my $sgRNAScore;
my $count = 0;

open (my $read_hybrid_file, '<:encoding(UTF-8)', $hybrid_file)
  or die "Could not open file '$hybrid_file' $!";

open (my $read_DNA_file, '<:encoding(UTF-8)', $DNA_file)
  or die "Could not open file '$DNA_file' $!";

open(my $filestream, '>', $filetowrite) or die "Could not open file '$filetowrite' $!";
print $filestream "delta_e\tsgRNAScore\n";

while ((my $hybrid_row = <$read_hybrid_file>) and (my $DNA_row = <$read_DNA_file>)) {

  if ($hybrid_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/){
    $hybrid_energy = $4;
    $geneRank = $5;
    $sgRNAScore = $6;
    print "$hybrid_energy\n";
  }

  if ($DNA_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/){
    $DNA_energy = $4;
    print "$DNA_energy\n";
    $energy_difference = $DNA_energy-$hybrid_energy;
    printf $filestream "%.2f", "$energy_difference";
    printf $filestream "\t";
    printf $filestream "%.3f", "$sgRNAScore";
    printf $filestream "\n";
    print "energy difference: $energy_difference sgRNAScore: $sgRNAScore\n";
    $count += 1;
  }

}
close $read_hybrid_file;
close $read_DNA_file;
close $filestream;
print "calculated $count sequences";
