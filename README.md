# Manuscript Repository

This is the repository for the manuscript _Lean on your statistics: The generalization and  simplification of the balance
  intercept problem_. The repository is set up using the R workflow package [`targets`](https://cran.r-project.org/web/packages/targets/index.html). The manuscript can be reproduced easily via `targets` syntax.

## How to replicate the manuscript

1. Install the necessary workflow packages [`targets`](https://cran.r-project.org/web/packages/targets/index.html) and [`renv`](https://rstudio.github.io/renv/articles/renv.html)  if you don't already have

2. Open the R console and call renv::restore() to install the required R packages. Please give permission to install the necessary packages. This will mirror the packages whose the exact versions that are used during the creation of the manuscript.

3. call the targets::tar_make() function to run the pipeline; for example targets::tar_make("manu") to create the manuscript, and targets::tar_make("manu_app") to create the supporting information.
