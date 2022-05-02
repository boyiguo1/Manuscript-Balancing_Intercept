set.seed(123)
n <- 10000
p.y <- 0.3; p.x <- 0.5; p.l <- 0.8
L2 <- rbinom(n, 1, p.l)

dev_coding <- contr.sum(2)  # Deviation Coding with 2 levels for L
L2_design_dev <- cbind( 1,
                       dev_coding[L2+1,])

#Generate X and Y using balancing intercepts
p.x2b <- p.x + 0.1*L2 - 0.1*p.l
X2b <- rbinom(n, 1, p.x2b)
p.y2b <- p.y + 0.2*X2b - 0.2*p.x + 0.1*L2 - 0.1*p.l
Y2b <- rbinom(n, 1, p.y2b)

mean(L2);
mean(X2b);
mean(X2b[L2==0]);
mean(X2b[L2==1]);
summary(glm(X2b~L2, family = binomial(link="identity")))

L2_factor <- factor(L2)
summary(tmp <- glm(X2b~ L2_factor, family = binomial(link="identity"), contrasts = list(L2_factor = "contr.sum")))
summary(glm(X2b~1, family = binomial(link="identity")))
summary(glm(X2b~L2_design_dev-1, family = binomial(link="identity")))




mean(Y2b);



summary(glm(Y2b~X2b+L2, family = binomial(link="identity")))
