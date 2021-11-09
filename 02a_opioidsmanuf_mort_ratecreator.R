## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Mortality Rate Creator
## File: 02a_opioidsmanuf_mort_ratecreator.R
## Description: Creates county, commuting zone, CBSA, and state mortality rates 
##  for opioids,non-opioids, and drug overdose deaths for women and men.


# mort_full3 <- fread( "V:/seltzer/mortality/data/full_mortality_data_1999_2017_mort_full3_-RESTRICTED_keeponwinstat.csv")


MORT_RATES_CLEAN <- "V:/seltzer/mortality/data/clean/mortality"


###############################################################################
## 1.0 COUNTY -----------------------------------------------------------------
###############################################################################

	mort_full4_sex_county_drug <- mort_full3 %>%
	  mutate(statecountyfips = as.numeric(statecountyfips)) %>%
	  group_by(statecountyfips, agecat, sex, year, ucod) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))

	mort_full4_sex_county_with_opioid <- mort_full3 %>%
	  mutate(statecountyfips = as.numeric(statecountyfips)) %>%
	  group_by(statecountyfips, agecat, sex, year, ucod, opioid) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))


	NCHS_sex_pop_county_drug <- NCHS_tot_pop_1 %>%
	  rename(year = YEAR) %>%
	  mutate(sex = ifelse(female==0, 1,
						  ifelse(female==1, 2, NA))) %>%
	  group_by(statecountyfips, year, sex, agecat) %>%
	  summarize(tot_pop = sum(pop, na.rm = TRUE)) %>%
	  left_join(standardpop, by = "agecat")

