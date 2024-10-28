library(tidyverse)
library(readxl)

gdp_percap_raw <- read_excel("lab/data-raw/gapminder-gdp-percap.xlsx") |>
  select(country, `2000`:`2023`) |>
  mutate(country = if_else(country == "Turkey", "Türkiye", country))
life_exp_raw <- read_csv("lab/data-raw/gapminder-life-exp.csv") |>
  select(country, `2000`:`2023`) |>
  mutate(country = if_else(country == "Turkey", "Türkiye", country))
#continents_gapminder <- read_csv("lab/data-raw/gapminder-continents.csv") |>
#  distinct(country, continent)
continents_other <- read_csv("lab/data-raw/continents.csv") |> 
  select(entity, continent)

gdp_percap <- gdp_percap_raw |>
  left_join(continents_other, join_by(country == entity)) |>
  relocate(country, continent) |>
  mutate(continent = case_when(
    country == "UAE" ~ "Asia",
    country == "Bahamas" ~ "Americas",
    str_detect(country, "Congo") ~ "Africa",
    country == "Cape Verde" ~ "Africa",
    country == "Czech Republic" ~ "Europe",
    country == "Micronesia, Fed. Sts." ~ "Oceania",
    country == "UK" ~ "Europe",
    country == "Gambia" ~ "Africa",
    country == "Hong Kong, China" ~ "Asia",
    country == "Kyrgyz Republic" ~ "Asia",
    country == "Lao" ~ "Asia",
    country == "Türkiye" ~ "Asia",
    country == "USA" ~ "Americas",
    .default = continent
    )
  )

life_exp <- life_exp_raw |>
  left_join(continents_other, join_by(country == entity)) |>
  relocate(country, continent) |>
  mutate(continent = case_when(
    country == "UAE" ~ "Asia",
    country == "Bahamas" ~ "Americas",
    str_detect(country, "Congo") ~ "Africa",
    country == "Cape Verde" ~ "Africa",
    country == "Czech Republic" ~ "Europe",
    country == "Micronesia, Fed. Sts." ~ "Oceania",
    country == "UK" ~ "Europe",
    country == "Gambia" ~ "Africa",
    country == "Hong Kong, China" ~ "Asia",
    country == "Kyrgyz Republic" ~ "Asia",
    country == "Lao" ~ "Asia",
    country == "Türkiye" ~ "Asia",
    country == "USA" ~ "Americas",
    .default = continent
  )
  )

# check
gdp_percap |>
  filter(is.na(continent)) |>
  select(country, continent)

life_exp |>
  filter(is.na(continent)) |>
  select(country, continent)

# pivot

gdp_percap_longer <- gdp_percap |>
  pivot_longer(
    cols = `2000`:`2023`,
    names_to = "year",
    names_transform = as.numeric,
    values_to = "gdp_percap"
  )

life_exp_longer <- life_exp |>
  pivot_longer(
    cols = `2000`:`2023`,
    names_to = "year",
    names_transform = as.numeric,
    values_to = "life_exp"
  )

# join

gapminder <- gdp_percap_longer |>
  full_join(life_exp_longer, join_by(country, continent, year))

write_csv(gapminder, file = "lab/data/gapminder.csv")

# check

gapminder |>
  count(country, continent, year, sort = TRUE)

gapminder |>
  filter(
    year == 2023,
    str_detect(gdp_percap, "k")
  )

gapminder_2023 <- gapminder |>
  filter(year == 2023) |>
  mutate(
    gdp_percap_clean = if_else(str_detect(gdp_percap, "k"), as.numeric(str_remove(gdp_percap, "k"))*1000, as.numeric(gdp_percap))
  )

gapminder_2023 |>
  filter(is.na(gdp_percap_clean))

ggplot(gapminder_2023, aes(x = gdp_percap_clean, y = life_exp)) +
  geom_point()

ggplot(gapminder_2023, aes(x = gdp_percap_clean, y = log(life_exp))) +
  geom_point()
