library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(table1)
library(dplyr)
library(tidyr)
library(usethis) 

#Loading and cleaning Data

rawmaternalmortality <- read.csv(here("original", "maternalmortality.csv"), 
                                 header = TRUE, na.strings=c(""))

maternalmortality <- rawmaternalmortality %>%
  select(Country.Name, matches("^X20\\d{2}$"))

maternalmortality_long <- maternalmortality %>%
  pivot_longer(
    cols = X2000:X2019,         
    names_to = "Year",          
    names_prefix = "X",         
    values_to = "MatMor"        
  ) %>%
  mutate(Year = as.numeric(Year)) 

write.csv(maternalmortality_long, here("data", "cleaned_maternalmortality.csv"), row.names = FALSE)







read_mortality_data <- function(filename, output_filename, value_name) {
  # Reading the CSV file
  raw_mortality_data <- read.csv(here("original", filename), header = TRUE, na.strings = c(""))
  
  # Selecting only certain columns
  mortality_data <- raw_mortality_data %>%
    select(Country.Name, matches("^X20"))
  
  # Pivoting data to long format
  mortality_data_long <- mortality_data %>%
    pivot_longer(
      cols = starts_with("X20"),  
      names_to = "Year",           
      names_prefix = "X",          
      values_to = value_name      
    ) %>%
    mutate(Year = as.numeric(Year))  # Converting year to numeric
  
  # Saving the cleaned data to CSV
  write.csv(mortality_data_long, here("data", output_filename), row.names = FALSE)
  
  # Returning the long-format data frame
  return(mortality_data_long)
}

# Calling the function with appropriate arguments
cleaned_maternalmortality <- read_mortality_data("maternalmortality.csv", "cleaned_maternalmortality.csv", value_name = "MatMor")
cleaned_neonatalmortality <- read_mortality_data("neonatalmortality.csv", "cleaned_neonatalmortality.csv", value_name = "NeoMor")
cleaned_infantmortality <- read_mortality_data("infantmortality.csv", "cleaned_infantmortality.csv", value_name = "InfMor")
cleaned_under5mortality <- read_mortality_data("under5mortality.csv", "cleaned_under5mortality.csv", value_name = "Und5Mor")


# Create a list for all the datasets to join
mortality_list <- list(cleaned_maternalmortality, cleaned_neonatalmortality, cleaned_infantmortality, cleaned_under5mortality)

merged_mortality_data <- reduce(mortality_list, full_join, by = c("Country.Name", "Year"))

# View the final merged dataset
head(merged_mortality_data)

#Adding the ISO-3 country code variable to the new data set

library(countrycode)
merged_mortality_data$ISO <- countrycode(merged_mortality_data$Country.Name,
                            origin = "country.name",
                            destination = "iso3c")

merged_mortality_data %>% select (-c(Country.Name))

