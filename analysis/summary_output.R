## script to produce summary tables for adalimumab study definition

# install.packages("tidyverse")
# install.packages("here")
library(tidyverse)
library(here)

# read in cohort
# expecting a dataset with four variables: age, sex, stp and prescribed_adalimumab
study_population <- read_csv(file = here::here("output", "input_adalimumab.csv"),
                             col_types = cols(
                               age = col_double(),
                               sex = col_character(),
                               stp = col_character(),
                               prescribed_adalimumab = col_integer()))

# create age groups
dataset_1 <- study_population %>%
  mutate(age_group = case_when(
    age < 0 ~ '<0',
    age >=0 & age <10 ~ '0-9',
    age >=10 & age <20 ~ '10-19',
    age >=20 & age <30 ~ '20-29',
    age >=30 & age <40 ~ '30-39',
    age >=40 & age <50 ~ '40-49',
    age >=50 & age <60 ~ '50-59',
    age >=60 & age <70 ~ '60-69',
    age >=70 & age <80 ~ '70-79',
    age >=80 & age <90 ~ '80-89',
    age >=90 & age <150 ~ '90+',
    TRUE ~ 'Other'),
    check = ifelse(age == 5, TRUE, FALSE))

# summarise by sex, age group, stp and prescribed_adalimumab
summary <- dataset_1 %>%
  group_by(stp, age_group, sex, prescribed_adalimumab) %>%
  summarise(count_patients = n())

# write out summary output
write.csv(summary, file = here::here("output", "summary_adalimumab.csv"))
