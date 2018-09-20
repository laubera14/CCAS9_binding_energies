# CCAS9_binding_energies

This program calculates the binding free energy of 2 complementary RNA-DNA/DNA-DNA strands.

In this case it is specifically a sgRNA of CRISPR/CAS9 which invades the DNA Helix to build a R-loop
as the CAS9 protein needs the sgRNA to be in bound state to the complementary DNA in order to
cleave the DNA strand.

The scripts rely on the program RNAduplex of the ViennaRNA package AND the additional 
ViennaRNA package 2.1.9h which provides the possibility to calculate free energy of pure DNA-DNA
strands.

All Scripts need a Fasta file as input.

Regex configuration is programmed to read specific Fasta files created from the data published 
by Doench et al. 2014 ("Rational design of highly active sgRNAs for CRISPR-Cas9–mediated gene 
inactivation"). They are provided whithin this program.
