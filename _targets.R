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
# for (file in list.files("R", full.names = TRUE)) source(file)
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(




  # Manuscript --------------------------------------------------------------
  tar_files(
    name = manu_files,
    c("Manuscript/01-intro.Rmd",
      "Manuscript/02-coding.Rmd",
      "Manuscript/03-sim.Rmd",
      "Manuscript/04-conclusion.Rmd",
      "Manuscript/references.bib")
  ),

  tar_render(manu,
             "Manuscript/00-main.Rmd",
             output_dir = "Manuscript",
             output_file = "effect_coding_intercept.pdf")
)
