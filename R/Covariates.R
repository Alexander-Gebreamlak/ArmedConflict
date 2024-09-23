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
Covariates_data <- read.csv(here("original", "covariates.csv"), 
                          header = TRUE, na.strings=c(""))

Covariates_data

# Source the scripts to load the datasets
source(here("R", "maternal_mortality.R"))
source(here("R", "Disaster.R"))
source(here("R", "Derive_Armed_Conflict.R"))

# Merge the datasets using full_join()
Final_data <- merged_mortality_data %>%
  full_join(disaster_final, by = c("Year", "ISO")) %>%
  full_join(Conflict_data_grouped, by = c("Year", "ISO"))

Final_data <- Final_data %>%
  filter(Year < 2020 )

head(Final_data, 10)

write.csv(Final_data, here("data", "Cleaned_primary_analysis_data.csv"), row.names = FALSE)

Final_data_check <-  Final_data %>%
  group_by(Country.Name) %>%
  summarize(count_rows = n_distinct(Year))

Final_data_check
  