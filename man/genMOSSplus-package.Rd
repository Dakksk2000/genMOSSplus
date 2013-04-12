\name{genMOSSplus-package}
\Rdversion{1.0}
\alias{genMOSSplus-package}
\alias{genMOSSplus}
\docType{package}
\title{
Application of MOSS algorithm to dense SNP array data
}
\description{
The genMOSS package together with datafile preprocessing functions.

The MOSS algorithm is a Bayesian variable selection procedure that can be used for the analysis GWAS data. It identifies combinations of the best predictive SNPs associated with the response. It also performs a hierarchical log-linear model search to identify the most relevant associations among the resulting subsets of SNPs. The prior used is the generalized hyper Dirichlet.

Includes preprocessing of the data from Plink format to the format required by the MOSS algorithm, as well as other data-file manipulation functions that may be useful.
}
\details{
\tabular{ll}{
Package: \tab genMOSSplus\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2013-06-12\cr
License: \tab GPL-2\cr
LazyLoad: \tab yes\cr
}

System Requirements:
\preformatted{
 * Linux
 * MaCH software (http://www.sph.umich.edu/csg/abecasis/MACH/download/)
}


The package consists of four groups of files: preprocessing functions, fine-tuning function, main \acronym{MOSS} functions, and helper functions. The name of the the first two groups of functions begins with "pre" and "tune", respectively. The main function is either beginning with "run" or original 'MOSS.GWAS' (from genMOSS package), whichever input format is more convenient. The preprocessing ("pre") functions are necessary for converting data from Plink format to required binary \acronym{MOSS} format. The main \acronym{MOSS} function is needed to carry out the MOSS search, it also has an option to use model averaging to construct a classifier for predicting the response and to assess its capability via k-fold cross validation. The helper functions are available for user's convenience to check things out for their datasets. We describe basic steps for "pre" and "tune" functions below.

\preformatted{
Preprocessing Functions
-----------------------
}


The preprocessing step converts data from Plink format (\code{\link{ex2plink}} describes the Plink format) to the format required by the \acronym{MOSS} algorithm. Frequently, geno data has missing values, for their imputation we use \acronym{MaCH} software (\url{http://www.sph.umich.edu/csg/abecasis/MACH/download/}). This imputation may require to run \acronym{MaCH} algorithm on one chromosome at a time, thus all preprocessing steps deal with multiple files: one for each chromosome. There is a total of 9 preprocessing steps that should be run in their proper order (the names of these functions begin with "pre" followed by the sequence number, followed by short description of what it does). Thus the number of intermediate files generated will be very large, for which good organization of files into directories is necessary. It is recommended to use the directory structure of the format created by \code{\link{pre0.dir.create}}. 


Almost every preprocessing function has two versions: normal mode and batch mode. In normal mode, users are requested to provide input and output directory names, full names of the required files, and some other additional parameters specific to the task. Whereas the batch mode is designed to run the function for ALL the files in the input directory that satisfy a naming criterion. This batch mode saves the user from having to call the same function 22-25 times for each chromosome. The naming criterion is as follows:

\preformatted{
 * prefix - The beginning string of the file name up until the chromosome number. 
     Here the assumption is that when a dataset is split into 22-25 files, 
     one chromosome in each, then the beginning of the file name is usually the
     same, followed by the chromosome number.
     E.x. Files with names:
        ~ "geno.data_chr1.my.ped"
        ~ "geno.data_chr2.my.ped"
        ~ "geno.data_chr3.my.ped"
          ...
        ~ "geno.data_chr22.my.ped"
     They all share the same beginning string:
        "geno.data_chr" - this is the 'prefix' for the above example.
        Note that it must be immediately followed by chromosome number.
	Also the chromosome number is expected to be a 1- or 2-digit number.
        Rename all X, Y, M, etc, to some 2-digit number.

 * key - Any string that appears in the file name. In case that the input directory
     contains files that begin with the same prefix, but should not be processed
     by the function, this parameter gives additional flexibility to filter 
     such files out.
     E.x. Suppose input directory contains the following files:
        ~ "geno.data_1.CASE.ped"
        ~ "geno.data_2.CASE.ped"
          ...
        ~ "geno.data_22.CASE.ped"
        ~ "geno.data_1.CONTROL.ped"
        ~ "geno.data_2.CONTROL.ped"
          ...
        ~ "geno.data_22.CONTROL.ped"
        ~ "geno.data_1.short_try.ped"
     First note that they all have the same prefix = "geno.data_".
     Now if you wish to specify that only CASE files should be processed,
     set key="CASE" - this will ignore all CONTROL files. Also it will ignore all 
     those testing files like "geno.data_1.short_try.ped", which might have
     been manually created by users for testing purposes.
     Note: this key is usually optional: if the input directory contains ONLY the
     files that need to be processed, then key can be set to an empty string "".

 * ending - A string that appears at the end of the file name. Normally this does
     not have to be the filename extension, unless specifically stated. The ending
     should not include chromosome number. If preprocessing functions are run in
     their proper order, then the suggested default values for endings in the 
     preprocessing functions should apply.
     Ex. 
        ~ "geno.data_1.CASE.ped" - ".ped" or "d" or "CASE.ped" or "E.ped", etc.
        ~ "geno.data_2.CASE" - "CASE" or ".CASE" or "" or "E" or "SE", etc.
        ~ "geno.data_15.CONTROL.dat" - ".dat" or "t" or "CONTROL.dat", etc.

 * Note: it is preferable to name files such that they have a filename extension,
    Ex.
        ~ good: "geno.data_1.CASE.ped";  bad: "geno.data_1.CASE"
        ~ good: "CGEM.chr11CONTROL.dat"; bad: "CGEM.chr11CONTROL"
   Sometimes preprocessing functions name their output functions by slightly 
   modifying the name of the input file. When this is done, filename extension
   is usually removed. For example, suppose function wants to add word 
   "_cleaned.txt" to the end of your filename "CGEM.chr_12CONTROL.ped"
   Resultant filename would be: "CGEM.chr_12CONTROL_cleaned.txt", 
   since ".ped" will be identified as filename extension and will be lost.

   Consider what happens if you are not using filename extensions:
   then filename "CGEM.chr_12CONTROL" will be renamed as "CGEM_cleaned.txt",
   since the entire ".chr_12CONTROL" will be identified as file name extension,
   but it contains valuable chromosome information that will be lost.

   Thus always use file name extensions: ".ped", ".dat", ".txt", ".map", etc.
}  

It is recommended to run the preprocessing functions in the following order:

\preformatted{

 * pre0.dir.create - creates a set of empty directories d0 to d11. 
 * get.file.copy - copy original format files to dir d0.
 * ex2plink - modify this function, or write something similar to 
                      convert your format into Plink, this may involve
                      splitting dataset into multiple files: one per 
                      chromosome; place the result into dir d1.
 * pre1.plink2mach.batch - converts Plink format to MaCH's input format,
                      which splits each chromosome into CASE and CONTROL
                      files; store result into dir d2.
 * pre2.remove.genos.batch - remove all SNPs that have too many missing 
                      values, store result into dir d3.
 * pre3.call.mach.batch - imputes missing values using MaCH1, store
                      results in dir d5 (current version does not use d4).
 * pre4.combine.case.control.batch - combines CASE and CONTROL files,
                      place result into dir d6.
 * prie5.genos2numeric.batch - convert data from "A/G", "C/T", "G/G", etc
                      format to 3 levels: 1, 2, 3; store into dir d7.
 * pre6.merge.genos - merges all files across all chromosomes into one,
                      result should go into dir d8.
 * pre7.add.comf.var.unix - add a confounding variable (if any) to the 
                      dataset, result should go to d9.
 * pre8.split.train.test.batch - split the full dataset into train and 
                      test files; save the result into d10. 
 * tune1.subsets - impute dense map of SNPs on a small region within a
                      chromosome, results go to d11.
}

\preformatted{
MOSS Functions
---------------
}


After the preprocessing steps are complete, from directories d8-d11, run the main MOSS algorithm, use either of two functions: MOSS.GWAS (from genMOSS package), or run1.moss that allows different input. The functions do not output any files, so no output directory is needed.

To see the functionality of preprocessing and MOSS algorithm, try running:


demo("gendemo")

}
\author{
Authors: Olga Vesselova, Matthew Friedlander, Laurent Briollais, Adrian Dobra, Helene Massam.

Maintainer: <laurent@lunenfeld.ca> 
}
\references{
\cite{Massam, H., Liu, J. and Dobra, A. (2009). A conjugate prior for discrete hierarchical log-linear models. Annals of Statistics, 37, 3431-3467.i}

\cite{Dobra, A., Briollais, L., Jarjanazi, H., Ozcelic, H. and Massam, H. (2008). Applications of the mode oriented stochastic search (MOSS) agorithm for discrete multi-way data to genomewide studies. Bayesian Modelling in Bioinformatics (D. Dey, S. Ghosh and B. Mallick, eds.), Taylor & Francis. To appear.}

\cite{Dobra, A. and Massam, H. (2010). The mode oriented stochastic search (MOSS) algorithm for log-linear models with conjugate priors. Statistical Methodology, 7, 240-253.}

}
\keyword{htest}
\keyword{models}
\examples{
m <- as.data.frame(matrix(round(runif(100)), 5))
write.table(m, file="randbinary.txt", col.names=FALSE, row.names=FALSE, quote=FALSE, sep="\t")
run1.moss(filename="randbinary.txt", replicates=1, maxVars=3, k=2)
try(system("rm randbinary.txt*"))
}
