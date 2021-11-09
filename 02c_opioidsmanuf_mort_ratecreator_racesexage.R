## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Mortality Rate Creator - RACE and SEX and AGE 
## File: 02c_opioidsmanuf_mort_ratecreator_racesexage.R
## Description: Creates county, commuting zone, CBSA, and state mortality rates
##  for opioids, non-opioids, and drug overdose deaths for race, sex, and age subgroups

###############################################################################
## 4.0 STATE SEX RACE AGECAT --------------------------------------------------
###############################################################################
NCHS_tot_pop_1 <- fread("V:/obrien ssa/data/clean/NCHS_tot_pop_1.csv")

# mort_full3 <- fread( "V:/seltzer/mortality/data/full_mortality_data_1999_2017_mort_full3_-RESTRICTED_keeponwinstat.csv")


mort_full5_sexraceage_state_drug <- mort_full4_sexrace_state_drug %>%
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
  group_by(state_fips, sex, race, agecat, year) %>%
  summarize(deaths = sum(deaths, na.rm = TRUE)) %>%
  right_join(NCHS_sexrace_pop_state_drug)  %>%
  mutate(cr = (deaths/tot_pop)*100000) %>%
  filter(year > 1997) %>%
  filter(agecat == "25-34" |
         agecat == "35-44" |
         agecat == "45-54" |
         agecat == "55-64" )


mort_full7_sexraceage_state_drug <- mort_full5_sexraceage_state_drug %>%
    select(-deaths, -tot_pop, -number, -weight)

mort_full8_sexraceage_state_drug <- mort_full7_sexraceage_state_drug %>%
  spread(agecat, cr)

