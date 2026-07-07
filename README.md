# qrinf
R package: Quantile Regression Inference Convenience Functions

# Brief description
This package contains two convenience functions which simplify conducting Wald-type general linear hypothesis tests regarding quantile regression models. Specifically, `glhtxi()` allows to test a general linear hypothesis concerning the quantile regression coefficient vector for a finite set of quantile criteria; `glhtprocess()` allows to test a general linear hypothesis concerning the quantile regression process for a closed sub-interval on the open unit interval of quantile criteria. The functions extend the `quantreg` package (Koenker, 2025), automating the estimation of the covariance term for the Wald-type statistics, and the calculation of the sup-Wald statistic.

This is a version in development. Comments and bug reports are appreciated.
email: nathan.laroy@ugent.be

# References
Koenker, R. (2025). quantreg: Quantile Regression. https://CRAN.R-project.org/package=quantreg. (doi: 10.32614/CRAN.package.quantreg).
