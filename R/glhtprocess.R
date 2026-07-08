glhtprocess <-
function(taus, form, data, R, r, griddensity = 300, se = "nid", verbose = TRUE, ...){
  # Preliminary checks
  if (!all(taus<1 & taus>0)){
    message <- paste0("Quantile interval is not a proper subset of (0, 1).")
    stop(message)
  }
  
  # Preliminaries
  taus <- seq(taus[1], taus[2], length.out=griddensity)
  modFull <- rq(formula=form, data=data, tau=taus)
  p <- ncol(model.frame(modFull))
  n <- nrow(data)
  summ <- .summ(modFull = modFull, se = se, ...)
  summaries <- summ$result
  if (verbose){
    fis <- do.call(sum, lapply(summ$warnings, FUN = function(x) as.numeric(regmatches(x, gregexpr("[0-9]+", x))[[1]])))
    warningMessage <- paste0(fis, " non-positive fis across all taus.")
  } else {
    warningMessage <- ""
  }
  

  # Checks
  dimR <- dim(R)
  dimr <- dim(r)
  if (dimR[2] != p){
    dimR <- paste0("(", dimR[1], "x", dimR[2],")")
    dimBeta <- paste0("(", p, "x", 1,")")
    stop(paste0("R ", dimR, " and Beta ", dimBeta, " are non-conformable."))
  }
  if (!identical(dim(R%*%modFull$coefficients[,1]), dim(r))){
    dimRBeta <- dim(R%*%modFull$coefficients[,1])
    dimRBeta <- paste0("(", dimRBeta[1], "x", dimRBeta[2],")")
    dimr <- paste0("(", dimr[1], "x", dimr[2],")")
    stop(paste0("R\u03B2 ", dimRBeta, " and r ", dimr, " have non-identical dimensions."))
  }
  if (0 %in% rowSums(R)){
    stop("Restriction matrix R contains redundant row of zeroes.")
  }
  if (dimR[1]>20){
    q_outofbounds <- TRUE
    warning("Restriction matrix has rank > 20, critical value irretrievable.")
  } else {
    q_outofbounds <- FALSE
  }
  
  # Test
  stat <- numeric(length(taus))
  for (i in 1:length(taus)){
    tau <- taus[i]
    B <- summaries[[i]]$coefficients[,1]
    V <- summaries[[i]]$cov
    stat[i] <- t(R %*% B - r) %*% solve(R %*% V %*% t(R)) %*% (R %*% B - r)
  }
  tau0 <- min(taus)
  tau1 <- max(taus)
  lambda <- tau1*(1-tau0) / (tau0*(1-tau1))
  
  # Critical value from estrellaTables/interpolation
  if (q_outofbounds){
    crit <- NA
    interpolated <- NA
  } else {
    lambdas <- estrellaTables$lambda[1:13]
    lambdasIndex <- which.max(ifelse(lambdas < lambda, lambdas, -Inf))
    if (lambda > tail(lambdas, n=1)){
      lambda <- 361
      warning("Lambda > 361, critical values determined for lambda = 361. Critical values will be too small, type I error rate is inflated.")
    }
    if (!round(lambda, 2) %in% lambdas){
      interpolated <- TRUE
    } else {
      interpolated <- FALSE
    }
    lambdasInterval <- lambdas[c(lambdasIndex,lambdasIndex+1)]
    crits <- estrellaTables[estrellaTables$lambda %in% lambdasInterval & estrellaTables$q == dimR[1],]
    alphas <- c("10%", "5%", "1%")
    crit <- lapply(X = alphas,
                   FUN = .Interpolate, lambdas = lambdas, lambda = lambda,
                   lambdasInterval = lambdasInterval, lambdasIndex = lambdasIndex, crits = crits)
    crit <- do.call(rbind, crit)
  }
  
  results <- list(restriction.matrix = R, lambda = lambda, q = dimR[1], Tn = max(stat),
                   critical.value = crit, interpolated = interpolated)
  if (verbose) {
    warning(warningMessage)
  }
  return(results)
}
