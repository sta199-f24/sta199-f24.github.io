# Install 'gssr' from 'ropensci' universe
install.packages('gssr', repos =
                   c('https://kjhealy.r-universe.dev', 'https://cloud.r-project.org'))

# Also recommended: install 'gssrdoc' as well
install.packages('gssrdoc', repos =
                   c('https://kjhealy.r-universe.dev', 'https://cloud.r-project.org'))

library(gssr)
library(tidyverse)

gss22_raw <- gss_get_yr(year = 2022)

gss22 <- gss22_raw |>
  #select(advfront, polviews, educ) |>
  #drop_na() |>
  mutate(
    advfront = case_when(
      advfront == 1 ~ "Strongly agree", 
      advfront == 2 ~ "Agree", 
      advfront == 3 ~ "Disagree", 
      advfront == 4 ~ "Strongly disagree"
    ),
    polviews = case_when(
      polviews == 1 ~ "Extremely liberal",         
      polviews == 2 ~ "Liberal",      
      polviews == 3 ~ "Slightly liberal",         
      polviews == 4 ~ "Moderate",
      polviews == 5 ~ "Slightly conservative",      
      polviews == 6 ~ "Conservative",               
      polviews == 7 ~ "Extremely conservative"     
    )
  )

write_csv(gss22, file = "lab/data/gss22.csv")
