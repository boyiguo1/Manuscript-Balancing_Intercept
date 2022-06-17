mgf_binomial <- function(p, n = 2, t){
  q <- 1-p
  return((q+p*exp(t))^n)
}

mgf_multinomial <- function(p = c(0.5, 0.35, 0.15), n=1, t){
  # browser()
  (p[1] + sum(p[-1]*exp(t)))^n
}

mgf_uniform <- function(a, b, t){
  if(b <= a) stop("Error: b must be greater than a")
  if(t==0) return(1)
  else
    return((exp(t*b)-exp(t*a))/(t*(b-a)))
}


mgf_normal <- function(mu, var, t){
  return(exp(mu*t + var*t^2/2))
}


mgf_gamma <- function(sahpe, rate, t){
  if(t >= rate) stop("Error: not defined")
  (1-t/rate)^(-1*shape)
}
