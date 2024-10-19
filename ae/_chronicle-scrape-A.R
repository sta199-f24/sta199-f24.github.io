# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(polite)

# check that we can scrape data from the chronicle -----------------------------

bow("https://www.dukechronicle.com")

# read page --------------------------------------------------------------------

page <- read_html("https://www.dukechronicle.com/section/opinion?page=1&per_page=500")

# parse components -------------------------------------------------------------

titles <- page |>
  html_elements(".headline a") |>
  html_text()

columns <- page |>
  html_elements(".col-md-8 .kicker") |>
  html_text()

abstracts <- page |>
  html_elements(".article-abstract") |>
  html_text2()

authors_dates <- page |>
  html_elements(".col-md-8 .dateline") |>
  html_text2() |>
  str_remove("By ")

urls <- page |>
  html_elements(".headline a") |>
  html_attr(name = "href")

# create a data frame ----------------------------------------------------------

chronicle_raw <- tibble(
  # var name  = vector name 
  title       = titles,
  author_date = authors_dates,
  abstract    = abstracts,
  column      = columns,
  url         = urls
)

# clean up data ----------------------------------------------------------------

chronicle <- chronicle_raw |>
  separate_wider_delim(author_date, delim = " | ", names = c("author", "date"), too_few = "align_start") |>
  mutate(
    date = case_when(
      str_detect(date, "minutes ago") ~ "September 30, 2024",
      str_detect(date, "hours ago") ~ "September 30, 2024",
      date == "Yesterday" ~ "September 29, 2024",
      date == "2 days ago" ~ "September 28, 2024",
      date == "3 days ago" ~ "September 27, 2024",
      date == "4 days ago" ~ "September 26, 2024",
      date == "5 days ago" ~ "September 25, 2024",
      date == "6 days ago" ~ "September 24, 2024",
      TRUE ~ date
    ),
    date = mdy(date),
    column = case_when(
      column == "OPINION" ~ "Opinion",
      column == "OPINION | CAMPUS VOICES" ~ "Campus Voices",
      column == "OPINION | LETTERS TO THE EDITOR" ~ "Letters to the Editor"
    )
  )

# write data -------------------------------------------------------------------

write_csv(chronicle, file = "data/chronicle.csv")
