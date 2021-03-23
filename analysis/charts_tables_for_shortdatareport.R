## script to produce charts and tables for hcd short data report

# install.packages("tidyverse")
# install.packages("here")
library(tidyverse)
library(here)

# read in datasets
nat_hcd <- read_csv(file = here::here("GitHub","highcostdrugs-research", "released-output", "summary_nat_hcd.csv"))

# sex and age summary
nat_hcd_age_sex <- nat_hcd %>%
  mutate(`age-sex group` =  paste(age_group, sex, sep = " ")) %>%
  filter((sex == "M" | sex == "F") & age_group != "<0") %>%
  group_by(`in_hcd`) %>%
  mutate(total_patient_count = sum(count_patients_redacted)) %>%
  ungroup() %>%
  group_by(`in_hcd`, `sex`) %>%
  mutate(total_patient_count_sex_specific = sum(count_patients_redacted)) %>%
  ungroup() %>%
  mutate(`Proportion of patients in age-sex group` = count_patients_redacted / total_patient_count,
         `Proportion of patients in age group` = count_patients_redacted / total_patient_count_sex_specific,
         `Patients in HCD dataset` = ifelse(in_hcd == 1, "Yes", "No"))

ggplot(data = nat_hcd_age_sex, aes(x = `age_group`, y = `Proportion of patients in age group`, fill = `Patients in HCD dataset`)) +
  geom_bar(position = "dodge",stat = "identity") +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90)) + 
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~`sex`)
  
ggsave(file = here::here("GitHub","highcostdrugs-research", "released-output", "age-sex-dist.png"),
       width = 15, height = 10, units = "cm")

