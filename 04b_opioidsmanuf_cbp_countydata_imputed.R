## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP County Data (IMPUTED)
## File: 04b_opioidsmanuf_cbp_countydata_imputed.R
## Description: Uses IMPUTED county-level CBP data to create:
##  (1) IMPUTED county measures
##  (2) IMPUTED CBSA measures (Version 2)
##  (3) IMPUTED CZ measures
## Based on data from: 
##  Fabian Eckert, Teresa C. Fort, Peter K. Schott, and Natalie J. Yang. 
##   "Imputing Missing Values in the US Census Bureau's County Business Patterns." 
##   NBER Working Paper #26632, 2020

library(tidyverse)


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

setwd("V:/seltzer/cbp/imputed")

############# -- commented out because takes long time to run

## Read In CBP files and compile all into one dataframe
filenames_cbp_county_a <- list.files(path = "V:/seltzer/cbp/imputed", pattern = ".csv")
lst_cbp_county_a <- lapply(filenames_cbp_county_a, fread, colClasses=list(character=1:2),
                           select = c("fipstate", "fipscty", "naics", "emp"), data.table = FALSE)
# lst_cbp_county_a[[1]]$year <- 1998
# lst_cbp_county_a[[2]]$year <- 1999
# lst_cbp_county_a[[3]]$year <- 2000
# lst_cbp_county_a[[4]]$year <- 2001
# lst_cbp_county_a[[5]]$year <- 2002
# lst_cbp_county_a[[6]]$year <- 2003
# lst_cbp_county_a[[7]]$year <- 2004
# lst_cbp_county_a[[8]]$year <- 2005
# lst_cbp_county_a[[9]]$year <- 2006
# lst_cbp_county_a[[10]]$year <- 2007
# lst_cbp_county_a[[11]]$year <- 2008
# lst_cbp_county_a[[12]]$year <- 2009
# lst_cbp_county_a[[13]]$year <- 2010
# lst_cbp_county_a[[14]]$year <- 2011
# lst_cbp_county_a[[15]]$year <- 2012
# lst_cbp_county_a[[16]]$year <- 2013
# lst_cbp_county_a[[17]]$year <- 2014
# lst_cbp_county_a[[18]]$year <- 2015
# lst_cbp_county_a[[19]]$year <- 2016

lst_cbp_county_a[[1]]$year  <- 1980
lst_cbp_county_a[[2]]$year  <- 1981
lst_cbp_county_a[[3]]$year  <- 1982
lst_cbp_county_a[[4]]$year  <- 1983
lst_cbp_county_a[[5]]$year  <- 1984
lst_cbp_county_a[[6]]$year  <- 1985
lst_cbp_county_a[[7]]$year  <- 1986
lst_cbp_county_a[[8]]$year  <- 1987
lst_cbp_county_a[[9]]$year  <- 1988
lst_cbp_county_a[[10]]$year <- 1989
lst_cbp_county_a[[11]]$year <- 1990
lst_cbp_county_a[[12]]$year <- 1991
lst_cbp_county_a[[13]]$year <- 1992
lst_cbp_county_a[[14]]$year <- 1993
lst_cbp_county_a[[15]]$year <- 1994
lst_cbp_county_a[[16]]$year <- 1995
lst_cbp_county_a[[17]]$year <- 1996
lst_cbp_county_a[[18]]$year <- 1997
lst_cbp_county_a[[19]]$year <- 1998
lst_cbp_county_a[[20]]$year <- 1999
lst_cbp_county_a[[21]]$year <- 2000
lst_cbp_county_a[[22]]$year <- 2001
lst_cbp_county_a[[23]]$year <- 2002
lst_cbp_county_a[[24]]$year <- 2003
lst_cbp_county_a[[25]]$year <- 2004
lst_cbp_county_a[[26]]$year <- 2005
lst_cbp_county_a[[27]]$year <- 2006
lst_cbp_county_a[[28]]$year <- 2007
lst_cbp_county_a[[29]]$year <- 2008
lst_cbp_county_a[[30]]$year <- 2009
lst_cbp_county_a[[31]]$year <- 2010
lst_cbp_county_a[[32]]$year <- 2011
lst_cbp_county_a[[33]]$year <- 2012
lst_cbp_county_a[[34]]$year <- 2013
lst_cbp_county_a[[35]]$year <- 2014
lst_cbp_county_a[[36]]$year <- 2015
lst_cbp_county_a[[37]]$year <- 2016


