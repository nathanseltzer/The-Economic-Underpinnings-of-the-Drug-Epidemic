## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP County Data
## File: 04a_opioidsmanuf_cbp_countydata.R
## Description: Uses county-level CBP data to create:
##  (1) county measures
##  (2) CBSA measures (Version 2)
##  (3) CZ measures


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




###############################################################################
## IMPORT CBP DATA - 1998-2016
###############################################################################

setwd("V:/seltzer/cbp")

############# -- commented out because takes long time to run

## Read In CBP files and compile all into one dataframe
filenames_cbp_county_a <- list.files(path = "V:/seltzer/cbp", pattern = ".txt")
lst_cbp_county_a <- lapply(filenames_cbp_county_a, fread, colClasses=list(character=1:2),
                           select = c("fipstate", "fipscty", "naics", "est", "emp", "ap", "qp1"), data.table = FALSE)
lst_cbp_county_a[[1]]$year <- 2000
lst_cbp_county_a[[2]]$year <- 2001
lst_cbp_county_a[[3]]$year <- 2002
lst_cbp_county_a[[4]]$year <- 2003
lst_cbp_county_a[[5]]$year <- 2004
lst_cbp_county_a[[6]]$year <- 2005
lst_cbp_county_a[[7]]$year <- 2006
lst_cbp_county_a[[8]]$year <- 2007
lst_cbp_county_a[[9]]$year <- 2008
lst_cbp_county_a[[10]]$year <- 2009
lst_cbp_county_a[[11]]$year <- 2010
lst_cbp_county_a[[12]]$year <- 2011
lst_cbp_county_a[[13]]$year <- 2012
lst_cbp_county_a[[14]]$year <- 2013
lst_cbp_county_a[[15]]$year <- 2014
lst_cbp_county_a[[16]]$year <- 2015
lst_cbp_county_a[[17]]$year <- 2016
lst_cbp_county_a[[18]]$year <- 1998
lst_cbp_county_a[[19]]$year <- 1999


dt_cbp_county_a <- data.frame(rbindlist(lst_cbp_county_a))


## general pre-processing
dt_cbp_county_b <- dt_cbp_county_a %>% mutate(cty = as.numeric(paste0(fipstate, fipscty)),
                                              NAICS2Digit = substr(naics, 1, 2),
                                              fipstate = as.numeric(fipstate),
                                              fipscty = as.numeric(fipscty))

dt_cbp_county_c <- left_join(dt_cbp_county_b, NAICS_cross, by.x = "NAICS2Digit", by.y = "NAICS2Digit", all.x= TRUE) %>%
  rename(county_fips = cty)

dt_cbp_county_d <- dt_cbp_county_c




###############################################################################
## 1  COUNTY-level measures
###############################################################################

######## ----------------------------------------------------------------------
### by sector
# (a) business composition
dt_county_est_1_sec <- filter(dt_cbp_county_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, county_fips, sector) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_county_est_2_sec <- spread(dt_county_est_1_sec, sector, establishments) %>%
  rename_at(vars(-year,-county_fips), function(x) paste0(x, "_est"))

dt_county_est_2_sec$tot_est <- rowSums(dt_county_est_2_sec[,3:21], na.rm = TRUE)
dt_county_est_3_sec <- dt_county_est_2_sec %>%
  mutate_all(funs(est_pct = ./tot_est))



