# load packages ----------------------------------------------------------------

library(tidyverse)
library(readxl)

# data prep for country inflation / pivot --------------------------------------

# data source: https://data-explorer.oecd.org/vis?df[ds]=DisseminateFinalDMZ&df[id]=DSD_KEI%40DF_KEI&df[ag]=OECD.SDD.STES&dq=GBR%2BUSA%2BTUR%2BCHE%2BSWE%2BESP%2BSVN%2BSVK%2BPRT%2BPOL%2BNOR%2BNZL%2BNLD%2BMEX%2BLUX%2BLTU%2BLVA%2BKOR%2BJPN%2BITA%2BISR%2BIRL%2BISL%2BHUN%2BGRC%2BDEU%2BFIN%2BCRI%2BEST%2BDNK%2BCZE%2BFRA%2BCOL%2BCHL%2BCAN%2BBEL%2BAUT%2BAUS.A.CP.GR...G1&pd=1993%2C2023&to[TIME_PERIOD]=false&vw=tb

country_inflation_raw <- read_excel("lab/data-raw/OECD.SDD.STES,DSD_KEI@DF_KEI,,filtered,2024-09-15 21-01-38.xlsx", skip = 4)

country_inflation_wide <- country_inflation_raw |>
  slice(-1) |>
  slice(-39, -40) |>
  select(-`Time period...2`, -`...34`) |>
  rename(country = `Time period...1`)

write_csv(country_inflation_wide, "lab/data/country-inflation.csv")

# check

read_csv("lab/data/country-inflation.csv") |> names()

# data prep for us inflation / join --------------------------------------------

# data source: https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CEconomy%23ECO%23%7CPrices%23ECO_PRI%23&pg=0&fc=Topic&bp=true&snb=16&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_PRICES%40DF_PRICES_ALL&df[ag]=OECD.SDD.TPS&df[vs]=1.0&pd=2011%2C2024&dq=USA.A.N.CPI.PA.CP12%2BCP11%2BCP10%2BCP09%2BCP08%2BCP07%2BCP06%2BCP05%2BCP04%2BCP03%2BCP02%2BCP01%2B_T.N.GY&to[TIME_PERIOD]=false&vw=tb
# see also https://www.oecd.org/en/data/insights/data-explainers/2024/07/consumer-price-indices-frequently-asked-questions-faqs.html
# under 2. Where can I download CPIs data?

us_inflation_raw <- read_csv("lab/data-raw/OECD.SDD.TPS,DSD_PRICES@DF_PRICES_ALL,1.0+USA.A.N.CPI.PA.CP12+CP11+CP10+CP09+CP08+CP07+CP06+CP05+CP04+CP03+CP02+CP01+_T.N.GY.csv")

us_inflation_temp <- us_inflation_raw |>
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

cpi_expenditures <- us_inflation_temp |>
  distinct(expenditure) |>
  rowid_to_column(var = "id") |>
  rename(description = expenditure)

us_inflation <- us_inflation_temp |>
  left_join(cpi_expenditures, by = join_by(expenditure == description)) |>
  rename(cpi_expenditure_id = id) |>
  select(country, cpi_expenditure_id, year, annual_inflation)

write_csv(us_inflation, "lab/data/us-inflation.csv")
write_csv(cpi_expenditures, "lab/data/cpi-expenditures.csv")

# check

read_csv("lab/data/us-inflation.csv") |> names()
read_csv("lab/data/us-inflation.csv") |> distinct(year)
read_csv("lab/data/cpi-expenditures.csv") |> names()
