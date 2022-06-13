library(tidyverse)

set.seed(1)

group_name <- c("X1", "X2")
p_group <- length(group_name)
n_per_group <- 5000

X <- rep(group_name, n_per_group)[sample(p_group*n_per_group)] %>% factor

# Dummy Coding Example -------
dummy_coding <- contr.treatment(p_group,
                                base = 1) # "L1" is dummy
X_design_dummy <- cbind(1,
                   dummy_coding[as.numeric(X),])

beta_vec <- c(0.3, 0.2)
Y_dummy <-rbinom(p_group*n_per_group, 1, X_design_dummy %*% beta_vec)
mean(Y_dummy);
mean(Y_dummy[X=="L1"]);
mean(Y_dummy[X=="L2"]);
summary(glm(Y_dummy~X, family = binomial(link="identity")))

# Deviation Coding
dev_coding <- contr.sum(p_group)
X_design_dev <- cbind( 1,
                   dev_coding[as.numeric(X),])
beta_vec <- c(0.3, 0.1)
Y_dev <- rbinom(p_group*n_per_group, 1, X_design_dev %*% beta_vec)
mean(Y_dev);
mean(Y_dev[X=="L1"]);
mean(Y_dev[X=="L2"]);
summary(glm(Y_dev~X, family = binomial(link="identity")))