# (b) employment
dt_county_emp_1_sec <- filter(dt_cbp_county_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, county_fips, sector) %>%
  summarise(emp = sum(emp, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_county_emp_2_sec <- spread(dt_county_emp_1_sec, sector, emp) %>%
  rename_at(vars(-year,-county_fips), function(x) paste0(x, "_emp"))

dt_county_emp_2_sec$tot_emp <- rowSums(dt_county_emp_2_sec[,3:21], na.rm = TRUE)
dt_county_emp_3_sec <- dt_county_emp_2_sec %>%
  mutate_all(funs(emp_pct = ./tot_emp))


# (b) annual payroll
dt_county_ap_1_sec <- filter(dt_cbp_county_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, county_fips, sector) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_county_ap_2_sec <- spread(dt_county_ap_1_sec, sector, ap) %>%
  rename_at(vars(-year,-county_fips), function(x) paste0(x, "_ap"))

dt_county_ap_2_sec$tot_ap <- rowSums(dt_county_ap_2_sec[,3:21], na.rm = TRUE)
dt_county_ap_3_sec <- dt_county_ap_2_sec %>%
  mutate_all(funs(pct = ./tot_ap))


## Combine (a),(b), and (c)
dt_county_comb_sec_a <- left_join(dt_county_est_3_sec, dt_county_emp_3_sec, by = c("year", "county_fips"))
dt_county_comb_sec_b <- left_join(dt_county_comb_sec_a, dt_county_ap_3_sec, by = c("year", "county_fips"))



dt_county_comb_sec_c <- dt_county_comb_sec_b %>%
  select(year, county_fips, Manufacturing_est, Manufacturing_est_est_pct, Manufacturing_emp, Manufacturing_emp_emp_pct,
         Manufacturing_ap, Manufacturing_ap_pct)


dt_county_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_county_comb_sec_d <- dt_county_comb_sec_c %>%
  ungroup() %>%
  mutate(county_fips = as.numeric(county_fips)) %>%
  rename_at(vars(-year, -county_fips), function(x) paste0(x, "_cty")) %>%
  arrange(year, county_fips)

# 
# combtotal_county <- dt_county_comb_sec_e %>%
#                     rename(Manufacturing_est_cty = Manufacturing_est,
#                            Manufacturing_est_est_pct_cty = Manufacturing_est_est_pct,
#                            Manufacturing_emp_cty = Manufacturing_emp,
#                            Manufacturing_emp_emp_pct_cty = Manufacturing_emp_emp_pct,
#                            Manufacturing_ap_cty = Manufacturing_ap,
#                            Manufacturing_ap_pct_cty = Manufacturing_ap_pct,
#                            statecountyfips = county_fips)


# write.dta(combtotal_county, "combtotal_test_county.dta")
# combtotal_county <-  read.dta("combtotal_test_county.dta")


###############################################################################
## 2 MSA-level Measures
###############################################################################

dt_cbp_ctymsa_d <- left_join(dt_cbp_county_c, MSA_CTY_XWALK) 


######## ----------------------------------------------------------------------
### by sector
# (a) business composition
dt_ctymsa_est_1_sec <- filter(dt_cbp_ctymsa_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_ctymsa_est_2_sec <- spread(dt_ctymsa_est_1_sec, sector, establishments) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_est"))

dt_ctymsa_est_2_sec$tot_est <- rowSums(dt_ctymsa_est_2_sec[,3:21], na.rm = TRUE)
dt_ctymsa_est_3_sec <- dt_ctymsa_est_2_sec %>%
  mutate_all(funs(est_pct = ./tot_est))



# (b) employment
dt_ctymsa_emp_1_sec <- filter(dt_cbp_ctymsa_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(emp = sum(emp, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_ctymsa_emp_2_sec <- spread(dt_ctymsa_emp_1_sec, sector, emp) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_emp"))

dt_ctymsa_emp_2_sec$tot_emp <- rowSums(dt_ctymsa_emp_2_sec[,3:21], na.rm = TRUE)
dt_ctymsa_emp_3_sec <- dt_ctymsa_emp_2_sec %>%
  mutate_all(funs(emp_pct = ./tot_emp))


# (b) annual payroll
dt_ctymsa_ap_1_sec <- filter(dt_cbp_ctymsa_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_ctymsa_ap_2_sec <- spread(dt_ctymsa_ap_1_sec, sector, ap) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_ap"))

dt_ctymsa_ap_2_sec$tot_ap <- rowSums(dt_ctymsa_ap_2_sec[,3:21], na.rm = TRUE)
dt_ctymsa_ap_3_sec <- dt_ctymsa_ap_2_sec %>%
  mutate_all(funs(pct = ./tot_ap))


## Combine (a),(b), and (c)
dt_ctymsa_comb_sec_a <- left_join(dt_ctymsa_est_3_sec, dt_ctymsa_emp_3_sec, by = c("year", "msa"))
dt_ctymsa_comb_sec_b <- left_join(dt_ctymsa_comb_sec_a, dt_ctymsa_ap_3_sec, by = c("year", "msa"))



dt_ctymsa_comb_sec_c <- dt_ctymsa_comb_sec_b %>%
  select(year, msa, Manufacturing_est, Manufacturing_est_est_pct, Manufacturing_emp, Manufacturing_emp_emp_pct,
         Manufacturing_ap, Manufacturing_ap_pct)


dt_ctymsa_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_ctymsa_comb_sec_d <- dt_ctymsa_comb_sec_c %>%
  ungroup() %>%
  mutate(msa = as.numeric(msa)) %>%
  rename_at(vars(-year, -msa), function(x) paste0(x, "_ctymsa")) %>%
  arrange(year, msa)

# combtotal_v2 <- left_join(mutate(dt_ctymsa_comb_sec_e, CBSA = as.numeric(msa)), mort_full6_sex_cbsa_drug  )
# write.dta(combtotal_v2, "combtotal_test_v2.dta")



###############################################################################
## 3 CZ-level Measures
###############################################################################

dt_cbp_cz_d <- left_join(dt_cbp_county_c, rename(c_cz_cross, county_fips = cty)) 


######## ----------------------------------------------------------------------
### by sector
# (a) business composition
dt_cz_est_1_sec <- filter(dt_cbp_cz_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, cz, sector) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cz_est_2_sec <- spread(dt_cz_est_1_sec, sector, establishments) %>%
  rename_at(vars(-year,-cz), function(x) paste0(x, "_est"))

dt_cz_est_2_sec$tot_est <- rowSums(dt_cz_est_2_sec[,3:21], na.rm = TRUE)
dt_cz_est_3_sec <- dt_cz_est_2_sec %>%
  mutate_all(funs(est_pct = ./tot_est))



# (b) employment
dt_cz_emp_1_sec <- filter(dt_cbp_cz_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, cz, sector) %>%
  summarise(emp = sum(emp, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cz_emp_2_sec <- spread(dt_cz_emp_1_sec, sector, emp) %>%
  rename_at(vars(-year,-cz), function(x) paste0(x, "_emp"))

dt_cz_emp_2_sec$tot_emp <- rowSums(dt_cz_emp_2_sec[,3:21], na.rm = TRUE)
dt_cz_emp_3_sec <- dt_cz_emp_2_sec %>%
  mutate_all(funs(emp_pct = ./tot_emp))


# (b) annual payroll
dt_cz_ap_1_sec <- filter(dt_cbp_cz_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, cz, sector) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cz_ap_2_sec <- spread(dt_cz_ap_1_sec, sector, ap) %>%
  rename_at(vars(-year,-cz), function(x) paste0(x, "_ap"))

dt_cz_ap_2_sec$tot_ap <- rowSums(dt_cz_ap_2_sec[,3:21], na.rm = TRUE)
dt_cz_ap_3_sec <- dt_cz_ap_2_sec %>%
  mutate_all(funs(pct = ./tot_ap))


## Combine (a),(b), and (c)
dt_cz_comb_sec_a <- left_join(dt_cz_est_3_sec, dt_cz_emp_3_sec, by = c("year", "cz"))
dt_cz_comb_sec_b <- left_join(dt_cz_comb_sec_a, dt_cz_ap_3_sec, by = c("year", "cz"))



dt_cz_comb_sec_c <- dt_cz_comb_sec_b %>%
  select(year, cz, Manufacturing_est, Manufacturing_est_est_pct, Manufacturing_emp, Manufacturing_emp_emp_pct,
         Manufacturing_ap, Manufacturing_ap_pct)


dt_cz_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_cz_comb_sec_d <- dt_cz_comb_sec_c %>%
  ungroup() %>%
  mutate(cz = as.numeric(cz)) %>%
  rename_at(vars(-year, -cz), function(x) paste0(x, "_cz")) %>%
  arrange(year, cz)

# combtotal_v2 <- left_join(mutate(dt_cz_comb_sec_e, CBSA = as.numeric(cz)), mort_full6_sex_cbsa_drug  )
# write.dta(combtotal_v2, "combtotal_test_v2.dta")




###############################################################################
## 4 SAVE and EXPORT
###############################################################################

CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"

setwd(CBP_CLEAN)


fwrite(dt_county_comb_sec_d, paste0(CBP_CLEAN, "/CBP_countydata_manuf_county_CLEAN.csv"))
fwrite(dt_ctymsa_comb_sec_d, paste0(CBP_CLEAN, "/CBP_countydata_manuf_msa_CLEAN.csv"))
fwrite(dt_cz_comb_sec_d,     paste0(CBP_CLEAN, "/CBP_countydata_manuf_cz_CLEAN.csv"))



