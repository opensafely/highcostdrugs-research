library(tidyverse)
library(here)

input <- read_csv(file = here::here("released-output", "drug_name_summary.csv"),
                  col_names = FALSE) %>%
  select(X1, X6) %>%
  dplyr::rename(`DrugName` = X1,
                `FreqCount` = X6)
  

adalimumab <- input %>%
  mutate(FreqCount = ifelse(FreqCount == "NULL", na(), FreqCount)) %>%
  mutate(LowerCaseDrugName = str_to_lower(DrugName)) %>%
  filter(grepl("adalimumab|amgevita|hyrimoz|humira|idacio|imraldi", LowerCaseDrugName)) %>%
  group_by(DrugName) %>%
  summarise(FreqCount = sum(FreqCount, na.rm = TRUE)) %>%
  arrange(desc(FreqCount))

top20_adalimumab <- adalimumab %>%
  top_n(20)

write.csv(top20_adalimumab, here::here("released-output", "top20_adalimumab.csv"))
  

  

