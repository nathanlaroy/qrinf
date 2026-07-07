\name{glhtprocess}
\alias{glhtprocess}
\title{
General Linear Hypothesis Tests On QR Processes
}
\description{
The function carries out a general linear hypothesis test for a quantile regression model
regarding the null hypothesis \eqn{H_0: R\beta(\tau)=r(\tau)}, for \eqn{\tau\in[\pi_0, \pi_1]\subsetneq(0,1)}.
}
\usage{
glhtprocess(taus, form, data, R, r, griddensity = 300, se = "nid", ...)
}
\arguments{
  \item{taus}{A vector of length 2 containing the lower and upper bound of the closed sub-interval \eqn{[\pi_0, \pi_1]\subsetneq (0,1)}
  of quantile criteria of the quantile regression process to which the general linear hypothesis test pertains.}
  \item{form}{An object of class \link[stats]{formula}.}
  \item{data}{An object of class \link[base]{data.frame}.}
  \item{R}{A \eqn{q\times m(p+1)} restriction matrix to pre-multiply the coefficient vector.}
  \item{r}{A \eqn{q\times 1} null identity vector, such that \eqn{H_0: R\beta(\tau)=r(\tau)}.}
  \item{griddensity}{An integer representing the number of equidistant quantile criteria to consider
  in the interval defined by `taus`. Default is `300`.}
  \item{se}{A character string determining the type of standard errors used for the quantile regression model.
  Options are \code{"iid"}, \code{"nid"}, \code{"boot"}, \code{"ker"} and \code{"extreme"}. Defaults to \code{"nid"}. 
  See \link[quantreg]{summary.rq} for more information.}
  \item{\dots}{Optional arguments to rq.}
}
\details{
Dimensionality checks are performed on \code{R} and \code{r}, verifying that \eqn{R\beta(\tau)-r(\tau)} is a legal matrix operation.\n

Critical values are determined based on \eqn{\lamdba=\pi_1(1-\pi_0)/(\tau_0(1-\tau_1))} and retrieved from tabled values. If \eqn{\lambda}
does not appear in the table, the appropriate critical value is approximated by linear interpolation.
}
\value{
  A list containing the following elements.
  \item{R}{
  The restriction matrix of the general linear hypothesis.
  }
  \item{lambda}{
  The value for \eqn{\lambda} which determines the appropriate critical value of the general linear hypothesis test.
  }
  \item{q}{
  The degrees of freedom of the appropriate asymptotic Bessel process.
  }
  \item{Tn}{
  The observed test statistic.
  }
  \item{critical.value}{
  The critical values associated with a 1\%, 5\%, and 10\% significance level.
  }
  \item{interpolated}{
  Boolean, was the critical value interpolated? FALSE if `lambda` appeared among the tabled values. 
  `NA` if rank of `R` exceeds 20.
  }
}
\references{
Koenker, R. (2005). Quantile regression. Cambridge University Press.
}
\author{
Nathan Laroy (\email{laroynathan@gmail.com})
}