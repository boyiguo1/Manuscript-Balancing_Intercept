set.seed(123)
n <- 10000

#Marginal probabilities of each variable
p.y <- 0.3; p.x <- 0.5; p.l <- 0.8 

expit <- binomial()$linkinv
# Example 2: Generate L, X, and Y -------------------

L <- rbinom(n, 1, p.l)

# Generate X and Y with desired marginal prob

# Generate X with marginal prob 0.5
dev_coding <- contr.sum(2)  # Deviation Coding with 2 levels for L
L_design_dev <- cbind( 1,
                       dev_coding[L+1,])
X_beta_vec <- c(-1*log(1/p.x-1), -1*log(1.5)/2)
X <- rbinom(n, 1, expit(L_design_dev %*% X_beta_vec))
mean(X);
mean(X[L==0]);
mean(X[L==1]);


tidy(glm(X~1, family = binomial))
tidy(glm(X~L_design_dev-1, family = binomial))
tidy(glm(X~L, family = binomial), exponentiate = T)

# Generate Y with marginal prob 0.3

Y_design_dev <- cbind(1, 
                      dev_coding[X+1,],
                      dev_coding[as.numeric(L),])

Y_beta_vec <- c(p.y, -0.1, -0.05)


Y <- rbinom(n, 1, Y_design_dev %*% Y_beta_vec)
mean(Y);

summary(glm(Y~X+L, family = binomial(link="identity")))
s