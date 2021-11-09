## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Mortality Rate Import Bypass
## File: 03_opioidsmanuf_mort_bypass.R
## Description: Imports data created from prg files 01-02f 


MORT_RATES_CLEAN <- "V:/seltzer/mortality/data/clean/mortality"



##Packages --------------------------------------------------------------------
library(foreign)
library(readstata13)
library(dplyr)
library(data.table)
library(ggplot2)
memory.limit(1000000)
options(scipen = 999)

#### CROSSWALKS ###############################################################
NAICS_cross <- read.csv("V:/seltzer/cbp/defs/NAICSsectors.csv")
NAICS_cross$NAICS2Digit <- as.character(NAICS_cross$NAICS2Digit)

##SIC - https://www.census.gov/eos/www/naics/concordances/concordances.html
SIC_cross <- data.frame(SIC2Digit = c("07", "10", "15", "20", "40", "50", "52", "60", "70")) %>%
  mutate(SIC2Digit = as.character(SIC2Digit),
         supersector = ifelse(as.numeric(SIC2Digit) < 40, "GoodsProducing", "ServiceProviding"))  

## CBSA crosswalk
MSA_CTY_XWALK <- as_tibble(read.csv("V:/seltzer/cbp/msa/xwalk/new_msa.txt"))

c_cz_cross <- read.csv("V:/obrien ssa/data/various/cty_cz_st_crosswalk.csv") %>%
  mutate(statecountyfips = ifelse((nchar(cty))==4, paste0("0", cty), cty))


fips <- fread("V:/noblesnchs/working/ns - recession/variousdata/fipscrosswalk.csv" , colClasses=list(character=1:3))
standardpop <- read.csv("V:/obrien ssa/data/various/standardpop2000.csv", stringsAsFactors = FALSE)


#### IMPORT ###############################################################

## County

  mort_full6_sex_county_drug <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-alldrug.csv"))
  mort_full6_sex_county_opioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-opioid.csv"))
  mort_full6_sex_county_nonopioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-nonopioid.csv"))	
  
  
  Mort_full6_sex_county_comb <- left_join(mort_full6_sex_county_drug, mort_full6_sex_county_opioid) %>%
                                left_join(mort_full6_sex_county_nonopioid) %>%
                                rename(county_fips = statecountyfips)

## Commuting Zone

  mort_full6_sex_cz_drug <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-alldrug.csv"))
  mort_full6_sex_cz_opioid <-  fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-opioid.csv"))
  mort_full6_sex_cz_nonopioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-nonopioid.csv"))	
  
  Mort_full6_sex_cz_comb <- left_join(mort_full6_sex_cz_drug, mort_full6_sex_cz_opioid) %>%
                            left_join(mort_full6_sex_cz_nonopioid) 

## CBSA

  mort_full6_sex_cbsa_drug <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-alldrug.csv"))
  mort_full6_sex_cbsa_opioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-opioid.csv"))
  mort_full6_sex_cbsa_nonopioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-nonopioid.csv"))	
  
  Mort_full6_sex_cbsa_comb <- left_join(mort_full6_sex_cbsa_drug, mort_full6_sex_cbsa_opioid) %>%
                              left_join(mort_full6_sex_cbsa_nonopioid) %>%
                              rename(msa = CBSA)

## State

  mort_full6_sex_state_drug <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
  mort_full6_sex_state_opioid <-  fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
  mort_full6_sex_state_nonopioid <- fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))
  
  Mort_full6_sex_state_comb <- left_join(mort_full6_sex_state_drug, mort_full6_sex_state_opioid) %>%
                               left_join(mort_full6_sex_state_nonopioid)


## State Sex Race and Sex Race Agecat
  
  mort_full10_sexrace_state_drug <-   fread(paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
  mort_full10_sexrace_state_opioid <- fread(paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
  mort_full10_sexrace_state_nonopioid <- fread(paste0(MORT_RATES_CLEAN, "/sexrace_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))
  

mort_full10_sexrace_state_comb <- mort_full10_sexrace_state_drug %>%
    left_join(mort_full10_sexrace_state_opioid) %>%
    left_join(mort_full10_sexrace_state_nonopioid)
  
  
mort_full10_sexraceage_state_drug <-   fread(paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
mort_full10_sexraceage_state_opioid <-   fread(paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
mort_full10_sexraceage_state_nonopioid <-   fread(paste0(MORT_RATES_CLEAN, "/sexraceage_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))
  


mort_full10_sexraceage_state_comb <- mort_full10_sexraceage_state_drug %>%
  left_join(mort_full10_sexraceage_state_opioid) %>%
  left_join(mort_full10_sexraceage_state_nonopioid)




## State Predicted Opioid Deaths

mort_full6_sex_state_opioid_pred <-  fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-opioid_predicted.csv"))

## County Predicted Opioid Deaths

mort_full6_sex_county_opioid_pred <-  fread(paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-opioid_predicted.csv"))