## 1.1 COUNTY all drug death --------------------------------------------------

	mort_full5_sex_county_drug <- mort_full4_sex_county_drug %>%
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
	  right_join(NCHS_sex_pop_county_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( statecountyfips, year, agecat, sex)

	mort_full6_sex_county_drug <- mort_full5_sex_county_drug %>%
	  group_by(statecountyfips, sex, year) %>%
	  summarize(deaths_sex_drug_cty = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_drug_cty/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_drug_cty = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 1.2 COUNTY opioid drug death -----------------------------------------------

	mort_full4_sex_county_opioid <- mort_full4_sex_county_with_opioid %>%
				filter(opioid == 1)

	mort_full5_sex_county_opioid <- mort_full4_sex_county_opioid %>%
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
	  right_join(NCHS_sex_pop_county_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( statecountyfips, year, agecat, sex)

	mort_full6_sex_county_opioid <- mort_full5_sex_county_opioid %>%
	  group_by(statecountyfips, sex, year) %>%
	  summarize(deaths_sex_opioid_cty = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_opioid_cty/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_opioid_cty = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 1.3 COUNTY non-opioid drug death -------------------------------------------

	mort_full4_sex_county_nonopioid <- mort_full4_sex_county_with_opioid %>%
	  filter(is.na(opioid)==TRUE)

	mort_full5_sex_county_nonopioid <- mort_full4_sex_county_nonopioid %>%
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
	  right_join(NCHS_sex_pop_county_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( statecountyfips, year, agecat, sex)

	mort_full6_sex_county_nonopioid <- mort_full5_sex_county_nonopioid %>%
	  group_by(statecountyfips, sex, year) %>%
	  summarize(deaths_sex_nonopioid_cty = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_nonopioid_cty/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_nonopioid_cty = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 1.4 COUNTY - Save and Export  ----------------------------------------------

	write.dta(mort_full6_sex_county_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-alldrug.dta"))
	write.dta(mort_full6_sex_county_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-opioid.dta"))
	write.dta(mort_full6_sex_county_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-nonopioid.dta"))
	
	fwrite(mort_full6_sex_county_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-alldrug.csv"))
	fwrite(mort_full6_sex_county_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-opioid.csv"))
	fwrite(mort_full6_sex_county_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-county-nonopioid.csv"))	
	
	
###############################################################################
## 2.0 COMMUTING ZONE ---------------------------------------------------------
###############################################################################

	mort_full4_sex_cz_drug <- mort_full3 %>%
	  group_by(cz, cz_name, agecat, sex, year, ucod) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))

	mort_full4_sex_cz_with_opioid <- mort_full3 %>%
	  group_by(cz, cz_name, agecat, sex, year, ucod, opioid) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))


	NCHS_sex_pop_cz_drug <- NCHS_tot_pop_1 %>%
	  left_join(mutate(c_cz_cross, statecountyfips = as.numeric(statecountyfips)),
				by = "statecountyfips") %>%
	  rename(year = YEAR) %>%
	  mutate(sex = ifelse(female==0, 1,
						  ifelse(female==1, 2, NA))) %>%
	  group_by(cz, cz_name, year, sex, agecat) %>%
	  summarize(tot_pop = sum(pop, na.rm = TRUE)) %>%
	  left_join(standardpop, by = "agecat")


## 2.1 COMMUTING ZONE all drug death ------------------------------------------

	mort_full5_sex_cz_drug <- mort_full4_sex_cz_drug %>%
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
	  right_join(NCHS_sex_pop_cz_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange(cz, cz_name, year, agecat, sex)

	mort_full6_sex_cz_drug <- mort_full5_sex_cz_drug %>%
	  group_by(cz, cz_name, sex, year) %>%
	  summarize(deaths_sex_drug_cz = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_drug_cz/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_drug_cz = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 2.2 COMMUTING ZONE opioid drug death ---------------------------------------

	mort_full4_sex_cz_opioid <- mort_full4_sex_cz_with_opioid %>%
	  filter(opioid == 1)


	mort_full5_sex_cz_opioid <- mort_full4_sex_cz_opioid %>%
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
	  right_join(NCHS_sex_pop_cz_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange(cz, cz_name, year, agecat, sex)

	mort_full6_sex_cz_opioid <- mort_full5_sex_cz_opioid %>%
	  group_by(cz, cz_name, sex, year) %>%
	  summarize(deaths_sex_opioid_cz = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_opioid_cz/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_opioid_cz = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)


## 2.3 COMMUTING ZONE non-opioid drug death -----------------------------------

	mort_full4_sex_cz_nonopioid <- mort_full4_sex_cz_with_opioid %>%
	  filter(is.na(opioid) == TRUE)


	mort_full5_sex_cz_nonopioid <- mort_full4_sex_cz_nonopioid %>%
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
	  right_join(NCHS_sex_pop_cz_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange(cz, cz_name, year, agecat, sex)

	mort_full6_sex_cz_nonopioid <- mort_full5_sex_cz_nonopioid %>%
	  group_by(cz, cz_name, sex, year) %>%
	  summarize(deaths_sex_nonopioid_cz = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_nonopioid_cz/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_nonopioid_cz = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)


## 2.4 CZ - Save and Export  -----------------------------------------------

	write.dta(mort_full6_sex_cz_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-alldrug.dta"))
	write.dta(mort_full6_sex_cz_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-opioid.dta"))
	write.dta(mort_full6_sex_cz_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-nonopioid.dta"))
	
	fwrite(mort_full6_sex_cz_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-alldrug.csv"))
	fwrite(mort_full6_sex_cz_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-opioid.csv"))
	fwrite(mort_full6_sex_cz_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cz-nonopioid.csv"))	
	
###############################################################################
## 3.0 CBSA -------------------------------------------------------------------
###############################################################################

	library(noncensus)
	data(counties)

	counties_2 <- counties %>%
				  mutate(statecountyfips = paste0(state_fips, county_fips),
						 CBSA = as.numeric(as.character(CBSA))) %>%
				  select(-county_name, -state, -state_fips, -county_fips, -population)

	mort_full3_cbsa <- left_join(mort_full3, counties_2)


	mort_full4_sex_cbsa_drug <- mort_full3_cbsa %>%
	  group_by(CBSA, agecat, sex, year, ucod) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))

	mort_full4_sex_cbsa_with_opioid <- mort_full3_cbsa %>%
	  group_by(CBSA, agecat, sex, year, ucod, opioid) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))


	NCHS_sex_pop_cbsa_drug <- NCHS_tot_pop_1 %>%
	  left_join(mutate(counties_2, statecountyfips = as.numeric(statecountyfips),
								   CBSA = as.numeric(as.character(CBSA))),
				by = "statecountyfips") %>%
	  rename(year = YEAR) %>%
	  mutate(sex = ifelse(female==0, 1,
						  ifelse(female==1, 2, NA))) %>%
	  group_by(CBSA, year, sex, agecat) %>%
	  summarize(tot_pop = sum(pop, na.rm = TRUE)) %>%
	  left_join(standardpop, by = "agecat")


## 3.1 CBSA all drug death ----------------------------------------------------

	mort_full5_sex_cbsa_drug <- mort_full4_sex_cbsa_drug %>%
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
	  right_join(NCHS_sex_pop_cbsa_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( CBSA, year, agecat, sex)

	mort_full6_sex_cbsa_drug <- mort_full5_sex_cbsa_drug %>%
	  group_by(CBSA, sex, year) %>%
	  summarize(deaths_sex_drug_cbsa = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_drug_cbsa/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_drug_cbsa = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 3.2 CBSA opioid drug death -------------------------------------------------

	mort_full4_sex_cbsa_opioid <- mort_full4_sex_cbsa_with_opioid %>%
	  filter(opioid == 1)

	mort_full5_sex_cbsa_opioid <- mort_full4_sex_cbsa_opioid %>%
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
	  right_join(NCHS_sex_pop_cbsa_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( CBSA, year, agecat, sex)

	mort_full6_sex_cbsa_opioid <- mort_full5_sex_cbsa_opioid %>%
	  group_by(CBSA, sex, year) %>%
	  summarize(deaths_sex_opioid_cbsa = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_opioid_cbsa/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_opioid_cbsa = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 3.3 CBSA non-opioid drug death ----------------------------------------------

	mort_full4_sex_cbsa_nonopioid <- mort_full4_sex_cbsa_with_opioid %>%
	  filter(is.na(opioid) == TRUE)

	mort_full5_sex_cbsa_nonopioid <- mort_full4_sex_cbsa_nonopioid %>%
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
	  right_join(NCHS_sex_pop_cbsa_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
			 age_weight = age_crude_sex*weight) %>%
	  arrange( CBSA, year, agecat, sex)

	mort_full6_sex_cbsa_nonopioid <- mort_full5_sex_cbsa_nonopioid %>%
	  group_by(CBSA, sex, year) %>%
	  summarize(deaths_sex_nonopioid_cbsa = sum(deaths, na.rm=TRUE),
				tot_pop_sex = sum(tot_pop, na.rm = TRUE),
				cr_sex = sum(deaths_sex_nonopioid_cbsa/tot_pop_sex, na.rm = TRUE)*100000,
				asmr_sex_nonopioid_cbsa = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)

## 3.4 CBSA - Save and Export  -----------------------------------------------

	write.dta(mort_full6_sex_cbsa_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-alldrug.dta"))
	write.dta(mort_full6_sex_cbsa_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-opioid.dta"))
	write.dta(mort_full6_sex_cbsa_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-nonopioid.dta"))
	
	fwrite(mort_full6_sex_cbsa_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-alldrug.csv"))
	fwrite(mort_full6_sex_cbsa_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-opioid.csv"))
	fwrite(mort_full6_sex_cbsa_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-cbsa-nonopioid.csv"))	
	
###############################################################################
## 4.0 STATE ------------------------------------------------------------------
###############################################################################
	

	mort_full4_sex_state_drug <- mort_full3 %>%
	  group_by(state_fips, agecat, sex, year, ucod) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))
	
	mort_full4_sex_state_with_opioid <- mort_full3 %>%
	  group_by(state_fips, agecat, sex, year, ucod, opioid) %>%
	  summarize(deaths = sum(death, na.rm = TRUE))
	
	
	NCHS_sex_pop_state_drug <- NCHS_tot_pop_1 %>%
	  rename(year = YEAR,
	         state_fips = ST_FIPS2) %>%
	  mutate(sex = ifelse(female==0, 1,
	                      ifelse(female==1, 2, NA))) %>%
	  group_by(state_fips, year, sex, agecat) %>%
	  summarize(tot_pop = sum(pop, na.rm = TRUE)) %>%
	  left_join(standardpop, by = "agecat")
	
	
	## 4.1 STATE all drug death ----------------------------------------------------
	
	mort_full5_sex_state_drug <- mort_full4_sex_state_drug %>%
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
	  right_join(NCHS_sex_pop_state_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
	         age_weight = age_crude_sex*weight) %>%
	  arrange( state_fips, year, agecat, sex)
	
	mort_full6_sex_state_drug <- mort_full5_sex_state_drug %>%
	  group_by(state_fips, sex, year) %>%
	  summarize(deaths_sex_drug_state = sum(deaths, na.rm=TRUE),
	            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
	            cr_sex = sum(deaths_sex_drug_state/tot_pop_sex, na.rm = TRUE)*100000,
	            asmr_sex_drug_state = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)
	
	## 4.2 STATE opioid drug death -------------------------------------------------
	
	mort_full4_sex_state_opioid <- mort_full4_sex_state_with_opioid %>%
	  filter(opioid == 1)
	
	mort_full5_sex_state_opioid <- mort_full4_sex_state_opioid %>%
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
	  right_join(NCHS_sex_pop_state_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
	         age_weight = age_crude_sex*weight) %>%
	  arrange( state_fips, year, agecat, sex)
	
	mort_full6_sex_state_opioid <- mort_full5_sex_state_opioid %>%
	  group_by(state_fips, sex, year) %>%
	  summarize(deaths_sex_opioid_state = sum(deaths, na.rm=TRUE),
	            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
	            cr_sex = sum(deaths_sex_opioid_state/tot_pop_sex, na.rm = TRUE)*100000,
	            asmr_sex_opioid_state = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)
	
	## 4.3 STATE non-opioid drug death ----------------------------------------------
	
	mort_full4_sex_state_nonopioid <- mort_full4_sex_state_with_opioid %>%
	  filter(is.na(opioid) == TRUE)
	
	mort_full5_sex_state_nonopioid <- mort_full4_sex_state_nonopioid %>%
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
	  right_join(NCHS_sex_pop_state_drug) %>%
	  mutate(age_crude_sex = (deaths/tot_pop)*100000,
	         age_weight = age_crude_sex*weight) %>%
	  arrange( state_fips, year, agecat, sex)
	
	mort_full6_sex_state_nonopioid <- mort_full5_sex_state_nonopioid %>%
	  group_by(state_fips, sex, year) %>%
	  summarize(deaths_sex_nonopioid_state = sum(deaths, na.rm=TRUE),
	            tot_pop_sex = sum(tot_pop, na.rm = TRUE),
	            cr_sex = sum(deaths_sex_nonopioid_state/tot_pop_sex, na.rm = TRUE)*100000,
	            asmr_sex_nonopioid_state = sum(age_weight, na.rm = TRUE)) %>%
	  filter(year > 1997) %>%
	  select(-cr_sex, -tot_pop_sex)
	
## 4.4 STATE - Save and Export  -----------------------------------------------
	
	write.dta(mort_full6_sex_state_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-alldrug.dta"))
	write.dta(mort_full6_sex_state_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-opioid.dta"))
	write.dta(mort_full6_sex_state_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.dta"))

	fwrite(mort_full6_sex_state_drug, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-alldrug.csv"))
	fwrite(mort_full6_sex_state_opioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-opioid.csv"))
	fwrite(mort_full6_sex_state_nonopioid, paste0(MORT_RATES_CLEAN, "/sex_drugrates-RESTRICTED_keeponwinstat-state-nonopioid.csv"))
	
