## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Mortality Rate Creator - RACE and SEX
## File: 02b_opioidsmanuf_mort_ratecreator_racesex.R
## Description: Creates county, commuting zone, CBSA, and state mortality rates
##  for opioids, non-opioids, and drug overdose deaths for race and sex subgroups

###############################################################################
## 4.0 STATE SEX RACE ---------------------------------------------------------
###############################################################################

NCHS_tot_pop_1 <- fread("V:/obrien ssa/data/clean/NCHS_tot_pop_1.csv")

# mort_full3 <- fread( "V:/seltzer/mortality/data/full_mortality_data_1999_2017_mort_full3_-RESTRICTED_keeponwinstat.csv")



table(filter(mort_full3, year <= 2002)$hispanic) ## nonhispanic coded 0 during 2000 and prior
table(filter(mort_full3, year > 2002)$hispanic) ## nonhispanic coded 100-199 after 2002


mort_full4_sexrace_state_drug <- mort_full3 %>%
  filter(race == 1 | race == 2) %>% # keep only white and black decedents
  filter(hispanic == 0 | hispanic == 100) %>% ## keep only nonhispanic decedents
  group_by(state_fips, agecat, sex, race, year, ucod) %>%
  summarize(deaths = sum(death, na.rm = TRUE))

mort_full4_sexrace_state_with_opioid <- mort_full3 %>%
  filter(race == 1 | race == 2) %>% # keep only white and black decedents
  filter(hispanic == 0 | hispanic == 100) %>% ## keep only nonhispanic decedents
  group_by(state_fips, agecat, sex, race, year, ucod, opioid) %>%
  summarize(deaths = sum(death, na.rm = TRUE))


NCHS_sexrace_pop_state_drug <- NCHS_tot_pop_1 %>%
  rename(year = YEAR,
         state_fips = ST_FIPS2) %>%
  mutate(sex = ifelse(female==0, 1,
                      ifelse(female==1, 2, NA)),
         race = ifelse(race=="white", 1,
                       ifelse(race=="black", 2, NA))) %>%
  filter(raceeth == "nhwhite" | raceeth == "nhblack") %>%
  group_by(state_fips, year, sex, race, agecat) %>%
  summarize(tot_pop = sum(pop, na.rm = TRUE)) %>%
  left_join(standardpop, by = "agecat")


## 4.1 STATE all drug death ----------------------------------------------------

mort_full5_sexrace_state_drug <- mort_full4_sexrace_state_drug %>%
  filter(ucod == "X40" |
           ucod == "X41" |
           ucod == "X42" |
           ucod == "X43" |
           ucod == "X44" |
           ucod == "X60" |
           ucod == "X61" |
           ucod == "X62" |
           ucod == "X63" |
           ucod == "X64" |
           ucod == "X85" |
           ucod == "Y10" |
           ucod == "Y11" |
           ucod == "Y12" |
           ucod == "Y13" | 
           ucod == "Y14" ) %>%
  right_join(NCHS_sexrace_pop_state_drug) %>%
  mutate(age_crude_sex = (deaths/tot_pop)*100000,
         age_weight = age_crude_sex*weight) %>%
  arrange( state_fips, year, agecat, sex)

mort_full6_sexrace_state_drug <- mort_full5_sexrace_state_drug %>%
  group_by(state_fips, sex, race, year) %>%
  summarize(deaths_sex_drug_state = sum(deaths, na.rm=TRUE),
            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
            cr_sex = sum(deaths_sex_drug_state/tot_pop_sex, na.rm = TRUE)*100000,
            asmr_sex_drug_state = sum(age_weight, na.rm = TRUE)) %>%
  filter(year > 1997) %>%
  select(-cr_sex, -tot_pop_sex)

mort_full7_sexrace_state_drug <- mort_full6_sexrace_state_drug %>%
  select(-deaths_sex_drug_state) 

mort_full8_sexrace_state_drug <- mort_full7_sexrace_state_drug %>%
  spread(race, asmr_sex_drug_state)

mort_full9_sexrace_state_drug_M <- filter(mort_full8_sexrace_state_drug, sex == 1)%>%
  rename(asmr_NHWM_drug_state = `1`,
         asmr_NHBM_drug_state = `2`) %>%
  ungroup() %>%
  select(-sex)

mort_full9_sexrace_state_drug_F <- filter(mort_full8_sexrace_state_drug, sex == 2)%>%
  rename(asmr_NHWF_drug_state = `1`,
         asmr_NHBF_drug_state = `2`) %>%
  ungroup() %>%
  select(-sex)


mort_full10_sexrace_state_drug <- left_join(mort_full9_sexrace_state_drug_M, mort_full9_sexrace_state_drug_F)


## 4.2 STATE opioid drug death -------------------------------------------------

mort_full4_sexrace_state_opioid <- mort_full4_sexrace_state_with_opioid %>%
  filter(opioid == 1)

mort_full5_sexrace_state_opioid <- mort_full4_sexrace_state_opioid %>%
  filter(ucod == "X40" |
           ucod == "X41" |
           ucod == "X42" |
           ucod == "X43" |
           ucod == "X44" |
           ucod == "X60" |
           ucod == "X61" |
           ucod == "X62" |
           ucod == "X63" |
           ucod == "X64" |
           ucod == "X85" |
           ucod == "Y10" |
           ucod == "Y11" |
           ucod == "Y12" |
           ucod == "Y13" | 
           ucod == "Y14" ) %>%
  right_join(NCHS_sexrace_pop_state_drug) %>%
  mutate(age_crude_sex = (deaths/tot_pop)*100000,
         age_weight = age_crude_sex*weight) %>%
  arrange( state_fips, year, agecat, sex)

