library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(table1)
library(dplyr)
library(tidyr)
library(usethis) 

#Loading and Cleaning Data
rawdisaster <- read.csv(here("original", "disaster.csv"), 
                        header = TRUE, na.strings=c(""))

disaster_filter <- rawdisaster %>%
  filter(Year >= 2000 & Year <= 2019, 
         Disaster.Type %in% c("Earthquake", "Drought"))

disaster_select <- disaster_filter %>%
  select(Year, ISO, Disaster.Type)

disaster <- disaster_select %>%
  mutate(drought = case_when(Disaster.Type == "Drought" ~ 1,TRUE ~ 0),
         earthquake = case_when(Disaster.Type == "Earthquake" ~ 1, TRUE ~ 0))

disaster_final <- disaster %>%
  group_by(Year, ISO) %>%
  summarize(
    drought = sum(drought),     
    earthquake = sum(earthquake) 
  ) %>%
  ungroup()

write.csv(disaster_final, here("data", "cleaned_disaster.csv"), row.names = FALSE)
