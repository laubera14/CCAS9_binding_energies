# CCAS9_binding_energies

This collection of scripts calculates the binding free energy difference of 2 complementary 
RNA-DNA/DNA-DNA strands (Perl scripts) and finds correlations (R scripts) between this data
and the data provided by Doench et al. 2014 ("Rational design of highly active sgRNAs for
CRISPR-Cas9–mediated gene inactivation"). It is part of my Bachelor Thesis ("Suitability of
a free energy based model for in silico prediction of CRISPR/CAS9 sgRNA cleavage efficiency").

The complementary RNA-DNA/DNA-DNA strands are in this case  a sgRNA of CRISPR/CAS9 which invades 
the DNA Helix to build a R-loop as the CAS9 protein needs the sgRNA to be in bound state to the 
complementary DNA in order to cleave the DNA strand.

The Perl scripts rely on the program RNAduplex of the ViennaRNA package AND the additional 
ViennaRNA package 2.1.9h which provides the possibility to calculate free energy of pure DNA-DNA
strands. Further the handling of sequences (reading/writing) is supported by the Bioperl package.
All Perl scripts need a Fasta file to read in. They are created by the convert script using the
data tables of Doench et al. 2014 as input.

The R scripts can be ran with just the basic R environment except the heat_maps script.
The heat_maps script requires additionally the reshape2 package to reformat the matrix data
and the package ggplot2 which visualizes the matrices as a heat map.
