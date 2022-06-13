mgf_binomial <- function(p, n = 2, t){
  q <- 1-p
  return((q+p*exp(t))^n)
}



mgf_multinomial <- function(p = c(0.5, 0.35, 0.15), n=1, t){
  # browser()
  (p[1] + sum(p[-1]*exp(t)))^n
}
