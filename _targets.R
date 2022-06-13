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

# Replace the target list below with your own:
tar_plan(


  # Simulation Example ------------------------------------------------------
  # * Parameters ------------------------------------------------------------
  n = 10^4,
  marg_target = c(0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70,0.80,0.90),

  # * Simulate Data ---------------------------------------------------------
  sim_dat = simulate_dat(n),

  # * Calculate Balance Point -----------------------------------------------
  beta_1 = c(1,1), # Log risk ratio of 3-level covariate
  beta_2 = 1,
  mgf_X1 = mgf_multinomial(p = c(0.5, 0.35, 0.15), n=1, t=beta_1),
  mgf_X2 = mgf_binomial(p = 0.8, n=1, t=beta_2),
  beta_0 = log(marg_target[1]) - log(mgf_X1) - log(mgf_X2),
  X1_design = model.matrix(~factor(X1)+X2, sim_dat),
  sim_prob = exp(X1_design%*%c(beta_0, beta_1, beta_2)),

  y = rbinom(n, size = 1, prob = sim_prob),







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
