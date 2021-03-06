#the bootstrap krippendorff alpha, written code.
install.packages("irr")
library(irr)
require(irr)

kripp.boot <- function(df, raters='rows', probs=c(.025,.975), iter=100, method='nominal') {
  x <- numeric(iter)
  
  if (raters == 'cols') {
    df <- t(df)
  }
  
  for (i in seq(1,iter,1)) {
    x[i] <- kripp.alpha(df[,sample(ncol(df), size=ncol(df), replace=TRUE)], 
                        method=method)$value
  }
  
  kripp.ci <- quantile(x, probs=probs, na.rm=TRUE)
  boot.stats <- list(mean.alpha=mean(x, na.rm=TRUE), 
                     upper=kripp.ci[2], 
                     lower=kripp.ci[1], 
                     alphas=x,
                     raters=nrow(df),
                     iter=iter,
                     probs=probs,
                     size=ncol(df))
  class(boot.stats) <- 'kripp.boot'
  return(boot.stats)
}

print.kripp.boot <- function(boot.stats) {
  cat("Bootstrapped Krippendorff's Alpha","\n\n")
  cat('Alpha Levels for', boot.stats$raters,'raters,', 
      boot.stats$iter, ' iterations', '\n')
  cat('     ', boot.stats$probs[1],'= ', boot.stats$lower, '\n')
  cat(' Mean alpha = ', boot.stats$mean.alpha, '\n')
  cat('     ', boot.stats$probs[2],'= ', boot.stats$upper, '\n')
}

install.packages("devtools")
library(devtools)
install.packages("roxygen2")
library(roxygen2)

