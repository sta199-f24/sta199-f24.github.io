library(tidyverse)

durham_climate <- tibble(
  month            = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
  avg_high_f       = c(49, 53, 62, 71, 79, 85, 89, 87, 81, 71, 62, 53),
  avg_low_f        = c(28, 29, 37, 46, 56, 65, 70, 68, 60, 47, 37, 30),
  precipitation_in = c(4.45, 3.70, 4.69, 3.43, 4.61, 4.02, 3.94, 4.37, 4.37, 3.70, 3.39, 3.43)
)

write_csv(nc_climate, "ae/data/durham-climate.csv")
