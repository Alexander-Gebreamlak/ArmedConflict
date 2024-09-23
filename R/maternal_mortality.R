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




