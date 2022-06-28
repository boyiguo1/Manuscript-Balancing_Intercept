simulate_dat <- function(n, Xdistn = c("binary", "uniform", "normal", "gamma")){

  Xdistn <- Xdistn[1]

  # Simulate the 3-level covariate
  X1 <- sample(1:3, size = n, replace = TRUE,
               prob = c(0.5, 0.35, 0.15))

  # Simulate the covariates
  # The following code is taken from
  # https://github.com/serobertson/BalancingInterceptSolver/blob/main/01a_analytical_intercept.R
  if(Xdistn=="binary"){
    p.x2 <- 0.8
    X2 <- rbinom(n, 1, p.x2)
  } else if (Xdistn=="uniform"){
    p.x2 <- 1
    X2 <- runif(n,-1,3)
  } else if (Xdistn=="normal"){
    p.x2 <- 0
    X2 <- rnorm(n,0,1)
  } else if (Xdistn=="gamma"){
    p.x2 <- 1/0.50 #2
    X2 <- rgamma(n,shape=1,rate=1.5)
  }

  return(data.frame(X1, X2))
}
