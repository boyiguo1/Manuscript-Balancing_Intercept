library(broom)
library(tidyverse)

set.seed(123)
n <- 10000

#Marginal probabilities of each variable
p.y <- 0.3; p.x <- 0.5; p.l <- 0.8 

# Generate L, X, and Y ------------------
L3 <- rbinom(n, 1, p.l) 
p.x3b <- 1/(1 + exp(-(-log(1/p.x - 1) + log(1.5)*L3 - log(1.5)*p.l)))
X3b <- rbinom(n, 1, p.x3b) 


summary(glm(X3b~1, family = binomial))
tidy(glm(X3b~1, family = binomial))
summary(glm(X3b~L3, family = binomial))
glm(X3b~L3, family = binomial) %>% tidy()

mean()


p.y3b <- 1/(1 + exp(-(-log(1/p.y - 1) + log(2)*X3b - log(2)*p.x + log(1.5)*L3 - log(1.5)*p.l))) 
Y3b <- rbinom(n, 1, p.y3b)