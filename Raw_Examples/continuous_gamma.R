set.seed(123)

n <- 10000

# Marginal probabilities of each variable
p.y <- 0.3
p.x <- 0.8      # Imbalanced design
rd <- 0.2

cond.p <- (n*p.y - n*(p.x)*rd)/n
a.0 <- cond.p + rd/2


# Example 2: Generate L, X, and Y -------------------
X <- rbinom(n, 1, p.x)
Z <- rgamma(n, shape = 1, rate=0.5)
mean_Z <-mean(Z)


# Generate X with marginal prob 0.5
dev_coding <- contr.sum(2)  # Deviation Coding with 2 levels
X_design_dev <- cbind( 1,   # Adding intercept column
                       dev_coding[X+1,], Z-mean(Z)) # Construct the deisgn matrix

# The design matrix with effect coding can be more easily construct with model.matrix function

beta_vec <- c(a.0,   # Intercept term, the calculated mean of group means
              -rd/2, 0.1) # Set up conditional prob for reference level
eta <- X_design_dev %*% beta_vec
# eta[eta<0] <- 0
# eta[eta>1] <- 1
Y <- rbinom(n, 1, eta)

summary(glm(Y~X, family = binomial(link="identity"))) # Reference coding model
summary(glm(Y~X_design_dev-1, family = binomial(link="identity"))) # Effect coding model
