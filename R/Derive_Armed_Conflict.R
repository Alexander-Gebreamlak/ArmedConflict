library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(table1)
library(dplyr)
library(tidyr)
library(usethis) 
library(countrycode)

#Loading Data
Conflict_data <- read.csv(here("original", "conflictdata.csv"), 
                        header = TRUE, na.strings=c(""))

Conflict_data$Year <- Conflict_data$year
Conflict_data %>% select (-c(year))
  
Conflict_data_grouped <- Conflict_data %>%
  mutate(best = as.numeric(best)) %>%  # Convert best column to numeric
  group_by(ISO, Year) %>%
  summarise(Totdeath = sum(best, na.rm = TRUE)) %>%  # Sum best, handle NAs
  mutate(Conflict = ifelse(Totdeath < 25, 0, 1)) %>%  # Create Conflict variable
  ungroup() %>%
  mutate(Year = Year + 1) -> Conflict_data_grouped

head(Conflict_data_grouped)

# Remember that the armed conflict variable was lagged by a year in the analysis.


