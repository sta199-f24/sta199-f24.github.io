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

# data source: Mary to add URL for data source

us_inflation_raw <- read_csv("lab/data/OECD.SDD.TPS,DSD_PRICES@DF_PRICES_ALL,1.0+USA.A.N.CPI.PA.CP12+CP11+CP10+CP09+CP08+CP07+CP06+CP05+CP04+CP03+CP02+CP01+_T.N.GY.csv")

us_inflation <- us_inflation_raw |>
  select(`Reference area`, `Expenditure`, TIME_PERIOD, OBS_VALUE) |>
  janitor::clean_names() |>
  filter(expenditure != "Total") |>
  rename(
    country = reference_area,
    expenditure = expenditure,
    year = time_period,
    annual_inflation = obs_value
  ) |>
  arrange(expenditure, year)

cpi_expenditures <- us_inflation |>
  distinct(expenditure) |>
  rowid_to_column(var = "cpi_expenditure_id") |>
  rename(cpi_expenditure_description = expenditure)

write_csv(us_inflation, "lab/data/us-inflation.csv")
write_csv(cpi_expenditures, "lab/data/cpi-expenditures.csv")
