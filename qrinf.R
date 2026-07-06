.VFun <- function(x, form, data){
  taus <- unlist(x)
  tau1 <- taus[1]
  tau2 <- taus[2]
  modFull_allTau <- rq(formula=form, data=data, tau=taus)
  summ <- summary(modFull_allTau, se = "nid", cov = T)
  taus <- taus[order(taus)]
  if (tau1==tau2){
    (min(tau1, tau2) - tau1*tau2) * summ$Hinv %*% summ$J %*% summ$Hinv
  } else {
    (min(tau1, tau2) - tau1*tau2) * summ[[which(taus==tau1)]]$Hinv %*% summ[[1]]$J %*% summ[[which(taus==tau2)]]$Hinv
  }
}

.Interpolate <- function(x, lambdas, lambda, lambdasInterval, lambdasIndex, crits){
  critInterval <- crits[crits$alpha==x,]$crit
  critSlope <- (critInterval[2] - critInterval[1])/(lambdas[lambdasIndex+1]-lambdas[lambdasIndex])
  interpolCrit <- critInterval[1] + critSlope * (lambda - lambdasInterval[1])
  data.frame(alpha = x, crit = interpolCrit)
}

glhtxi <- function(taus, form, data, R, r, se = "nid", ...){
  if(!require("quantreg")){
    stop("quantreg package is not installed")
  }
  
  # Preliminaries
  modFull <- rq(formula=form, data=data, tau=taus)
  summ <- summary(modFull, se = se, cov = T, ...)
  p <- ncol(model.frame(modFull))
  m <- length(taus)
  xi <- cbind(c(modFull$coefficients))
  
  # Dimensionality checks
  dimR <- dim(R)
  dimr <- dim(r)
  dimXi <- c(m*p, 1)
  if (dimR[2] != dimXi[1]){
    dimR <- paste0("(", dimR[1], "x", dimR[2],")")
    dimXi <- paste0("(", dimXi[1], "x", dimXi[2],")")
    stop(paste0("R ", dimR, " and Xi ", dimXi, " are non-conformable."))
  }
  if (!identical(dim(R%*%xi), dim(r))){
    dimRXi <- dim(R%*%xi)
    dimRXi <- paste0("(", dimRXi[1], "x", dimRXi[2],")")
    dimr <- paste0("(", dimr[1], "x", dimr[2],")")
    stop(paste0("R\u03BE ", dimRXi, " and r ", dimr, " have non-identical dimensions."))
  }
  
  # Covariance Matrix
  vGrid <- expand.grid(taus, taus)
  vGrid <- vGrid[vGrid$Var1>=vGrid$Var2,]
  vList <- split(vGrid, 1:nrow(vGrid))
  V <- mapply(.VFun, vList, MoreArgs = list(form=formula(modFull), data=data), SIMPLIFY=F)
  for (i in matrix(1:m^2, ncol=m)[upper.tri(diag(m))] - 1){
    V <- append(V, list(V[[1]]*0L), after = i)
  }
  for (i in 0:m){
    block <- do.call(rbind, V[(1+i*m):(m+i*m)])
    if (i==0){
      blockV <- block
    } else {
      blockV <- cbind(blockV, block)
    }
  }
  blockV <- as.matrix(Matrix::forceSymmetric(blockV, uplo = "L"))
  
  # Test
  Tn <- t(R %*% xi - r) %*% solve(R %*% blockV %*% t(R)) %*% (R %*% xi - r)
  pval <- pchisq(Tn, df = nrow(R), lower.tail = F)
  (results <- list(R = R,
                   H0 = R %*% xi - r,
                   Tn = Tn,
                   df = nrow(R),
                   p.value = pval))
}

glhtprocess <- function(taus, form, data, R, r, griddensity = 300, se = "nid", ...){
  load("estrellaTables.rda")
  
  # Preliminaries
  taus <- seq(taus[1], taus[2], length.out=griddensity)
  modFull <- rq(formula=form, data=data, tau=taus)
  p <- ncol(model.frame(modFull))
  n <- nrow(data)
  summaries <- summary(modFull, se = se, cov = T, ...)
  
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
  
  # Pvalue from estrellaTables/interpolation
  lambdas <- estrellaTables$lambda[1:13]
  lambdasIndex <- which.max(ifelse(lambdas < lambda, lambdas, -Inf))
  if (lambda > last(lambdas)){
    lambda <- 361
    warning("Lambda > 361, critical value determined for lambda = 361.")
  }
  if (!lambda %in% lambdas){
    interpolated <- TRUE
    lambdasInterval <- lambdas[c(lambdasIndex,lambdasIndex+1)]
    crits <- estrellaTables[estrellaTables$lambda %in% lambdasInterval & estrellaTables$q == dimR[1],]
    alphas <- c("10%", "5%", "1%")
    crit <- lapply(X = alphas,
                   FUN = .Interpolate, lambdas = lambdas, lambda = lambda,
                   lambdasInterval = lambdasInterval, lambdasIndex = lambdasIndex, crits = crits)
    crit <- do.call(rbind, crit)
  } else {
    interpolated <- FALSE
    crit <- data.frame(alpha = alphas, 
                       crit = estrellaTables[estrellaTables$lambda==lambda & estrellaTables$q==dimR[1],][c("alpha", "crit")])
  }
  
  if (interpolated) {
    message <- "Critical value is linearly interpolated."
  } else {
    message <- "Critical value obtained from table."
  }
  
  (results <- list(restriction.matrix = R, lambda = lambda, q = dimR[1], Tn = max(stat),
                   critical.value = crit, p.value.info = message))
}
