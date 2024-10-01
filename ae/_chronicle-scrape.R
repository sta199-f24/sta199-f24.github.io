# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(polite)

# check that we can scrape data from the chronicle -----------------------------

bow("https://www.dukechronicle.com")

# read page --------------------------------------------------------------------

page <- ___("https://www.dukechronicle.com/section/opinion?page=1&per_page=500")

# parse components -------------------------------------------------------------

titles <- page |>
  html_elements(".headline a") |>
  html_text()

columns <- page |>
  html_elements("___") |>
  ___

abstracts <- page |>
  ___("___") |>
  ___

authors_dates <- page |>
  html_elements("___") |>
  html_text2() |>
  ___

urls <- page |>
  html_elements(".headline a") |>
  html_attr(name = "___")

# create a data frame ----------------------------------------------------------

chronicle_raw <- tibble(
  # var name  = vector name 
  title       = titles,
  ___         = authors_dates,
  ___
  ___
  ___
)

# clean up data ----------------------------------------------------------------

chronicle <- chronicle_raw |>
  # separate author_date into author and date
  ___
  # fix dates and their type
  ___
  # tidy up column names
  ___

# write data -------------------------------------------------------------------

write_csv(chronicle, file = "___/chronicle.csv")