dt_cbp_county_a <- data.frame(rbindlist(lst_cbp_county_a, fill = TRUE))

dt_cbp_county_a <- filter(dt_cbp_county_a, year > 1997)


## general pre-processing

dt_cbp_county_a$fipstate <- ifelse(nchar(as.character(dt_cbp_county_a$fipstate)) == 1, 
                                   paste0("0", as.character(dt_cbp_county_a$fipstate)),
                                   as.character(dt_cbp_county_a$fipstate))
dt_cbp_county_a$fipscty <- ifelse(nchar(as.character(dt_cbp_county_a$fipscty)) == 2, 
                                   paste0("0", as.character(dt_cbp_county_a$fipscty)),
                                   ifelse(nchar(as.character(dt_cbp_county_a$fipscty)) == 1, 
                                          paste0("00", as.character(dt_cbp_county_a$fipscty)),   
                                          as.character(dt_cbp_county_a$fipscty)))



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



## Combine (a),(b), and (c)
dt_county_comb_sec_b <- dt_county_emp_3_sec


dt_county_comb_sec_c <- dt_county_comb_sec_b %>%
  select(year, county_fips, Manufacturing_emp, Manufacturing_emp_emp_pct)


dt_county_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_county_comb_sec_d <- dt_county_comb_sec_c %>%
  ungroup() %>%
  mutate(county_fips = as.numeric(county_fips)) %>%
  rename_at(vars(-year, -county_fips), function(x) paste0(x, "_cty_imp")) %>%
  arrange(year, county_fips)


###############################################################################
## 2 MSA-level Measures
###############################################################################

dt_cbp_ctymsa_d <- left_join(dt_cbp_county_c, MSA_CTY_XWALK) 


######## ----------------------------------------------------------------------
### by sector

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


dt_ctymsa_comb_sec_b <- dt_ctymsa_emp_3_sec



dt_ctymsa_comb_sec_c <- dt_ctymsa_comb_sec_b %>%
  select(year, msa, Manufacturing_emp, Manufacturing_emp_emp_pct)


dt_ctymsa_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_ctymsa_comb_sec_d <- dt_ctymsa_comb_sec_c %>%
  ungroup() %>%
  mutate(msa = as.numeric(msa)) %>%
  rename_at(vars(-year, -msa), function(x) paste0(x, "_ctymsa_imp")) %>%
  arrange(year, msa)


###############################################################################
## 3 CZ-level Measures
###############################################################################

dt_cbp_cz_d <- left_join(dt_cbp_county_c, rename(c_cz_cross, county_fips = cty)) 


######## ----------------------------------------------------------------------
### by sector
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


## Combine (a),(b), and (c)
dt_cz_comb_sec_b <- dt_cz_emp_3_sec



dt_cz_comb_sec_c <- dt_cz_comb_sec_b %>%
  select(year, cz,  Manufacturing_emp, Manufacturing_emp_emp_pct)


dt_cz_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_cz_comb_sec_d <- dt_cz_comb_sec_c %>%
  ungroup() %>%
  mutate(cz = as.numeric(cz)) %>%
  rename_at(vars(-year, -cz), function(x) paste0(x, "_cz_imp")) %>%
  arrange(year, cz)


###############################################################################
## 4 SAVE and EXPORT
###############################################################################

CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"

setwd(CBP_CLEAN)


fwrite(dt_county_comb_sec_d, paste0(CBP_CLEAN, "/CBP_countydata_manuf_county_imputed_CLEAN.csv"))
fwrite(dt_ctymsa_comb_sec_d, paste0(CBP_CLEAN, "/CBP_countydata_manuf_msa_imputed_CLEAN.csv"))
fwrite(dt_cz_comb_sec_d,     paste0(CBP_CLEAN, "/CBP_countydata_manuf_cz_imputed_CLEAN.csv"))