mort_full9_sexraceage_state_drug_WM <- filter(mort_full8_sexraceage_state_drug, sex == 1, race == 1)%>%
  rename(cr_NHWM_2534_drug_state = `25-34`,
         cr_NHWM_3544_drug_state = `35-44`,
         cr_NHWM_4554_drug_state = `45-54`,
         cr_NHWM_5564_drug_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_drug_WF <- filter(mort_full8_sexraceage_state_drug, sex == 2, race == 1)%>%
    rename(cr_NHWF_2534_drug_state = `25-34`,
           cr_NHWF_3544_drug_state = `35-44`,
           cr_NHWF_4554_drug_state = `45-54`,
           cr_NHWF_5564_drug_state = `55-64`) %>%
  ungroup() %>%
    select(-sex, -race)

  mort_full9_sexraceage_state_drug_BM <- filter(mort_full8_sexraceage_state_drug, sex == 1, race == 2)%>%
    rename(cr_NHBM_2534_drug_state = `25-34`,
           cr_NHBM_3544_drug_state = `35-44`,
           cr_NHBM_4554_drug_state = `45-54`,
           cr_NHBM_5564_drug_state = `55-64`) %>%
  ungroup() %>%
    select(-sex, -race)
  
  mort_full9_sexraceage_state_drug_BF <- filter(mort_full8_sexraceage_state_drug, sex == 2, race == 2)%>%
    rename(cr_NHBF_2534_drug_state = `25-34`,
           cr_NHBF_3544_drug_state = `35-44`,
           cr_NHBF_4554_drug_state = `45-54`,
           cr_NHBF_5564_drug_state = `55-64`) %>%
  ungroup() %>%
    select(-sex, -race)
  
  
mort_full10_sexraceage_state_drug_cr <- left_join(mort_full9_sexraceage_state_drug_WM, mort_full9_sexraceage_state_drug_WF) %>%
        left_join(mort_full9_sexraceage_state_drug_BM) %>%
        left_join(mort_full9_sexraceage_state_drug_BF)

## DEATHS
    
    mort_full7_sexraceage_state_drug_deaths <- mort_full5_sexraceage_state_drug %>%
      select(-cr, -tot_pop, -number, -weight)
    
    mort_full8_sexraceage_state_drug_deaths <- mort_full7_sexraceage_state_drug_deaths %>%
      spread(agecat, deaths)
    
    mort_full9_sexraceage_state_drug_WM_deaths <- filter(mort_full8_sexraceage_state_drug_deaths, sex == 1, race == 1)%>%
      rename(d_NHWM_2534_drug_state = `25-34`,
             d_NHWM_3544_drug_state = `35-44`,
             d_NHWM_4554_drug_state = `45-54`,
             d_NHWM_5564_drug_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_drug_WF_deaths <- filter(mort_full8_sexraceage_state_drug_deaths, sex == 2, race == 1)%>%
      rename(d_NHWF_2534_drug_state = `25-34`,
             d_NHWF_3544_drug_state = `35-44`,
             d_NHWF_4554_drug_state = `45-54`,
             d_NHWF_5564_drug_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_drug_BM_deaths <- filter(mort_full8_sexraceage_state_drug_deaths, sex == 1, race == 2)%>%
      rename(d_NHBM_2534_drug_state = `25-34`,
             d_NHBM_3544_drug_state = `35-44`,
             d_NHBM_4554_drug_state = `45-54`,
             d_NHBM_5564_drug_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_drug_BF_deaths <- filter(mort_full8_sexraceage_state_drug_deaths, sex == 2, race == 2)%>%
      rename(d_NHBF_2534_drug_state = `25-34`,
             d_NHBF_3544_drug_state = `35-44`,
             d_NHBF_4554_drug_state = `45-54`,
             d_NHBF_5564_drug_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    
    mort_full10_sexraceage_state_drug_deaths <- left_join(mort_full9_sexraceage_state_drug_WM_deaths, mort_full9_sexraceage_state_drug_WF_deaths) %>%
      left_join(mort_full9_sexraceage_state_drug_BM_deaths) %>%
      left_join(mort_full9_sexraceage_state_drug_BF_deaths)

    
mort_full10_sexraceage_state_drug <- left_join(mort_full10_sexraceage_state_drug_cr, mort_full10_sexraceage_state_drug_deaths)    
    

## 4.2 STATE opioid drug death -------------------------------------------------

mort_full4_sexrace_state_opioid <- mort_full4_sexrace_state_with_opioid %>%
  filter(opioid == 1)


mort_full5_sexraceage_state_opioid <- mort_full4_sexrace_state_opioid %>%
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
  group_by(state_fips, sex, race, agecat, year) %>%
  summarize(deaths = sum(deaths, na.rm = TRUE)) %>%
  right_join(NCHS_sexrace_pop_state_drug)  %>%
  mutate(cr = (deaths/tot_pop)*100000) %>%
  filter(year > 1997) %>%
  filter(agecat == "25-34" |
           agecat == "35-44" |
           agecat == "45-54" |
           agecat == "55-64" )


mort_full7_sexraceage_state_opioid <- mort_full5_sexraceage_state_opioid %>%
  select(-deaths, -tot_pop, -number, -weight)

mort_full8_sexraceage_state_opioid <- mort_full7_sexraceage_state_opioid %>%
  spread(agecat, cr)

mort_full9_sexraceage_state_opioid_WM <- filter(mort_full8_sexraceage_state_opioid, sex == 1, race == 1)%>%
  rename(cr_NHWM_2534_opioid_state = `25-34`,
         cr_NHWM_3544_opioid_state = `35-44`,
         cr_NHWM_4554_opioid_state = `45-54`,
         cr_NHWM_5564_opioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_opioid_WF <- filter(mort_full8_sexraceage_state_opioid, sex == 2, race == 1)%>%
  rename(cr_NHWF_2534_opioid_state = `25-34`,
         cr_NHWF_3544_opioid_state = `35-44`,
         cr_NHWF_4554_opioid_state = `45-54`,
         cr_NHWF_5564_opioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_opioid_BM <- filter(mort_full8_sexraceage_state_opioid, sex == 1, race == 2)%>%
  rename(cr_NHBM_2534_opioid_state = `25-34`,
         cr_NHBM_3544_opioid_state = `35-44`,
         cr_NHBM_4554_opioid_state = `45-54`,
         cr_NHBM_5564_opioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_opioid_BF <- filter(mort_full8_sexraceage_state_opioid, sex == 2, race == 2)%>%
  rename(cr_NHBF_2534_opioid_state = `25-34`,
         cr_NHBF_3544_opioid_state = `35-44`,
         cr_NHBF_4554_opioid_state = `45-54`,
         cr_NHBF_5564_opioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)


mort_full10_sexraceage_state_opioid_cr <- left_join(mort_full9_sexraceage_state_opioid_WM, mort_full9_sexraceage_state_opioid_WF) %>%
  left_join(mort_full9_sexraceage_state_opioid_BM) %>%
  left_join(mort_full9_sexraceage_state_opioid_BF)

## DEATHS

    mort_full7_sexraceage_state_opioid_deaths <- mort_full5_sexraceage_state_opioid %>%
      select(-cr, -tot_pop, -number, -weight)
    
    mort_full8_sexraceage_state_opioid_deaths <- mort_full7_sexraceage_state_opioid_deaths %>%
      spread(agecat, deaths)
    
    mort_full9_sexraceage_state_opioid_WM_deaths <- filter(mort_full8_sexraceage_state_opioid_deaths, sex == 1, race == 1)%>%
      rename(d_NHWM_2534_opioid_state = `25-34`,
             d_NHWM_3544_opioid_state = `35-44`,
             d_NHWM_4554_opioid_state = `45-54`,
             d_NHWM_5564_opioid_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_opioid_WF_deaths <- filter(mort_full8_sexraceage_state_opioid_deaths, sex == 2, race == 1)%>%
      rename(d_NHWF_2534_opioid_state = `25-34`,
             d_NHWF_3544_opioid_state = `35-44`,
             d_NHWF_4554_opioid_state = `45-54`,
             d_NHWF_5564_opioid_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_opioid_BM_deaths <- filter(mort_full8_sexraceage_state_opioid_deaths, sex == 1, race == 2)%>%
      rename(d_NHBM_2534_opioid_state = `25-34`,
             d_NHBM_3544_opioid_state = `35-44`,
             d_NHBM_4554_opioid_state = `45-54`,
             d_NHBM_5564_opioid_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    mort_full9_sexraceage_state_opioid_BF_deaths <- filter(mort_full8_sexraceage_state_opioid_deaths, sex == 2, race == 2)%>%
      rename(d_NHBF_2534_opioid_state = `25-34`,
             d_NHBF_3544_opioid_state = `35-44`,
             d_NHBF_4554_opioid_state = `45-54`,
             d_NHBF_5564_opioid_state = `55-64`) %>%
      ungroup() %>%
      select(-sex, -race)
    
    
    mort_full10_sexraceage_state_opioid_deaths <- left_join(mort_full9_sexraceage_state_opioid_WM_deaths, mort_full9_sexraceage_state_opioid_WF_deaths) %>%
      left_join(mort_full9_sexraceage_state_opioid_BM_deaths) %>%
      left_join(mort_full9_sexraceage_state_opioid_BF_deaths)


mort_full10_sexraceage_state_opioid <- left_join(mort_full10_sexraceage_state_opioid_cr, mort_full10_sexraceage_state_opioid_deaths)    




## 4.3 STATE non-opioid drug death ----------------------------------------------

mort_full4_sexrace_state_nonopioid <- mort_full4_sexrace_state_with_opioid %>%
  filter(is.na(opioid) == TRUE)

mort_full5_sexraceage_state_nonopioid <- mort_full4_sexrace_state_nonopioid %>%
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
  group_by(state_fips, sex, race, agecat, year) %>%
  summarize(deaths = sum(deaths, na.rm = TRUE)) %>%
  right_join(NCHS_sexrace_pop_state_drug)  %>%
  mutate(cr = (deaths/tot_pop)*100000) %>%
  filter(year > 1997) %>%
  filter(agecat == "25-34" |
           agecat == "35-44" |
           agecat == "45-54" |
           agecat == "55-64" )


mort_full7_sexraceage_state_nonopioid <- mort_full5_sexraceage_state_nonopioid %>%
  select(-deaths, -tot_pop, -number, -weight)

mort_full8_sexraceage_state_nonopioid <- mort_full7_sexraceage_state_nonopioid %>%
  spread(agecat, cr)

mort_full9_sexraceage_state_nonopioid_WM <- filter(mort_full8_sexraceage_state_nonopioid, sex == 1, race == 1)%>%
  rename(cr_NHWM_2534_nonopioid_state = `25-34`,
         cr_NHWM_3544_nonopioid_state = `35-44`,
         cr_NHWM_4554_nonopioid_state = `45-54`,
         cr_NHWM_5564_nonopioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_nonopioid_WF <- filter(mort_full8_sexraceage_state_nonopioid, sex == 2, race == 1)%>%
  rename(cr_NHWF_2534_nonopioid_state = `25-34`,
         cr_NHWF_3544_nonopioid_state = `35-44`,
         cr_NHWF_4554_nonopioid_state = `45-54`,
         cr_NHWF_5564_nonopioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_nonopioid_BM <- filter(mort_full8_sexraceage_state_nonopioid, sex == 1, race == 2)%>%
  rename(cr_NHBM_2534_nonopioid_state = `25-34`,
         cr_NHBM_3544_nonopioid_state = `35-44`,
         cr_NHBM_4554_nonopioid_state = `45-54`,
         cr_NHBM_5564_nonopioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)

mort_full9_sexraceage_state_nonopioid_BF <- filter(mort_full8_sexraceage_state_nonopioid, sex == 2, race == 2)%>%
  rename(cr_NHBF_2534_nonopioid_state = `25-34`,
         cr_NHBF_3544_nonopioid_state = `35-44`,
         cr_NHBF_4554_nonopioid_state = `45-54`,
         cr_NHBF_5564_nonopioid_state = `55-64`) %>%
  ungroup() %>%
  select(-sex, -race)


mort_full10_sexraceage_state_nonopioid <- left_join(mort_full9_sexraceage_state_nonopioid_WM, mort_full9_sexraceage_state_nonopioid_WF) %>%
  left_join(mort_full9_sexraceage_state_nonopioid_BM) %>%
  left_join(mort_full9_sexraceage_state_nonopioid_BF)


##########
########
#########

fwrite(mort_full10_sexraceage_state_drug, paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
fwrite(mort_full10_sexraceage_state_opioid, paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
fwrite(mort_full10_sexraceage_state_nonopioid, paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))



mort_full10_sexraceage_state_drug
mort_full10_sexraceage_state_opioid
mort_full10_sexraceage_state_nonopioid


mort_full10_sexraceage_state_comb <- mort_full10_sexraceage_state_drug %>%
                                      left_join(mort_full10_sexraceage_state_opioid) %>%
                                      left_join(mort_full10_sexraceage_state_nonopioid)
