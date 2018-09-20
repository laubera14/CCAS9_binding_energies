#!/usr/bin/perl

use strict;
use warnings;

my $count = 0;
my $gRNA_PAM_file = "RNADNA_extended_PAM_Iman.txt";
my $gRNA_file = "RNADNA_extended_1_20.txt";
my $filetowrite_energy_difference = "PAM_energy_difference_Iman.txt";
my $gRNA_PAM_energy;
my $gRNA_energy;
my $energy_difference;
my $sequence;

open (my $read_gRNA_PAM_file, '<:encoding(UTF-8)', $gRNA_PAM_file)
  or die "Could not open file '$gRNA_PAM_file' $!";

open (my $read_gRNA_file, '<:encoding(UTF-8)', $gRNA_file)
  or die "Could not open file '$gRNA_file' $!";

open(my $filestream, '>', $filetowrite_energy_difference) or die "Could not write file '$filetowrite_energy_difference' $!";
print $filestream "delta_e\tsequence\n";

while (defined(my $gRNA_PAM_row = <$read_gRNA_PAM_file>) and defined(my $gRNA_row = <$read_gRNA_file>)) {

  if ($gRNA_PAM_row=~m/^([ATGCU]+-[ATGCU]+)/){
    $sequence = $1;
  }

  if ($gRNA_PAM_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $gRNA_PAM_energy = $4;
  }

  if ($gRNA_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $gRNA_energy = $4;
    $energy_difference = $gRNA_PAM_energy-$gRNA_energy;
      printf $filestream "%.2f", "$energy_difference";
      printf $filestream "\t";
      printf $filestream "$sequence";
      printf $filestream "\n";
      $count += 1;
  }

}
close $read_gRNA_PAM_file;
close $read_gRNA_file;
close $filestream;
print "calculated free energy difference of $count sequences and wrote to file $filetowrite_energy_difference\n";
