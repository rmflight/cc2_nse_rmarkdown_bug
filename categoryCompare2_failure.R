library(callr)

cc2_runs = r(function() rmarkdown::render(here::here("categoryCompare2_failure.Rmd")), show = TRUE)

cc2_source = r(function() source(here::here("categoryCompare2_failure_source.R")), show = TRUE)
