prob_cap <- function(x){
  x[which(x<0)] <- 0
  x[which(x>1)] <- 1

  return(x)
}
