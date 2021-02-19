## simple script to create new csv with unique drug names from the high cost drugs dataset

# install.packages("tidyverse")
# install.packages("here")
library(tidyverse)

drug_list <- read.csv(file = here::here("GitHub", "highcostdrugs-research","released-output", "drug_name_unique.csv")) %>%
  select("DrugName")

colnames(drug_names) <- column_names

code_list_adalimumab <- drug_list %>%
  mutate(Check_adalimumab = str_detect(DrugName,"adalimumab"),
         Check_ADALIMUMAB = str_detect(DrugName,"ADALIMUMAB"),
         Check_Adalimumab = str_detect(DrugName,"Adalimumab"),
         In_Group = ifelse((Check_Adalimumab == TRUE | Check_adalimumab == TRUE | Check_ADALIMUMAB == TRUE), TRUE, FALSE)) %>%
  filter(In_Group == TRUE) %>%
  select(DrugName)

write.table(code_list_adalimumab, file = here::here("GitHub", "highcostdrugs-research","codelists", "code_list_adalimumab.csv"),
            row.names = FALSE, col.names = FALSE)
