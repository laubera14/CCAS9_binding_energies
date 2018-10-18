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

for (my $round = 0; $s_5prime <= 24; $round++){
$count = 0;
$s_5prime = $s_5prime_initial + $round;
#$s_3prime = $s_3prime_initial + $round;

#DNA-DNA-duplex part begins here. free energy for it will be calculated and
#written to the file specified above
open(my $filestream, '>', $filetowrite_DNA_duplex) or die "Could not create file '$filetowrite_DNA_duplex' $!";

print "calculating DNA duplex free energy";
while (my $seq_obj = $seqio_obj->next_seq){
  my $reversed_obj = $seq_obj->revcom; #create complementary strand
  my $fasta_header = $seq_obj->primary_id."\n"; #looks for next Sequence information in file

#following regex part extracts information from FASTA header
  if ($fasta_header=~m/^([a-zA-Z0-9]+)\_(\d+)\_([a-z]+)\_(\d+\.\d+|0)\_(\d+\.\d+)/){
    $transcript = $1;
    $geneRank = $4;
    $sgRNAScore = $5;

  }
  else {
    print $fasta_header; die "Cannot parse Fasta header";
  }

  my $s1 = $seq_obj->seq;
  my $s2 = $reversed_obj->seq;

  $s1 =~ s/^.{$s_5prime}//;
  $s1 =~ s/.{$s_3prime}$//;
  $s2 =~ s/.{$s_5prime}$//;
  $s2 =~ s/^.{$s_3prime}//;

  print $filestream "$s1-$s2\n";
  #print "$s1-$s2\n";

  my $cmd = "echo '$s1\n$s2' | ~/ViennaRNA-2.1.9/bin/RNAduplex -P ~/ViennaRNA-2.1.9/share/ViennaRNA/dna_mathews2004.par --noconv 2>/dev/null";

  open(DUPLEX, $cmd."|");
  while(<DUPLEX>){
    if($_=~m/^([\.()]+)\&([()\.]+)\s+(\d+\,\d+)\s+(.)\s+(\d+\,\d+)\s+\(([-?\s]\d+\.\d+)\)/){
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

print $filestream "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy $geneRank $sgRNAScore\n\n";
#print "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy $geneRank $sgRNAScore\n";
print ".";
$count += 1;
}
close $filestream;
seek($seqio_obj->_fh, 0, 0);
print "succesfully wrote data of $count sequences to file: $filetowrite_DNA_duplex\n";


#Hybrid-duplex part begins here. free energy for it will be calculated and
#written to the file specified above
$count = 0;

open($filestream, '>', $filetowrite_hybrid_duplex) or die "Could not create file '$filetowrite_hybrid_duplex' $!";

print "calculating DNA RNA hybrid free energy";
while (my $seq_obj = $seqio_obj->next_seq){
  my $reversed_obj = $seq_obj->revcom;
  my $fasta_header = $seq_obj->primary_id."\n";

  if ($fasta_header=~m/^([a-zA-Z0-9]+)\_(\d+)\_([a-z]+)\_(\d+\.\d+|0)\_(\d+\.\d+)/){
    $transcript = $1;
    $geneRank = $4;
    $sgRNAScore = $5;

  }
  else {
    print $fasta_header; die "Cannot parse Fasta header";
  }

  my $s1 = $seq_obj->seq;
  my $s2 = $reversed_obj->seq;
  $s1 =~ tr/T/U/;

  $s1 =~ s/^.{$s_5prime}//;
  $s1 =~ s/.{$s_3prime}$//;
  $s2 =~ s/.{$s_5prime}$//;
  $s2 =~ s/^.{$s_3prime}//;

  print $filestream "$s1-$s2\n";
  #print "$s1-$s2\n";

  my $cmd = "echo '$s1\n$s2' | ~/ViennaRNA-2.1.9h/bin/RNAduplex --noconv 2>/dev/null";

  open(DUPLEX, $cmd."|");
  while(<DUPLEX>){
    if($_=~m/^([\.()]+)\&([()\.]+)\s+(\d+\,\d+)\s+(.)\s+(\d+\,\d+)\s+\(([-?\s]\d+\.\d+)\)/){
      $duplex1 = $1;
      $duplex2 = $2;
      $startstopseq1 = $3;
      $startstopseq2 = $5;
      $energy = $6;
    }
    else {
      print $_;
      die "cannot parse anymore_";
    }
  }
close(DUPLEX);

print $filestream "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy $geneRank $sgRNAScore\n\n";
#print "$duplex1-$duplex2 $startstopseq1 $startstopseq2 $energy $geneRank $sgRNAScore\n";
print ".";
$count += 1;
}
close $filestream;
seek($seqio_obj->_fh, 0, 0);
print "succesfully wrote data of $count hybrid sequences to file: $filetowrite_hybrid_duplex\n";


#now the energy difference from both the DNA duplex and the hybrid duplex sequences
#stored in the two files is calculated and written to the file specified above
$count = 0;
my $hybrid_file = $filetowrite_hybrid_duplex;
my $DNA_file = $filetowrite_DNA_duplex;
my $nt_count_5prime = $s_5prime - 3;
my $nt_count_3prime = 26 - $s_3prime;
my $filetowrite_energy_difference = "../output/binding_ediff_$nt_count_5prime-$nt_count_3prime.txt"; #specify where energy differences should be written
my $hybrid_energy;
my $DNA_energy;
my $energy_difference;
my $sequence;

open (my $read_hybrid_file, '<:encoding(UTF-8)', $hybrid_file)
  or die "Could not open file '$hybrid_file' $!";

open (my $read_DNA_file, '<:encoding(UTF-8)', $DNA_file)
  or die "Could not open file '$DNA_file' $!";

open($filestream, '>', $filetowrite_energy_difference) or die "Could not write file '$filetowrite_energy_difference' $!";
print $filestream "delta_e\tsgScore\trank\tsequence\n";

while (defined(my $hybrid_row = <$read_hybrid_file>) and defined(my $DNA_row = <$read_DNA_file>)){
  if ($hybrid_row=~m/^([ATGCU]+-[ATGCU]+)/){
    $sequence = $1;
    $hybrid_row = <$read_hybrid_file>;
    $DNA_row = <$read_DNA_file>;
  }

  if ($hybrid_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $hybrid_energy = $4;
    $geneRank = $5;
    $sgRNAScore = $6;
  }

  if ($DNA_row=~m/^(.+)\s+(\d+\,\d+)\s+(\d+\,\d+)\s+(-?\d+\.\d+)\s+(\d+\.\d+|0)\s+(\d+\.\d+)/){
    $DNA_energy = $4;
    $energy_difference = ($hybrid_energy-$DNA_energy);
      printf $filestream "%.3f", "$energy_difference";
      printf $filestream "\t";
      printf $filestream "%.3f", "$sgRNAScore";
      printf $filestream "\t";
      printf $filestream "%.3f", "$geneRank";
      printf $filestream "\t";
      printf $filestream "$sequence";
      printf $filestream "\n";
    $count += 1;
    $hybrid_row = <$read_hybrid_file>;
    $DNA_row = <$read_DNA_file>;
  }

}
close $read_hybrid_file;
close $read_DNA_file;
close $filestream;
print "calculated free energy difference of $count sequences and wrote to file $filetowrite_energy_difference\n";
}
