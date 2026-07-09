.Interpolate <-
function(x, lambdas, lambda, lambdasInterval, lambdasIndex, crits){
  critInterval <- crits[crits$alpha==x,]$crit
  critSlope <- (critInterval[2] - critInterval[1])/(lambdas[lambdasIndex+1]-lambdas[lambdasIndex])
  interpolCrit <- critInterval[1] + critSlope * (lambda - lambdasInterval[1])
  data.frame(alpha = x, crit = interpolCrit)
}
.VFun <-
function(x, form, data){
  taus <- unlist(x)
  tau1 <- taus[1]
  tau2 <- taus[2]
  mod <- rq(formula=form, data=data, tau=taus)
  summ <- summary(mod, se = "nid", cov = T)
  taus <- taus[order(taus)]
  if (tau1==tau2){
    (min(tau1, tau2) - tau1*tau2) * summ$Hinv %*% summ$J %*% summ$Hinv
  } else {
    (min(tau1, tau2) - tau1*tau2) * summ[[which(taus==tau1)]]$Hinv %*% summ[[1]]$J %*% summ[[which(taus==tau2)]]$Hinv
  }
}
.summ <- function(modFull, se = se, ...) {
  context = new.env()
  context$result = withCallingHandlers(
    withRestarts(
      summaries <- summary(modFull, se = se, cov = T, ...),
      muffleStop = function() NULL
    ),
    warning = function(w) {
      context$warnings = c(context$warnings,
                           list(as.character(conditionMessage(w))))
      invokeRestart("muffleWarning")
    },
    error = function(e) {
      context$error = as.character(conditionMessage(e))
      invokeRestart("muffleStop")
    }
  )
  as.list(context)
}
.statFun <- function(x, R, r){
  B <- x$coefficients[,1]
  V <- x$cov
  return(t(R %*% B - r) %*% solve(R %*% V %*% t(R)) %*% (R %*% B - r))
}