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

Covariates_data$Year <- Covariates_data$year

# Source the scripts to load the datasets
source(here("R", "maternal_mortality.R"))
source(here("R", "Disaster.R"))
source(here("R", "Derive_Armed_Conflict.R"))

# # Merge the datasets using full_join()
# Final_data <- merged_mortality_data %>%
#   full_join(disaster_final, by = c("Year", "ISO")) %>%
#   full_join(Conflict_data_grouped, by = c("Year", "ISO"))
# 
# Final_data <- Final_data %>%
#   filter(Year < 2020 )
# 
# head(Final_data, 10)

########################################################################################
#put all data frames into list
All_list <- list(Conflict_data_grouped, merged_mortality_data, disaster_final)

#merge all data frames in list
All_list |> reduce(full_join, by = c('ISO', 'Year')) -> Finaldata0

Final_data <- Covariates_data |>
  left_join(Finaldata0, by = c('ISO', 'Year'))

# need to fill in NAs with 0's for armconf1, drought, earthquake
Final_data <- Final_data |>
  mutate(Conflict = replace_na(Conflict, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         Totdeath = replace_na(Totdeath, 0))
########################################################################################

write.csv(Final_data, here("data", "Cleaned_primary_analysis_data.csv"), row.names = FALSE)

Final_data_check <-  Final_data %>%
  group_by(Country.Name) %>%
  summarize(count_rows = n_distinct(Year))

Final_data_check
