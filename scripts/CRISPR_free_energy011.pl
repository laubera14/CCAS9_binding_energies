#!/usr/bin/perl

use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;
use Data::Dumper; #why?
use POSIX; #why?

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
my $count = 0; #To display count of calculated sequences
my $seqio_obj = Bio::SeqIO->new(-file => "sequences.fasta", #specify source file here
                                -format => "fasta");
my $filetowrite_DNA_duplex = 'DNADNA_3prime_T.txt'; #specify where free energy values should be written
my $filetowrite_hybrid_duplex = 'RNADNA_3prime_T.txt'; #specify where free energy values should be written
my $filetowrite_energy_difference = 'binding_ediff_rank_3prime_T.txt'; #specify where energy differences should be written
my $s_5prime = 18; #specify how many bases should be shorten from 5'-End

#DNA-DNA-duplex part begins here. free energy for it will be calculated and
#written to the file specified above
open(my $filestream, '>', $filetowrite_DNA_duplex) or die "Could not create file '$filetowrite_DNA_duplex' $!";

while (my $seq_obj = $seqio_obj->next_seq){
  my $reversed_obj = $seq_obj->revcom; #create complementary strand
  my $fasta_header = $seq_obj->primary_id."\n"; #looks for next Sequence information in file

#following regex part extracts information from FASTA header
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

  my $s1 = $seq_obj->seq;
  my $s2 = $reversed_obj->seq;

  $s1 =~ s/^.{\$s_5prime}//;
  $s2 =~ s/.{\$s_5prime}$//;

  print $filestream "$s1-$s2\n";
  #print "$s1-$s2\n";

  my $cmd = "echo '$s1\n$s2' | ~/ViennaRNA-2.1.9/bin/RNAduplex -P ~/ViennBaRNA-2.1.9/share/ViennaRNA/dna_mathews2004.par --noconv";

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

#Hybrid-duplex part begins here. free energy for it will be calculated and
#written to the file specified above
$s1 =~ tr/T/U/;
$count += 1;
}
close $filestream;
print "succesfully wrote data of $count sequences to file: $filetowrite_DNA_duplex and $filetowrite_hybrid_duplex\n";

#Hybrid-duplex part begins here. free energy for it will be calculated and
#written to the file specified above
$count = 0;

open($filestream, '>', $filetowrite_hybrid_duplex) or die "Could not create file '$filetowrite_hybrid_duplex' $!";

while (my $seq_obj = $seqio_obj->next_seq){
  my $reversed_obj = $seq_obj->revcom;
  my $fasta_header = $seq_obj->primary_id."\n";

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
  $s1 =~ tr/T/U/;

  $s1 =~ s/^.{\$s_5prime}//;
  $s2 =~ s/.{\$s_5prime}$//;

  print $filestream "$s1-$s2\n";
  #print "$s1-$s2\n";

  my $cmd = "echo '$s1\n$s2' | RNAduplex --noconv";

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
print "succesfully wrote data of $count hybrid sequences to file: $filetowrite_hybrid_duplex\n";

#now the energy difference from both the DNA duplex and the hybrid duplex sequences
#stored in the two files is calculated and written to the file specified at the beginning
$count = 0;
my $hybrid_file = $filetowrite_hybrid_duplex;
my $DNA_file = $filetowrite_DNA_duplex;
my $hybrid_energy;
my $DNA_energy;
my $energy_difference;

open (my $read_hybrid_file, '<:encoding(UTF-8)', $hybrid_file)
  or die "Could not open file '$hybrid_file' $!";

open (my $read_DNA_file, '<:encoding(UTF-8)', $DNA_file)
  or die "Could not open file '$DNA_file' $!";

open($filestream, '>', $filetowrite_energy_difference) or die "Could not open file '$filetowrite_energy_difference' $!";
print $filestream "delta_e\tsgScore\tgeneRank\n";

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
    $energy_difference = $hybrid_energy-$DNA_energy;
    #if ($geneRank > 0.8) {
      printf $filestream "%.2f", "$energy_difference";
      printf $filestream "\t";
      printf $filestream "%.3f", "$sgRNAScore";
      printf $filestream "\t";
      printf $filestream "%.3f", "$geneRank";
      printf $filestream "\n";
      print "energy difference: $energy_difference sgRNAScore: $sgRNAScore geneRank: $geneRank\n";
      $count += 1;
    #}
  }

}
close $read_hybrid_file;
close $read_DNA_file;
close $filestream;
print "calculated $count sequences\n";
