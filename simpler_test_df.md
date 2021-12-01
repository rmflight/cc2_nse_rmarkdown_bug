    flights_df = as.disk.frame(
      flights, outdir = file.path(tempdir(), "tmp_flights.df"),
      overwrite = TRUE
    )

    keep_delay = 0
    flights_df %>%
      filter(dep_delay >= keep_delay) %>%
      group_by(carrier) %>%
      summarize(count = n(), mean_dep_delay = mean(dep_delay, na.rm=T)) %>%  # mean follows normal R rules
      collect %>% 
      arrange(carrier)

    ## # A tibble: 16 × 3
    ##    carrier count mean_dep_delay
    ##    <chr>   <int>          <dbl>
    ##  1 9E       7698           44.9
    ##  2 AA      11769           32.1
    ##  3 AS        254           27.9
    ##  4 B6      24217           35.2
    ##  5 DL      18107           31.5
    ##  6 EV      24798           47.0
    ##  7 F9        385           40.0
    ##  8 FL       1786           37.8
    ##  9 HA         83           37.3
    ## 10 MQ       9338           38.6
    ## 11 OO          9           58  
    ## 12 UA      30658           26.6
    ## 13 US       5412           29.2
    ## 14 VX       2636           29.1
    ## 15 WN       7545           30.3
    ## 16 YV        251           49.2
