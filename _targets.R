# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("rticles", "rmarkdown", "knitr",
               "tidyverse", "ggplot2", "ggpubr"), # packages that your targets need to run
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


sim_param <-  tidyr::expand_grid(
  # marg_target_long = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80, 0.90),
  marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50),
  # marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80, 0.90),
  beta_1 = list(c(0.2,-0.2)),
  beta_2 = log(seq(from = 1, to = 3, by = 0.5)),
  X2_dist = c("binary",
              "normal",
              "uniform",
              "gamma"),
)

sim_param_norm <-  tidyr::expand_grid(
  # marg_target_long = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80, 0.90),
  # marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50),
  marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80, 0.90),
  beta_1 = list(c(0.2,-0.2)),
  beta_2 = log(seq(from = 1, to = 3, by = 0.5)),
  X2_dist = c("binary",
              "normal",
              "uniform",
              "gamma"),
)



sim_tar <- tarchetypes::tar_map_rep(
  simulations,
  command = sim_study(n = n, marg_target,
                    beta_1 = beta_1,
                    beta_2 = beta_2,
                    X2_dist = X2_dist),
  values = sim_param,
  # names = tidyselect::any_of("scenario"),
  batches = 1,
  reps = n_it
)

sim_norm_tar <- tarchetypes::tar_map_rep(
  simulations_norm,
  command = sim_norm_study(n = n, marg_target,
                      beta_1 = beta_1,
                      beta_2 = beta_2,
                      X2_dist = X2_dist),
  values = sim_param_norm,
  # names = tidyselect::any_of("scenario"),
  batches = 1,
  reps = n_it
)



list(
  sim_tar,

  sim_norm_tar,

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


  tar_target(
    sim_sum_norm,
    simulations_norm %>%
      group_by(tar_group) %>%
      summarize(
        X2_dist = first(X2_dist),
        beta_2 = first(beta_2),
        marg_target = first(marg_target),
        mean_prob = mean(obs_prob),
        MC_se = sd(obs_prob),
        # mean_prob_cap = mean(obs_prob_cap),
        missing = mean(missing)
      ) %>%
      arrange(X2_dist, beta_2, marg_target)
  ),

  tar_target(
    sim_plots,
     sim_sum %>% plot_sim()
  ),

  tar_target(
    sim_plots_norm,
    sim_sum_norm %>% plot_sim()
  ),


  tar_target(
    sim_grid,
    sim_plots %>%
      ggarrange(plotlist = ., nrow = 2, ncol = 2,
                common.legend = TRUE, legend = "bottom")
  ),

  tar_target(
    sim_grid_norm,
    sim_plots_norm %>%
      ggarrange(plotlist = ., nrow = 2, ncol = 2,
                common.legend = TRUE, legend = "bottom")
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
