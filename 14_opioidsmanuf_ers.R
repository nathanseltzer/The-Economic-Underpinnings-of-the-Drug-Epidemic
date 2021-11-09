## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: ERS Educ Data Import and Prep
## File: 14_opioidsmanuf_ers.R
## Description: Imports and prepares Census data compiled by USDA ERS


library(tidyverse)
library(data.table)
library(foreign)
library(zoo)


ers_path <- "V:/seltzer/mortality"

ers <- fread(paste0(ers_path, "/data/ers/Education_data_ERS_USDA_1970-2018_CLEAN.csv")) %>%
  filter(State != "PR", nchar(county_fips)!=1, substrRight(county_fips,3)!= "000")


##lths
ers_a <- ers  %>%
  select(county_fips, lths1970, lths1980, lths1990, lths2000, lths2016) %>%
  mutate(missing = ifelse(is.na(lths1970)==TRUE, 1,
                          ifelse(is.na(lths1980)==TRUE, 1,
                                 ifelse(is.na(lths1990)==TRUE, 1,
                                        ifelse(is.na(lths2000)==TRUE, 1,
                                               ifelse(is.na(lths2016)==TRUE, 1, 0)))))) %>%
  filter(missing == 0) %>%
  gather("stat", "pct_lths", 2:6) %>%
  mutate(year = as.numeric(substrRight(stat, 4)),
         missing2 = as.numeric(is.na(pct_lths)==TRUE))


ers_container <- ers_a %>%
  select(county_fips) %>%
  expand(county_fips, year = 1970:2016)


ers_b_lths <- left_join(ers_container, ers_a) %>%
  group_by(county_fips) %>%
  # summarize(test = sum(test))
  # filter(county_fips == 1001) %>%
  mutate(pct_intrp_lths = na.approx(pct_lths, na.rm = TRUE)) %>%
  select(-missing, -stat, -missing2)


##hs
ers_a_hs <- ers  %>%
  select(county_fips, hs1970, hs1980, hs1990, hs2000, hs2016) %>%
  mutate(missing = ifelse(is.na(hs1970)==TRUE, 1,
                          ifelse(is.na(hs1980)==TRUE, 1,
                                 ifelse(is.na(hs1990)==TRUE, 1,
                                        ifelse(is.na(hs2000)==TRUE, 1,
                                               ifelse(is.na(hs2016)==TRUE, 1, 0)))))) %>%
  filter(missing == 0) %>%
  gather("stat", "pct_hs", 2:6) %>%
  mutate(year = as.numeric(substrRight(stat, 4)),
         missing2 = as.numeric(is.na(pct_hs)==TRUE))


ers_container <- ers_a %>%
  select(county_fips) %>%
  expand(county_fips, year = 1970:2016)


ers_b_hs <- left_join(ers_container, ers_a_hs) %>%
  group_by(county_fips) %>%
  # summarize(test = sum(test))
  # filter(county_fips == 1001) %>%
  mutate(pct_intrp_hs = na.approx(pct_hs, na.rm = TRUE)) %>%
  select(-missing, -stat, -missing2)

##sc
ers_a_sc <- ers  %>%
  select(county_fips, sc1970, sc1980, sc1990, sc2000, sc2016) %>%
  mutate(missing = ifelse(is.na(sc1970)==TRUE, 1,
                          ifelse(is.na(sc1980)==TRUE, 1,
                                 ifelse(is.na(sc1990)==TRUE, 1,
                                        ifelse(is.na(sc2000)==TRUE, 1,
                                               ifelse(is.na(sc2016)==TRUE, 1, 0)))))) %>%
  filter(missing == 0) %>%
  gather("stat", "pct_sc", 2:6) %>%
  mutate(year = as.numeric(substrRight(stat, 4)),
         missing2 = as.numeric(is.na(pct_sc)==TRUE))


ers_container <- ers_a %>%
  select(county_fips) %>%
  expand(county_fips, year = 1970:2016)


ers_b_sc <- left_join(ers_container, ers_a_sc) %>%
  group_by(county_fips) %>%
  # summarize(test = sum(test))
  # filter(county_fips == 1001) %>%
  mutate(pct_intrp_sc = na.approx(pct_sc, na.rm = TRUE)) %>%
  select(-missing, -stat, -missing2)

##ba
ers_a_ba <- ers  %>%
  select(county_fips, ba1970, ba1980, ba1990, ba2000, ba2016) %>%
  mutate(missing = ifelse(is.na(ba1970)==TRUE, 1,
                          ifelse(is.na(ba1980)==TRUE, 1,
                                 ifelse(is.na(ba1990)==TRUE, 1,
                                        ifelse(is.na(ba2000)==TRUE, 1,
                                               ifelse(is.na(ba2016)==TRUE, 1, 0)))))) %>%
  filter(missing == 0) %>%
  gather("stat", "pct_ba", 2:6) %>%
  mutate(year = as.numeric(substrRight(stat, 4)),
         missing2 = as.numeric(is.na(pct_ba)==TRUE))


ers_container <- ers_a %>%
  select(county_fips) %>%
  expand(county_fips, year = 1970:2016)


ers_b_ba <- left_join(ers_container, ers_a_ba) %>%
  group_by(county_fips) %>%
  # summarize(test = sum(test))
  # filter(county_fips == 1001) %>%
  mutate(pct_intrp_ba = na.approx(pct_ba, na.rm = TRUE)) %>%
  select(-missing, -stat, -missing2)


ers_final <- left_join(ers_b_lths, ers_b_hs)%>%
             left_join(ers_b_sc) %>%
             left_join(ers_b_ba) %>%
             rename_at(vars(-county_fips, -year),function(x) paste0(x,"_lag")) %>%
             mutate(year = year + 1)

write.dta(ers_final, paste0(ers_path, "/ERS_pct_educ_CLEAN.dta"))
fwrite(ers_final, paste0(ers_path, "/ERS_pct_educ_CLEAN.csv"))
