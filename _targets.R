library(targets)
library(tarchetypes)
tar_plan(
  tar_render(rmd_run, "categoryCompare2_failure.Rmd")
)

