sim_study <- function(n, marg_target,
                      beta_1, beta_2, X2_dist = "binary"){
  # * Simulate Data ---------------------------------------------------------
  sim_dat <- simulate_dat(n, X2_dist)

  # if(X2_dist != "binary") stop("Not implemented yet")

  # * Calculate Balance Point -----------------------------------------------
  # beta_1 <- betas$beta_1 # Log risk ratio of 3-level covariate
  # beta_2 <- betas$beta_2 # Log risk ratio of

  # print(X2_dist == "normal" )

  mgf_X1 <- mgf_multinomial(p = c(0.5, 0.35, 0.15), n=1, t=beta_1)
  mgf_X2 <- if(X2_dist == "binary") mgf_binomial(p = 0.8, n = 1, t = beta_2)
  else if(X2_dist == "uniform") mgf_uniform(a = -1, b = 3, t = beta_2)
  else if(X2_dist == "normal") mgf_normal(mu = 0, var = 1, t = beta_2)
  else if(X2_dist == "gamma") mgf_gamma(shape = 1, rate = 1.5, t = beta_2)
  else stop("No available mgf for X2_dist")

  # mgf_X2 <- case_when(
  #     X2_dist == "binary" ~ mgf_binomial(p = 0.8, n = 1, t = beta_2),
  #     X2_dist == "uniform" ~ mgf_uniform(a = -1, b = 3, t = beta_2),
  #     X2_dist == "normal" ~ mgf_normal(mu = 0, var = 1, t = beta_2),
  #     X2_dist == "gamma" ~ mgf_gamma(shape = 1, rate = 0.5, t = beta_2),
  #     TRUE ~ stop("No available mgf for X2_dist")
  # )


  # Calculate Balance Intercept Following Eq (3) in Appendix
  beta_0 <- log(marg_target[1]) - log(mgf_X1) - log(mgf_X2)

  # Construct Design Matrix with Reference Coding
  X1_design <- model.matrix(~factor(X1)+X2, sim_dat)

  # Calculate Simulation Probability
  sim_prob <- exp(X1_design%*%c(beta_0, beta_1, beta_2))

  # Simulate Outcome
  y <- rbinom(n, size = 1, prob = sim_prob)

  # TODO: Debug code. TO remove
  cap <- prob_cap(sim_prob)
  y_cap <- rbinom(n, 1, cap)
  # tmp <- data.frame(cap, sim_prob,y, y_cap)
  # tmp %>% filter(!is.na(y))

  return(
    data.frame(
      # exp_prob = marg_target,
      obs_prob = mean(y, na.rm = TRUE),
      missing = sum(is.na(y)),
      obs_prob_cap = mean(y_cap, na.rm = TRUE)
    )
  )
}


sim_norm_study <- function(n, marg_target,
                      beta_1, beta_2, X2_dist = "binary"){
  # * Simulate Data ---------------------------------------------------------
  sim_dat <- simulate_dat(n, X2_dist)

  # if(X2_dist != "binary") stop("Not implemented yet")

  # * Calculate Balance Point -----------------------------------------------
  # beta_1 <- betas$beta_1 # Log risk ratio of 3-level covariate
  # beta_2 <- betas$beta_2 # Log risk ratio of

  # print(X2_dist == "normal" )

  mgf_X1 <- mgf_multinomial(p = c(0.5, 0.35, 0.15), n=1, t=beta_1)
  mgf_X2 <- if(X2_dist == "binary") mgf_binomial(p = 0.8, n = 1, t = beta_2)
  else if(X2_dist == "uniform") mgf_uniform(a = -1, b = 3, t = beta_2)
  else if(X2_dist == "normal") mgf_normal(mu = 0, var = 1, t = beta_2)
  else if(X2_dist == "gamma") mgf_gamma(shape = 1, rate = 1.5, t = beta_2)
  else stop("No available mgf for X2_dist")

  # mgf_X2 <- case_when(
  #     X2_dist == "binary" ~ mgf_binomial(p = 0.8, n = 1, t = beta_2),
  #     X2_dist == "uniform" ~ mgf_uniform(a = -1, b = 3, t = beta_2),
  #     X2_dist == "normal" ~ mgf_normal(mu = 0, var = 1, t = beta_2),
  #     X2_dist == "gamma" ~ mgf_gamma(shape = 1, rate = 0.5, t = beta_2),
  #     TRUE ~ stop("No available mgf for X2_dist")
  # )

  # browser()
#
  # Calculate Balance Intercept Following Eq (3) in Appendix
  beta_0 <- log(marg_target[1]) - log(mgf_X1) - log(mgf_X2)

  # Construct Design Matrix with Reference Coding
  X1_design <- model.matrix(~factor(X1)+X2, sim_dat)

  # Calculate Simulation Probability
  sim_prob <- exp(X1_design%*%c(beta_0, beta_1, beta_2))

  # Simulate Outcome
  y <- rnorm(n, mean = sim_prob, sd = 0.1)

  # TODO: Debug code. TO remove
  # cap <- prob_cap(sim_prob)
  # y_cap <- rbinom(n, 1, cap)
  # tmp <- data.frame(cap, sim_prob,y, y_cap)
  # tmp %>% filter(!is.na(y))

  return(
    data.frame(
      # exp_prob = marg_target,
      obs_prob = mean(y, na.rm = TRUE),
      missing = sum(is.na(y))#,
      # obs_prob_cap = mean(y_cap, na.rm = TRUE)
    )
  )
}

