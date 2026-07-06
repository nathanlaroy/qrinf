\name{estrellaTables}
\alias{estrellaTables}
\docType{data}
\title{
Critical Values Table For Inference On The QR Process
}
\description{
This dataset is a digital copy of the tables of critical values in Estrella (2003), formatted
to be used by qrinf functions.
}
\usage{data("estrellaTables")}
\format{
  A data frame with 780 observations on the following 9 variables.
  \describe{
    \item{\code{p0}}{a numeric vector}
    \item{\code{lambda}}{a numeric vector}
    \item{\code{variable}}{a factor with levels \code{X10.} \code{X5.} \code{X1.} \code{X10..1} \code{X5..1} \code{X1..1} \code{X10..2} \code{X5..2} \code{X1..2} \code{X10..3} \code{X5..3} \code{X1..3} \code{X10..4} \code{X5..4} \code{X1..4} \code{X10..5} \code{X5..5} \code{X1..5} \code{X10..6} \code{X5..6} \code{X1..6} \code{X10..7} \code{X5..7} \code{X1..7} \code{X10..8} \code{X5..8} \code{X1..8} \code{X10..9} \code{X5..9} \code{X1..9} \code{X10..10} \code{X5..10} \code{X1..10} \code{X10..11} \code{X5..11} \code{X1..11} \code{X10..12} \code{X5..12} \code{X1..12} \code{X10..13} \code{X5..13} \code{X1..13} \code{X10..14} \code{X5..14} \code{X1..14} \code{X10..15} \code{X5..15} \code{X1..15} \code{X10..16} \code{X5..16} \code{X1..16} \code{X10..17} \code{X5..17} \code{X1..17} \code{X10..18} \code{X5..18} \code{X1..18} \code{X10..19} \code{X5..19} \code{X1..19}}
    \item{\code{crit}}{a numeric vector}
    \item{\code{alpha}}{a character vector}
    \item{\code{q}}{a numeric vector}
    \item{\code{lambda_f}}{a factor with levels \code{1} \code{1.08} \code{1.17} \code{1.27} \code{1.49} \code{2.25} \code{3.45} \code{5.44} \code{9} \code{16} \code{32.11} \code{81} \code{361}}
    \item{\code{alpha_f}}{a factor with levels \code{1%} \code{10%} \code{5%}}
    \item{\code{q_f}}{a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5} \code{6} \code{7} \code{8} \code{9} \code{10} \code{11} \code{12} \code{13} \code{14} \code{15} \code{16} \code{17} \code{18} \code{19} \code{20}}
  }
}
\source{
Estrella, A. (2003) Critical Values and p Values of Bessel Process Distributions: Computation and
Application to Structural Break Tests. Econometric Theory , Dec., 2003, Vol. 19, No. 6 (Dec., 2003), pp. 1128-1143
}
\examples{
data(estrellaTables)
}
\keyword{datasets}
