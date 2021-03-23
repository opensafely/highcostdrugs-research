## script to produce summary tables for hcd study definition

# install.packages("tidyverse")
# install.packages("here")
library(tidyverse)
library(here)

# read in cohort
# expecting a dataset with five variables: age, sex, stp, ethnicity and in_hcd
study_population <- read_csv(file = here::here("output", "input_hcd.csv"),
                             col_types = cols(
                               age = col_double(),
                               sex = col_character(),
                               stp = col_character(),
                               ethnicity = col_integer(),
                               in_hcd = col_integer()))

# data cleaning
# create age groups
dataset_1 <- study_population %>%
  mutate(
    `age group` = case_when(
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
    `ethnicity group` = case_when(
      ethnicity == 1 ~ 'White',
      ethnicity == 2 ~ 'Mixed',
      ethnicity == 3 ~ 'Asian',
      ethnicity == 4 ~ 'Black',
      ethnicity == 5 ~ 'Other',
      is.na(ethnicity) ~ 'Missing'),
    `In HCD dataset` = ifelse(in_hcd == 1, 'Yes', 'No')
    )

# Creating outputs

# Age/sex summary
summary_agesex = dataset_1 %>%
  filter((sex == "F" | sex == "M") & `age group` != '<0') %>%
  group_by(`age group`, sex, `In HCD dataset`) %>%
  summarise(`Number of patients` = n()) %>%
  group_by(`In HCD dataset`, `sex`) %>%
  mutate(`Total patients - by sex` = sum(`Number of patients`)) %>%
  ungroup() %>%
  mutate(`Distribution of patients across age groups` = `Number of patients` / `Total patients - by sex`)

ggplot(data = summary_agesex, aes(x = `age group`, y = `Distribution of patients across age groups`, fill = `In HCD dataset`)) +
  geom_bar(position = "dodge",stat = "identity") +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90)) + 
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~`sex`)

write.csv(summary_agesex, file = here::here("output", "summary_agesex.csv"))

ggsave(file = here::here("output", "age-sex-dist.png"),
       width = 15, height = 10, units = "cm")

# Ethnicity/sex summary
summary_ethnicitysex = dataset_1 %>%
  filter((sex == "F" | sex == "M")) %>%
  group_by(`ethnicity group`, sex, `In HCD dataset`) %>%
  summarise(`Number of patients` = n()) %>%
  group_by(`In HCD dataset`, `sex`) %>%
  mutate(`Total patients - by sex` = sum(`Number of patients`)) %>%
  ungroup() %>%
  mutate(`Distribution of patients across ethnicity groups` = `Number of patients` / `Total patients - by sex`)

ggplot(data = summary_ethnicitysex, aes(x = `ethnicity group`, y = `Distribution of patients across ethnicity groups`, fill = `In HCD dataset`)) +
  geom_bar(position = "dodge",stat = "identity") +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 90)) + 
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~`sex`)

write.csv(summary_ethnicitysex, file = here::here("output", "summary_ethnicitysex.csv"))

ggsave(file = here::here("output", "ethnicity-sex-dist.png"),
       width = 15, height = 10, units = "cm")

# STP summary
summary_STP = dataset_1 %>%
  group_by(stp, `In HCD dataset`) %>%
  summarise(`Number of patients` = n()) %>%
  group_by(stp) %>%
  mutate(`Total patients - by stp` = sum(`Number of patients`)) %>%
  ungroup() %>%
  filter(`In HCD dataset` == 'Yes') %>%
  mutate(`Proportion of patients in HCD datset` = `Number of patients` / `Total patients - by stp`)

ggplot(data = summary_STP, aes(x = `stp`, y = `Proportion of patients in HCD datset`)) +
  geom_bar(position = "dodge",stat = "identity") +
  theme_bw() +
  theme(legend.position = "bottom") + 
  scale_y_continuous(labels = scales::percent) +
  coord_flip()

write.csv(summary_STP, file = here::here("output", "summary_stp.csv"))

ggsave(file = here::here("output", "stp-dist.png"),
       width = 15, height = 20, units = "cm")
