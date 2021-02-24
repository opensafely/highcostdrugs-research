# script to pull together a summary of the variables in the high cost drugs dataset

#install.packages("tidyverse")
#install.packages("here")

library(tidyverse)
library(here)

# setting options, display numbers to 2dp and to stop scientific notation
options(digits=2)
options(scipen = 999)

# read in csv files for all the summaries and add in column names, all files in same format
column_names = c("FinancialYear", "TotalRecords", "NULLRecords", "NumericRecords", "TotalUniqueValues")

ATC <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "ActivityTreatmentFunctionCode_summary_20210223.csv"), 
                       header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "ActivityTreatmentFunctionCode")

SNOMED <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DerivedSNOMED_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DerivedSNOMED")

VTM <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DerivedVTM_summary_20210223.csv"), 
                header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DerivedVTM")

VTM_Name <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DerivedVTMName_summary_20210223.csv"), 
                     header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DerivedVTMName")

DispRoute <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DispensingRoute_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DispensingRoute")

DrugName <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DrugName_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DrugName")

PackSize <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DrugPackSize_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DrugPackSize")

QuantOrWeight <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DrugQuantityOrWeightProp_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DrugQuanitityOrWeightProportion")

Strength <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DrugStrength_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DrugStrength")

Volume <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "DrugVolume_summary_20210223.csv"), 
                      header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "DrugVolume")

HCTEDC <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "HighCostTariffExcludedDrugCode_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "HighCostTariffExcludedDrugCode")

HomeDeliv <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "HomeDeliveryCharge_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "HomeDeliveryCharge")

Age <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "PersonAge_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "PersonAge")

Gender <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "PersonGender_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "PersonGender")

RouteOfAdmin <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "RouteOfAdministration_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "RouteOfAdministration")

TIC <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "TherapeuticIndicationCode_summary_20210223.csv"), 
                   header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "TherapeuticIndicationCode")

TotalCost <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "TotalCost_summary_20210223.csv"), 
                header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "TotalCost")

Unit <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "UOM_summary_20210223.csv"), 
                        header = FALSE, col.names = column_names) %>%
  mutate(VariableName = "UnitOfMeasurement")

# Then bring them all together in to one dataset
Variable_Summary <- union(Age, ATC) %>%
  union(., DispRoute) %>%
  union(., DrugName) %>%
  union(., Gender) %>%
  union(., HCTEDC) %>%
  union(., HomeDeliv) %>%
  union(., PackSize) %>%
  union(., QuantOrWeight) %>%
  union(., RouteOfAdmin) %>%
  union(., SNOMED) %>%
  union(., Strength) %>%
  union(., TIC) %>%
  union(., TotalCost) %>%
  union(., Unit) %>%
  union(., Volume) %>%
  union(., VTM) %>%
  union(., VTM_Name)

# check unique values for financial year - as some odd formatting when reading in data
unique(Variable_Summary$FinancialYear)

# need to clean up financial year variable and calculate some new variables
Variable_Summary <- Variable_Summary %>%
  mutate(FinancialYear = case_when(
    FinancialYear == "﻿201819" ~ "201819",
    FinancialYear == "﻿201920" ~ "201920",
    TRUE ~ FinancialYear)) %>%
  select(VariableName, FinancialYear, TotalRecords, NULLRecords, NumericRecords, TotalUniqueValues) %>%
  mutate(PropNULL = NULLRecords / TotalRecords,
         PropNumeric_OfTotal = NumericRecords / TotalRecords,
         PropNumeric_OfNotNULL = NumericRecords / (TotalRecords - NULLRecords))

# write as csv output
write.csv(Variable_Summary, here::here("GitHub", "highcostdrugs-research","released-output", "Variable_Summary.csv"))
