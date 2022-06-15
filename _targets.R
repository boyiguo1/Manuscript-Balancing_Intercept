# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("rticles", "rmarkdown", "knitr"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# Load the R scripts with your custom functions:
for (file in list.files("R", full.names = TRUE)) source(file)
# source("other_functions.R") # Source other scripts as needed. # nolint


n_it = 10

# Replace the target list below with your own:
tar_plan(

  # Simulation Example ------------------------------------------------------
  # * Parameters ------------------------------------------------------------
  n = 10^5,
  #,
  # n_it = 1000,
  marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80,0.90),

  sim_par_df <- tibble::tibble(
  marg_target = marg_target#,
  # beta_1 = beta_1,
  # beta_2 = beta_2
  ),
  beta_1 = list(c(1,1)),
  beta_2 = 1,


  # * Simulation
  tar_map_rep(
    sim_res,
    command = sim_study(n = n, marg_target,
              beta_1 = beta_1, beta_2 = beta_2,
              X2_dist = "binary"),
    values = data.frame(marg_target),
    names = tidyselect::any_of("marg_target"),
    batch = 1, reps = n_it
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