mort_full6_sexrace_state_opioid <- mort_full5_sexrace_state_opioid %>%
  group_by(state_fips, sex, race, year) %>%
  summarize(deaths_sex_opioid_state = sum(deaths, na.rm=TRUE),
            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
            cr_sex = sum(deaths_sex_opioid_state/tot_pop_sex, na.rm = TRUE)*100000,
            asmr_sex_opioid_state = sum(age_weight, na.rm = TRUE)) %>%
  filter(year > 1997) %>%
  select(-cr_sex, -tot_pop_sex)

mort_full7_sexrace_state_opioid <- mort_full6_sexrace_state_opioid %>%
  select(-deaths_sex_opioid_state) 

mort_full8_sexrace_state_opioid <- mort_full7_sexrace_state_opioid %>%
  spread(race, asmr_sex_opioid_state)

mort_full9_sexrace_state_opioid_M <- filter(mort_full8_sexrace_state_opioid, sex == 1)%>%
  rename(asmr_NHWM_opioid_state = `1`,
         asmr_NHBM_opioid_state = `2`) %>%
  ungroup() %>%
  select(-sex)

mort_full9_sexrace_state_opioid_F <- filter(mort_full8_sexrace_state_opioid, sex == 2)%>%
  rename(asmr_NHWF_opioid_state = `1`,
         asmr_NHBF_opioid_state = `2`) %>%
  ungroup() %>%
  select(-sex)


mort_full10_sexrace_state_opioid <- left_join(mort_full9_sexrace_state_opioid_M, mort_full9_sexrace_state_opioid_F)


## 4.3 STATE non-opioid drug death ----------------------------------------------

mort_full4_sexrace_state_nonopioid <- mort_full4_sexrace_state_with_opioid %>%
  filter(is.na(opioid) == TRUE)

mort_full5_sexrace_state_nonopioid <- mort_full4_sexrace_state_nonopioid %>%
  filter(ucod == "X40" |
           ucod == "X41" |
           ucod == "X42" |
           ucod == "X43" |
           ucod == "X44" |
           ucod == "X60" |
           ucod == "X61" |
           ucod == "X62" |
           ucod == "X63" |
           ucod == "X64" |
           ucod == "X85" |
           ucod == "Y10" |
           ucod == "Y11" |
           ucod == "Y12" |
           ucod == "Y13" | 
           ucod == "Y14" ) %>%
  right_join(NCHS_sexrace_pop_state_drug) %>%
  mutate(age_crude_sex = (deaths/tot_pop)*100000,
         age_weight = age_crude_sex*weight) %>%
  arrange( state_fips, year, agecat, sex, race)

mort_full6_sexrace_state_nonopioid <- mort_full5_sexrace_state_nonopioid %>%
  group_by(state_fips, sex, race, year) %>%
  summarize(deaths_sex_nonopioid_state = sum(deaths, na.rm=TRUE),
            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
            cr_sex = sum(deaths_sex_nonopioid_state/tot_pop_sex, na.rm = TRUE)*100000,
            asmr_sex_nonopioid_state = sum(age_weight, na.rm = TRUE)) %>%
  filter(year > 1997) %>%
  select(-cr_sex, -tot_pop_sex)


mort_full7_sexrace_state_nonopioid <- mort_full6_sexrace_state_nonopioid %>%
  select(-deaths_sex_nonopioid_state) 

mort_full8_sexrace_state_nonopioid <- mort_full7_sexrace_state_nonopioid %>%
      spread(race, asmr_sex_nonopioid_state)

mort_full9_sexrace_state_nonopioid_M <- filter(mort_full8_sexrace_state_nonopioid, sex == 1)%>%
           rename(asmr_NHWM_nonopioid_state = `1`,
                  asmr_NHBM_nonopioid_state = `2`) %>%
           ungroup() %>%
           select(-sex)

mort_full9_sexrace_state_nonopioid_F <- filter(mort_full8_sexrace_state_nonopioid, sex == 2)%>%
            rename(asmr_NHWF_nonopioid_state = `1`,
                   asmr_NHBF_nonopioid_state = `2`) %>%
            ungroup() %>%
            select(-sex)


mort_full10_sexrace_state_nonopioid <- left_join(mort_full9_sexrace_state_nonopioid_M, mort_full9_sexrace_state_nonopioid_F)


##########
#########
#########

fwrite(mort_full10_sexrace_state_drug, paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
fwrite(mort_full10_sexrace_state_opioid, paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
fwrite(mort_full10_sexrace_state_nonopioid, paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))



mort_full10_sexrace_state_drug
mort_full10_sexrace_state_opioid
mort_full10_sexrace_state_nonopioid

mort_full10_sexrace_state_comb <- mort_full10_sexrace_state_drug %>%
                                  left_join(mort_full10_sexrace_state_opioid) %>%
                                  left_join(mort_full10_sexrace_state_nonopioid)


