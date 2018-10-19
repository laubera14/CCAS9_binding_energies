#!~/perl5

use strict;
use warnings;
use Bio::Perl; #bioperl base module
use Bio::SeqIO; #bioperl filehandler module

my $transcript;
my $geneRank;
my $sgRNAScore;
my $duplex1;
my $duplex2;
my $startstopseq1;
my $startstopseq2;
my $energy;
my $count = 0; #To display count of calculated sequences
my $seqio_obj = Bio::SeqIO->new(-file => "../source/sequences_extended.fasta", #specify source file here
                                -format => "fasta");
my $filetowrite_DNA_duplex = '../output/temp/DNA_duplex.txt'; #specify where free energy values should be written
my $filetowrite_hybrid_duplex = '../output/temp/hybrid_duplex.txt'; #specify where free energy values should be written
my $s_5prime_initial = 4; #specify how many bases should be cut away from 5'-End (4nt-gRNA-PAM)
my $s_3prime_initial = 3; #specify how many bases should be cut away from 3'-End (gRNA-PAM-3nt)
my $s_5prime = $s_5prime_initial;
my $s_3prime = $s_3prime_initial;
#my @factors = (1.491805e-02, 7.767365e-02, 4.822556e-01, 3.660851e-01, 4.057373e-02, 1.660886e-02,
#               1.165373e-03, 1.608788e-04, 3.252357e-04, 2.047235e-04, 2.505430e-05, 2.729154e-06,
#               2.237243e-07, 2.527611e-07, 1.195666e-07, 6.182247e-08, 1.658470e-07, 1.161370e-07,
#               4.531659e-10, 1.274020e-10);

#my @factors = (1, 1, 1, 1, 1, 1,
#               1, 1, 1, 1, 1, 1,
#               1, 1, 1, 1, 1, 1,
#               1, 1);
for (my $master_round = 0; $s_3prime < 23; $master_round++){
  $s_3prime = $s_3prime_initial + $master_round;
  $s_5prime = $s_5prime_initial;
  print "3-prime: $s_3prime\n";
for (my $round = 0; $s_5prime < 24-$master_round; $round++){
$count = 0;
$s_5prime = $s_5prime_initial + $round;
print "5-prime: $s_5prime\n";

}

}
