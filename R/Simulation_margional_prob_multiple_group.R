library(tidyverse)

set.seed(123)

n <- 10000

# Marginal probabilities of each variable
p.y <- 0.3; p.x <- 0.5; p.l <- 0.8

# Example 2: Generate L, X, and Y -------------------

L <- rbinom(n, 1, p.l) %>%
  factor(labels = c("L1", "L2"))

# Generate X and Y with desired marginal prob

# Generate X with marginal prob 0.5
dev_coding <- contr.sum(2)  # Deviation Coding with 2 levels for L
L_design_dev <- cbind( 1,
                       dev_coding[as.numeric(L),])
X_beta_vec <- c(p.x, -0.2)
X <- rbinom(n, 1, L_design_dev %*% X_beta_vec)
mean(X);
mean(X[L=="L1"]);
mean(X[L=="L2"]);


summary(glm(X~1, family = binomial(link="identity")))
summary(glm(X~L_design_dev-1, family = binomial(link="identity")))
summary(glm(X~L, family = binomial(link="identity")))

# Generate Y with marginal prob 0.3

Y_design_dev <- cbind(1,
                      dev_coding[X+1,],
                      dev_coding[as.numeric(L),])

Y_beta_vec <- c(p.y, -0.1, -0.05)


Y <- rbinom(n, 1, Y_design_dev %*% Y_beta_vec)
mean(Y);

summary(glm(Y~X+L, family = binomial(link="identity")))


# In this case, we can't control the marginal probability since when the data are unbalanced across group, the intercept of the effect coding model is the mean of the group means, i.e. \sum p(Y=1|group_i)/n_groups

# Nevertheless, we can relate to the marginal probability to the mean of the group mean by monipulating the reference level, which is also the whole point of this problem.
rd <- 0.1
p_ref <- (p.x-(1-p.l)*rd)
c_int <- (p_ref + p_ref+rd)/2

X_beta_vec <- c(c_int, -0.05)
X <- rbinom(n, 1, L_design_dev %*% X_beta_vec)
mean(X);
mean(X[L=="L1"]);
mean(X[L=="L2"]);


summary(glm(X~1, family = binomial(link="identity")))
summary(glm(X~L_design_dev-1, family = binomial(link="identity")))
summary(glm(X~L, family = binomial(link="identity")))


