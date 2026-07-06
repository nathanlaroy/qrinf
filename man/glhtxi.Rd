\name{glhtxi}
\alias{glhtxi}
%- Also NEED an '\alias' for EACH other topic documented here.
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
  \item{taus}{
  A \eqn{1\times m} vector (i.e., row vector) of ordered quantile criteria in the open interval \eqn{(0,1)}.
}
  \item{form}{
  An object of class "[formula]".
}
  \item{data}{
  An object of class "[data.frame]".
}
  \item{R}{
  A \eqn{q\times m(p+1)} restriction matrix to pre-multiply the coefficient vector, \eqn{\xi}.
}
  \item{r}{
  A \eqn{q\times 1} null identity vector (i.e., column vector).
}
  \item{se}{
  A character string determining the type of standard errors used for the quantile regression model.
  Options are `"iid"`, `"nid"`, `"boot"`, `"ker"` and `"extreme"`. Defaults to `"nid"`.
  See \link[quantreg]{summary.rq} for more information.
}
  \item{\dots}{
  Optional arguments to rq.
}
}
\details{
Dimensions checks are performed on `R` and `r`, such that \eqn{R\xi-r} is a legal matrix operation.
\eqn{\xi} is constructed under the hood based on the `form` argument.
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
  The degrees of freedom of the appropriate asymptotic \eqn{\chi^2_q}-distribution (i.e., the rank of `R`).
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
