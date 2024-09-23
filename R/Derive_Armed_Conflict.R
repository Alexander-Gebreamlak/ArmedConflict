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

Conflict_data$Year <- Conflict_data$year + 1
Conflict_data %>% select (-c(year))


Conflict_data_grouped <-  Conflict_data %>%
  group_by(ISO, Year) %>%
  summarize(Conflict = n_distinct(conflict_id)) %>%
  mutate(Conflict = case_when(
    Conflict >= 1 ~ 1,
    TRUE ~ 0
  ))

# Remember that the armed conflict variable was lagged by a year in the analysis.


