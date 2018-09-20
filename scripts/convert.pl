#converts Sequences from an Excel sheet into a Fasta file

#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use Bio::Seq; #uses bioperl modules
use Bio::SeqIO;
use Spreadsheet::Read qw(ReadData); #uses Spreadsheet module to read xls file

my $inputFile = ReadData ('../source/nbt.3026-S5.xls'); # <- specify input file name here
my $outputFile = '../source/sequences_extended.fasta'; # <- specify the output file here
my @rows = Spreadsheet::Read::rows($inputFile->[1]); #Takes Excel cells into array
my $i = 3;
my $inseq = "";
my $sequences = "";


#create a string to handle
#After ">" the following rows specify what will be part of the
#description of every Sequence in the Fasta file.
#The row after "\n" specifies the sequence itself
for $i (3 .. scalar @rows) { # <- maybe change syntax?
  $sequences = $sequences . ">" . "$rows[$i-1][5]_" . "$rows[$i-1][2]_"
                                . "$rows[$i-1][6]_" . "$rows[$i-1][7]_"
                                . $rows[$i-1][8] .   "\n"
                                . $rows[$i-1][1] . "\n";
}

my $seq_in = Bio::SeqIO->new( -string => $sequences,
                              -format => "fasta"); #Takes strings into stream
my $seq_out = Bio::SeqIO->new( -file   => ">$outputFile",
                              -format => "fasta"); # <-chose output format

#write the string into a fasta file
while ($inseq = $seq_in->next_seq) {
  $seq_out->write_seq($inseq);
}
