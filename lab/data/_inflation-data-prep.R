# load packages ----------------------------------------------------------------

library(tidyverse)
library(readxl)

# data prep for country inflation / pivot --------------------------------------

# data source: https://data-explorer.oecd.org/vis?df[ds]=DisseminateFinalDMZ&df[id]=DSD_KEI%40DF_KEI&df[ag]=OECD.SDD.STES&dq=GBR%2BUSA%2BTUR%2BCHE%2BSWE%2BESP%2BSVN%2BSVK%2BPRT%2BPOL%2BNOR%2BNZL%2BNLD%2BMEX%2BLUX%2BLTU%2BLVA%2BKOR%2BJPN%2BITA%2BISR%2BIRL%2BISL%2BHUN%2BGRC%2BDEU%2BFIN%2BCRI%2BEST%2BDNK%2BCZE%2BFRA%2BCOL%2BCHL%2BCAN%2BBEL%2BAUT%2BAUS.A.CP.GR...G1&pd=1993%2C2023&to[TIME_PERIOD]=false&vw=tb

country_inflation_raw <- read_excel("lab/data/OECD.SDD.STES,DSD_KEI@DF_KEI,,filtered,2024-09-15 21-01-38.xlsx", skip = 4)

country_inflation_wide <- country_inflation_raw |>
  slice(-1) |>
  slice(-39, -40) |>
  select(-`Time period...2`, -`...34`) |>
  rename(country = `Time period...1`)

write_csv(country_inflation_wide, "lab/data/country-inflation.csv")

# data prep for us inflation / join --------------------------------------------

# data source: 

us_inflation_raw <- read_csv("lab/data/PRICES_CPI_19092022031404285.csv")

us_inflation_temp <- us_inflation_raw |>
  filter(Measure == "Percentage change on the same period of the previous year") |>
  select(Country, Subject, Time, Value) |>
  janitor::clean_names() |>
  rename(
    year = time,
    annual_inflation = value
    ) |>
  filter(
    subject != "CPI: 01-12 - All items",
    str_detect(subject, "CPI: [0-9][0-9] "),
    year >= 2011
    ) |>
  mutate(subject = str_remove(subject, "CPI: ")) |>
  separate(subject, sep = " - ", into = c("subject_id", "subject_description")) |>
  mutate(subject_id = as.numeric(subject_id)) |>
  rename(
    cpi_division_id = subject_id,
    cpi_division_description = subject_description
  )

us_inflation <- us_inflation_temp |>
  select(country, cpi_division_id, year, annual_inflation) |>
  arrange(cpi_division_id, year)

cpi_divisions <- us_inflation_temp |>
  distinct(cpi_division_id, cpi_division_description) |>
  arrange(cpi_division_id) |>
  rename(
    id = cpi_division_id,
    description = cpi_division_description
  )

write_csv(us_inflation, "lab/data/us-inflation.csv")
write_csv(cpi_divisions, "lab/data/cpi-divisions.csv")

# join: join other inflation indices for the US --------------------------------

us_inflation <- read_csv("lab/data/us-inflation.csv")
cpi_divisions <- read_csv("lab/data/cpi-divisions.csv")

