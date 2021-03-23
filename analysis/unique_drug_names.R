## simple script to create new csv with unique drug names from the high cost drugs dataset

install.packages("tidyverse")
install.packages("here")
library(tidyverse)

column_names = c("DrugName", "HighCostTariffExcludedDrugCode", "DerivedSNOMEDFromName", "DerivedVTM", "DerivedVTMName", "NumOfAppearances")
drug_names <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "drug_name_summary.csv"), 
                       header = FALSE)

colnames(drug_names) <- column_names

drug_names_unique <- drug_names %>%
  mutate(DrugName = ifelse(DrugName == "﻿FLUOROURACIL", "FLUOROURACIL", DrugName)) %>%
  group_by(DrugName) %>%
  summarise()

write.csv(drug_names_unique, file = here::here("GitHub", "highcostdrugs-research","released-output", "drug_name_unique.csv"))
