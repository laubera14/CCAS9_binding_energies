#!/usr/bin/perl

use strict;
use warnings;

my $PAM_file = "PAM_energy_difference_Iman2.txt";
my $energy_difference;
my $sequence;
my $energy_sum = 0;
my $count = 0;
my $mean_energy;

open (my $read_PAM_file, '<:encoding(UTF-8)', $PAM_file)
  or die "Could not open file $PAM_file $!";

while (defined(my $PAM_file_row = <$read_PAM_file>)){

  if ($PAM_file_row=~m/^(-\d+\.\d+)\s+(.{20}.GGU)/){
    $energy_difference = $1;
    $sequence = $2;

    $energy_sum += $energy_difference;
    print "$sequence\n";
    $count += 1;
  }
}
close ($read_PAM_file);
$mean_energy = $energy_sum/$count;
print "$mean_energy\n";
