library(callr)

s_run = r(function() rmarkdown::render(here::here("simpler_test.Rmd")), show = TRUE)

s_run2 = r(function() rmarkdown::render(here::here("simpler_test_df.Rmd")), show = TRUE)
