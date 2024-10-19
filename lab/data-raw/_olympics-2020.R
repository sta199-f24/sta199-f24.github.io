# load packages ----------------------------------------------------------------

library(tidyverse)

# load data --------------------------------------------------------------------

olympics_2020_raw <- read_csv("lab/data-raw/olympics-2020-raw.csv")

# create gender column ---------------------------------------------------------

olympics_2020 <- olympics_2020_raw |>
  mutate(
    Gender = case_when(
      str_detect(Event, "Baseball") ~ "Male",
      str_detect(Event, " Men") ~ "Male",
      str_detect(Event, " Women") ~ "Female",
      str_detect(Event, "^M ") ~ "Male",
      str_detect(Event, "^W ") ~ "Female",
      str_detect(Sport, "\\(Women\\)") ~ "Female",
      str_detect(Sport, "\\(Men\\)") ~ "Male",
      str_detect(Event, "Men ") ~ "Male",
      str_detect(Event, "Women") ~ "Female",
      str_detect(Event, "W Individual") ~ "Female",
      Event == "Men - BMX" ~ "Male",
      Event == "Men" ~ "Male",
      Event == "Women" ~ "Female",
      (`First Name` == "Sabine" & `Last Name` == "Schut-Kery") ~ "Female",
      (`First Name` == "Steffen" & `Last Name` == "Peters") ~ "Female",
      (`First Name` == "Isabelle" & `Last Name` == "Connor") ~ "Female",
      (`First Name` == "Riley" & `Last Name` == "Gibbs") ~ "Female",
      (`First Name` == "Adrienne" & `Last Name` == "Lyle") ~ "Female",
      (`First Name` == "Laura" & `Last Name` == "Kraut") ~ "Female",
      (`First Name` == "Kent" & `Last Name` == "Farrington") ~ "Male",
      (`First Name` == "Anna" & `Last Name` == "Weis") ~ "Female",
      (`First Name` == "Elija" & `Last Name` == "Godwin") ~ "Male",
      (`First Name` == "Camilla" & `Last Name` == "Feeley") ~ "Female",
      (`First Name` == "Evita" & `Last Name` == "Griskenas") ~ "Female",
      (`First Name` == "Laura" & `Last Name` == "Zeng") ~ "Female",
      (`First Name` == "Lili" & `Last Name` == "Mizuno") ~ "Female",
      (`First Name` == "Nicole" & `Last Name` == "Sladkov") ~ "Female",
      (`First Name` == "Lynna" & `Last Name` == "Irby") ~ "Female",
      (`First Name` == "Lindi" & `Last Name` == "Schroeder") ~ "Female",
      (`First Name` == "Taylor" & `Last Name` == "Manson") ~ "Female",
      (`First Name` == "Jessica" & `Last Name` == "Springsteen") ~ "Female",
      (`First Name` == "Anita" & `Last Name` == "Alvarez") ~ "Female",
      (`First Name` == "Boyd" & `Last Name` == "Martin") ~ "Male",
      (`First Name` == "Phillip" & `Last Name` == "Dutton") ~ "Female",
      (`First Name` == "Doug" & `Last Name` == "Payne") ~ "Female",
      (`First Name` == "Elizaveta" & `Last Name` == "Pletneva") ~ "Female",
      (`First Name` == "Bryce" & `Last Name` == "Deadmon") ~ "Female"
    ),
    Event = case_when(
      # men
      Sport == "Basketball (Men)" ~ "Basketball (Men)",
      Sport == "Gymnastic (Artistic)" & Event == "Men" ~ "Gymnastic (Artistic) Men",
      Sport == "Gymnastics (Trampoline)" & Event == "Men" ~ "Gymnastics (Trampoline) Men",
      Sport == "Rugby (Men)" ~ "Rugby (Men)",
      Sport == "Volleyball (Beach)" & Event == "Men" ~ "Volleyball (Beach) Men",
      Sport == "Volleyball (Men)" ~ "Volleyball (Men)",
      Sport == "Water Polo (Men)" ~ "Water Polo (Men)",
      Sport == "Surfing" & Event == "Men" ~ "Surfing (Men)",
      # women
      Sport == "Basketball (Women)" ~ "Basketball (Women)",
      Sport == "Basketball (3x3)" & Event == "Women" ~ "Basketball (3x3) (Women)",
      Sport == "Gymnastic (Artistic)" & Event == "Women" ~ "Gymnastic (Artistic) Women",
      Sport == "Gymnastics (Trampoline)" & Event == "Women" ~ "Gymnastics (Trampoline) Women",
      Sport == "Rugby (Women)" ~ "Rugby (Women)",
      Sport == "Soccer (Women)" ~ "Soccer (Women)",
      Sport == "Volleyball (Beach)" & Event == "Women" ~ "Volleyball (Beach) Women",
      Sport == "Volleyball (Women)" ~ "Volleyball (Women)",
      Sport == "Water Polo (Women)" ~ "Water Polo (Women)",
      Sport == "Surfing" & Event == "Women" ~ "Surfing (Women)",
      .default = Event
    )
  ) |>
  relocate(Gender, .before = Event)

# save data --------------------------------------------------------------------

write_csv(olympics_2020, file = "lab/data-raw/olympics-2020.csv")
