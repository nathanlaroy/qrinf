glhtxi <-
function(taus, form, data, R, r, se = "nid", ...){
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
                   q = nrow(R),
                   p.value = pval))
}
