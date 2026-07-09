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
  \item{r}{A \eqn{q\times 1} null identity vector, such that \eqn{H_0: R\beta(\tau)=r(\tau)}. Or, a function (see Details).}
  \item{griddensity}{An integer representing the number of equidistant quantile criteria to consider
  in the interval defined by `taus`. Default is `300`.}
  \item{se}{A character string determining the type of standard errors used for the quantile regression model.
  Options are \code{"iid"}, \code{"nid"}, \code{"boot"}, \code{"ker"} and \code{"extreme"}. Defaults to \code{"nid"}. 
  See \link[quantreg]{summary.rq} for more information.}
  \item{r.args}{If \code{r} is a function, additional arguments besides tau (see Details). Must be named.}
  \item{verbose}{Show warnings of negative density estimates. Defaults to \code{TRUE}.}
  \item{\dots}{Optional arguments to rq.}
}
\details{
Critical values are determined based on \eqn{\lambda=\pi_1(1-\pi_0)/(\tau_0(1-\tau_1))} and retrieved from tabled values from Estrella (2003). 
If \eqn{\lambda} does not appear in the table, the appropriate critical value is approximated by linear interpolation if \eqn{q<20}.
In the unlikely scenario that \eqn{q>20} or \eqn{\lambda\notin(1,361)}, warnings are produced to alert the user. In the latter case,
\eqn{\lambda} is internally set to the closest tabled integer.

When \code{verbose=TRUE}, the native non-positive density estimate warnings from \link[quantreg]{summary.rq} are made compact by 
summing the total number instances, instead of letting the numerous warnings amass from iterated calls to \link[quantreg]{summary.rq}. 
If no non-positive density estimates occurred, \code{verbose=TRUE} is ignored.

\code{r} is a null identity function of \eqn{\tau}, i.e., \eqn{H_0: \boldsymbol{R\beta}(\tau)=\boldsymbol{r}(\tau)}. The argument that
is passed can either be a vector of constants (e.g., \code{r = cbind(c(0, 0))}), or a function that minimally takes \eqn{\tau} as argument.
If \code{r} is a function, its first argument \emph{must} be \eqn{\tau}, even when the function of interest does not involve the parameter
\eqn{\tau}, for \code{glhtprocess} properly to work. Additional arguments should be passed as a \link[base]{list} to \code{r.args}. \code{tau}
should not be explicitly passed to \code{r.args}, it is internally assigned based on \code{taus} and \code{griddensity}. For example,
if one wishes to let \eqn{\boldsymbol{r}(\tau, k)=\Phi^{-1}(\tau)/k}, \eqn{\Phi^{-1}} the quantile function of a standard-normal variate,
then one should set \code{r=function(x,k)qnorm(x)/k}. If \code{k} is a constant (e.g., \eqn{k=2}), set \code{r.args=list(k=c)}. If any
of the elements in \code{r.args} are a vector (i.e., length greater than 1), it is assumed that the argument is not a constant,
but varies along with \eqn{\tau}. These arguments should be vectors of length equal to \code{griddensity} (if not, the provided vector
is recycled to the appropriate length). For example, suppose we want \eqn{\boldsymbol{r}(\tau, k)=\Phi^{-1}(\tau)/k + b/h}, then we set
\code{r=function(tau, k, b, h)qnorm(tau)/k + b/h} and, e.g., \code{r.args=list(k=1:2, b=-1, h=1:15)}. In this case, \code{k} and \code{h}
are recycled to length equal to \code{griddensity}, while \code{b} is treated as a constant.

If \code{r} is a vector, dimensionality checks are performed on \code{R} and \code{r} in order to verify that 
\eqn{R\beta(\tau)-r(\tau)} is a legal matrix operation.
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
  Boolean, was the critical value interpolated? FALSE if \code{lambda} appeared among the tabled values. 
  \code{NA} if rank of \code{R} exceeds 20.
  }
}
\references{
Koenker, R. (2005). Quantile regression. Cambridge University Press.
}
\author{
Nathan Laroy (\email{laroynathan@gmail.com})
}
\examples{
taus <- c(0.05, 0.45)
griddensity <- 300
form <- formula(mpg ~ cyl + disp + hp)
R <- rbind(c(0, 1, 1, 0))
r <- cbind(rep(0,1))
glhtprocess(taus = taus, form = form, data = mtcars, R = R, r = r)
}