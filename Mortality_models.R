library(plm)
library(tidyverse)
library(here)
library(texreg)
library(multgee)
library(table1)
library(dplyr)
library(tidyr)
library(usethis) 
library(countrycode)
library(htmltools)

fit_panel_models <- function(outcomes, predictors, data, index) {
  models <- list()
  
  # Loop through each outcome variable and fit the model
  for (outcome in outcomes) {
    # Create the formula for the current outcome by combining it with predictors
    formula <- as.formula(paste(outcome, paste("~", all.vars(predictors)[-1]), collapse = " + "))
    
    # Fit the panel model and store it in the list with the outcome name as the key
    models[[outcome]] <- plm(formula, data = data, model = "within", index = index)
  }
  
  # Return the list of models
  return(models)
}

# Define predictors (predictors are constant and don't change)
preds <- as.formula("~ armconf1 + gdp1000 + OECD + pctpopdens + urban + 
                     agedep + male_edu + temp + rainfall1000 + earthquake + drought + 
                     ISO + as.factor(year)")

# Define outcomes
outcomes <- c("matmor", "un5mor", "infmor", "neomor")

# Specify the panel index (e.g., "country" for cross-sectional ID, "year" for time)
# Ensure `finaldata` contains the specified index columns
index <- c("country", "year")

# Use the function to fit models
panel_model_list <- fit_panel_models(outcomes, preds, finaldata, index)
