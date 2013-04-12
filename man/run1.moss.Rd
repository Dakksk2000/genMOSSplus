\name{run1.moss}
\Rdversion{1.1}
\alias{run1.moss}
\title{
Runs MOSS regression algorithm
}
\description{
The MOSS algorithm is a Bayesian variable selection procedure that is applicable to GWAS data. It identifies combinations of the best predictive SNPs associated with the response. It also performs a hierarchical log-linear model search to identify the most relevant associations among the resulting subsets of SNPs.
}
\usage{
run1.moss(filename, alpha = 1, c = 0.1, cPrime = 1e-04, q = 0.1, 
replicates = 5, maxVars = 3, dimens = NULL, k = 2)
}
\arguments{
  \item{filename}{
	The input file that contains the genotype information for a given set of SNPs together with the binary outcome. The data should be organized such that each row refers to a subject and each column to a SNP. The SNP data need not be binary. The last column is interpreted as the case / control status of each subject and must be binary.
}
  \item{alpha}{
	A hyperparameter of the Diaconis-Ylvisaker prior. The other hyperparameters are the margins of a fictive contingency table which we assume to have counts equal to the number of cells divided by \code{\var{alpha}}. \code{\var{Alpha}} must be a positive real number.
}
  \item{c}{
	Tuning parameter for the MOSS algorithm. Must be a real number between 0 and 1, and \code{\var{c}} must be larger than \code{\var{cPrime}}.
}
  \item{cPrime}{
	Tuning parameter for the MOSS algorithm. Must be a real number between 0 and 1, and \code{\var{cPrime}} must be smaller than \code{\var{c}}.
}
  \item{q}{
	Tuning parameter for the MOSS algorithm. Must be a real number between 0 and 1.
}
  \item{replicates}{
	The number of instances the \acronym{MOSS} algorithm will be run.
}
  \item{maxVars}{
	The maximum number of variables allowed in a regression (including the response). Must be an integer between 3 and 6.
}
  \item{dimens}{
	The number of possible values for each column of data. Each possible value does not need to occur in data. Since the last column of data must be binary, the last entry of dimens must be 2. All other entries of dimens must be greater than or equal to 2. If dimens==NULL, the dimens vector will be automatically built, with all values equal to the largest number of possible values in a column, and the last entry of dimens equal to 2.  
}
  \item{k}{
	The fold of the cross validation. If k is NULL then no cross validation is performed.
}
}
\value{
A list with 4 data frame elements:
\item{topRegressions}{The top regressions identified together with their log marginal likelihood and normalized posterior probability.}
\item{postIncProbs}{The posterior inclusion probabilities of each variable that appears in one of the top regressions.}
\item{interactionModels}{The best (in terms of marginal likelihood) hierarchical log-linear model containing the variables in each of the top regressions.}
\item{crossValidation}{A table with the average results of the cross validation. This table is typically called a confusion matrix.}

}
\references{
Massam, H., Liu, J. and Dobra, A. (2009). A conjugate prior for discrete hierarchical log-linear models. Annals of Statistics, 37, 3431-3467.

  Dobra, A., Briollais, L., Jarjanazi, H., Ozcelik, H. and Massam, H. (2010). Applications of the mode oriented stochastic search (MOSS) algorithm for discrete multi-way data to genomewide studies. Bayesian Modeling in Bioinformatics, Taylor & Francis (D. Dey, S. Ghosh and B. Mallick, eds.), 63-93.

  Dobra, A. and Massam, H. (2010). The mode oriented stochastic search (MOSS) algorithm for log-linear models with conjugate priors. Statistical Methodology, 7, 240-253.
}
\author{
Olga Vesselova, Matthew Friedlander and Laurent Briollais
}
\note{
This function makes use of the MOSS.GWAS function from genMOSS package. Use whichever input variables are more convenient.
}

\examples{
# see demo  

}
