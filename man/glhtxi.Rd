\name{glhtxi}
\alias{glhtxi}
\title{
General Linear Hypothesis Tests On QR Models
}
\description{
The function carries out a general linear hypothesis test on an \eqn{m(p+1)} quantile 
regression coefficient vector, \eqn{\xi}, of the form \eqn{H_0: R\xi = r}.
}
\usage{
glhtxi(taus, form, data, R, r, se = "nid", ...)
}
\arguments{
  \item{taus}{A \eqn{1\times m} vector (i.e., row vector) of ordered quantile criteria in the open interval \eqn{(0,1)}.}
  \item{form}{An object of class \link[stats]{formula}.}
  \item{data}{An object of class \link[base]{data.frame}.}
  \item{R}{A \eqn{q\times m(p+1)} restriction matrix to pre-multiply the coefficient vector, \eqn{\xi}.}
  \item{r}{A \eqn{q\times 1} null identity vector (i.e., column vector).}
  \item{se}{A character string determining the type of standard errors used for the quantile regression model.
  Options are \code{"iid"}, \code{"nid"}, \code{"ker"} and \code{"extreme"}. Defaults to \code{"nid"}.
  See \link[quantreg]{summary.rq} for more information.}
  \item{\dots}{Optional arguments to rq.}
}
\details{
\eqn{m} is the number of individual values of quantile criteria, \eqn{\tau}, considered (e.g., for \eqn{\tau\in\{0.25,0.50,0.75\}}, \eqn{m=3}).
\eqn{p} is the number of coefficients estimated for any given quantile criterion, excluding the intercept. \eqn{\xi} takes the following
form: \deqn{\xi = \left(\beta(\tau_i)',\dots,\beta(\tau_m)'\right)',} with \deqn{\beta(\tau_j) = \left(\beta_0(\tau_j),\dots,\beta_p(\tau_j)\right).}

Dimensionality checks are performed on \code{R} and \code{r}, verifying that \eqn{R\xi-r} is a legal matrix operation. Returns error if not.

For \code{se}, the option \code{"boot"} is not an option, because it disallows partitioning the asymptotic covariance estimate into
the inverse Hessian and the unscaled outer product of the gradient matrix (see \link[quantreg]{summary.rq}).
}
\value{
  A list containing the following items.
  \item{R}{
  The restriction matrix of the general linear hypothesis.
  }
  \item{H0}{
  The observed general linear identity (i.e., \eqn{R\hat\xi-r}).
  }
  \item{Tn}{
  The observed test statistic.
  }
  \item{q}{
  The degrees of freedom of the appropriate asymptotic \eqn{\chi^2_q}-distribution (i.e., the rank of \eqn{R}).
  }
  \item{p.value}{
  The p value of the associated test.
  }
}
\references{
Koenker, R. (2005). Quantile regression. Cambridge University Press.
}
\author{
Nathan Laroy (\email{laroynathan@gmail.com})
}
