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
