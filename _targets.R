# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("rticles", "rmarkdown", "knitr",
               "tidyverse"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# Load the R scripts with your custom functions:
for (file in list.files("R", full.names = TRUE)) source(file)
# source("other_functions.R") # Source other scripts as needed. # nolint


# Simulation Parameter
n_total <- 1e8
n <- 1e4
# n_it <- n_total/n
n_it <- 10


assess_hyperparameters <- function(sigma1, sigma2) {
  # data <- simulate_random_data() # user-defined function
  # run_model(data, sigma1, sigma2) # user-defined function
  # Mock output from the model:
  posterior_samples <- stats::rnorm(1000, 0, sigma1 + sigma2)
  tibble::tibble(
    posterior_median = median(posterior_samples),
    posterior_quantile_0.025 = quantile(posterior_samples, 0.025),
    posterior_quantile_0.975 = quantile(posterior_samples, 0.975)
  )
}

hyperparameters <- tibble::tibble(
  scenario = c("tight", "medium", "diffuse"),
  sigma1 = c(10, 50, 50),
  sigma2 = c(10, 5, 10)
)


sim_param <-  tidyr::expand_grid(
  # marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80,0.90),
  marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50),
  beta_1 = list(c(0.2,-0.2)),
  beta_2 = log(seq(from = 1, to = 2, by = 0.4)),
  X2_dist = c("binary",
              "normal",
              "uniform",
              "gamma"),
)



sim_tar <- tarchetypes::tar_map_rep(
  simulations,
  command =sim_study(n = n, marg_target,
                    beta_1 = beta_1,
                    beta_2 = beta_2,
                    X2_dist = X2_dist),
  values = sim_param,
  # names = tidyselect::any_of("scenario"),
  batches = 1,
  reps = n_it
)



list(
  sim_tar,
  tar_target(
    sim_sum,
    simulations %>%
      group_by(tar_group) %>%
      summarize(
        X2_dist = first(X2_dist),
        beta_2 = first(beta_2),
        marg_target = first(marg_target),
        mean_prob = mean(obs_prob),
        MC_se = sd(obs_prob),
        mean_prob_cap = mean(obs_prob_cap),
        missing = mean(missing)
        ) %>%
      arrange(X2_dist, beta_2, marg_target)
  ),

  # Manuscript --------------------------------------------------------------
  tar_files(
    name = manu_files,
    c("Manuscript/01-intro.Rmd",
      "Manuscript/02-coding.Rmd",
      "Manuscript/03-sim.Rmd",
      "Manuscript/04-conclusion.Rmd",
      "Manuscript/references.bib",
      "Manuscript/tab/code_scheme.tex"
    )
  ),

  tar_render(manu,
             "Manuscript/00-main.Rmd",
             output_file = "effect_coding_intercept.pdf"),


  tar_render(manu_append,
             "Manuscript/10-appendix.Rmd",
             output_file = "appendix.pdf")

  # tar_render(manu,
  #            "Manuscript/00-main.Rmd",
  #            output_file = "effect_coding_intercept.docx")
)

#

#
# # Replace the target list below with your own:
# tar_plan(
#
#   # Simulation Example ------------------------------------------------------
#   # * Parameters ------------------------------------------------------------
#   # n = 10^5,
#   #,
#   # n_it = 1000,
#   marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80,0.90),
#
#   sim_par_df <- tibble::tibble(
#   marg_target = marg_target#,
#   # beta_1 = beta_1,
#   # beta_2 = beta_2
#   ),
#   beta_1 = list(c(1,1)),
#   beta_2 = 1,
#
#
#   # * Simulation
#   tar_map_rep(
#     sim_res,
#     command = sim_study(n = n, marg_target,
#               beta_1 = beta_1, beta_2 = beta_2,
#               X2_dist = "binary"),
#     values = data.frame(marg_target),
#     names = tidyselect::any_of("marg_target"),
#     batch = 1, reps = n_it
#   ),
#
#   # Manuscript --------------------------------------------------------------
#   tar_files(
#     name = manu_files,
#     c("Manuscript/01-intro.Rmd",
#       "Manuscript/02-coding.Rmd",
#       "Manuscript/03-sim.Rmd",
#       "Manuscript/04-conclusion.Rmd",
#       "Manuscript/references.bib",
#       "Manuscript/tab/code_scheme.tex"
#     )
#   ),
#
#   tar_render(manu,
#              "Manuscript/00-main.Rmd",
#              output_file = "effect_coding_intercept.pdf"),
#
#
#   tar_render(manu_append,
#              "Manuscript/10-appendix.Rmd",
#              output_file = "appendix.pdf")
#
#   # tar_render(manu,
#   #            "Manuscript/00-main.Rmd",
#   #            output_file = "effect_coding_intercept.docx")
# )
