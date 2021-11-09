## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP MSA Data
## File: 05_opioidsmanuf_cbp_msadata.R
## Description: Uses MSA-level CBP data to create:
##  (1) msa measures

library(tidyverse)

path_msa <- "V:/seltzer/cbp/msa"


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
# 2 IMPORT CBP DATA - 1998-2016
###############################################################################

##Import all years, but 1998-2002 use a different classification scheme

setwd(path_msa)

## Read In CBP files and compile all into one dataframe
filenames_cbp_a <- list.files(path = "V:/seltzer/cbp/msa", pattern = ".txt")
lst_cbp_a <- lapply(filenames_cbp_a, fread, colClasses=list(character=1:2), data.table = FALSE)
lst_cbp_a[[1]]$year <- 2000
lst_cbp_a[[2]]$year <- 2001
lst_cbp_a[[3]]$year <- 2002
lst_cbp_a[[4]]$year <- 2003
lst_cbp_a[[5]]$year <- 2004
lst_cbp_a[[6]]$year <- 2005
lst_cbp_a[[7]]$year <- 2006
lst_cbp_a[[8]]$year <- 2007
lst_cbp_a[[9]]$year <- 2008
lst_cbp_a[[10]]$year <- 2009
lst_cbp_a[[11]]$year <- 2010
lst_cbp_a[[12]]$year <- 2011
lst_cbp_a[[13]]$year <- 2012
lst_cbp_a[[14]]$year <- 2013
lst_cbp_a[[15]]$year <- 2014
lst_cbp_a[[16]]$year <- 2015
lst_cbp_a[[17]]$year <- 2016
lst_cbp_a[[18]]$year <- 2017
lst_cbp_a[[19]]$year <- 1998
lst_cbp_a[[20]]$year <- 1999


dt_cbp_a <- data.frame(rbindlist(lst_cbp_a, fill = TRUE))

dt_cbp_b <- dt_cbp_a %>%
  select(year, msa, naics, emp, qp1, ap, est)


## general pre-processing
dt_cbp_c <- dt_cbp_b %>% 
  mutate(NAICS2Digit = substr(naics, 1, 2),
         msa = as.numeric(msa))

dt_cbp_d <- left_join(dt_cbp_c, NAICS_cross, by.x = "NAICS2Digit", by.y = "NAICS2Digit", all.x= TRUE)  




##### -------------------------------------------------------------------------
# d # Wrangling CBP DATA - MSA
##### -------------------------------------------------------------------------      

######## ----------------------------------------------------------------------
### by sector
# (a) business composition
dt_cbp_msa_est_1_sec <- filter(dt_cbp_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_msa_est_2_sec <- spread(dt_cbp_msa_est_1_sec, sector, establishments) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_est"))

dt_cbp_msa_est_2_sec$tot_est <- rowSums(dt_cbp_msa_est_2_sec[,3:21], na.rm = TRUE)
dt_cbp_msa_est_3_sec <- dt_cbp_msa_est_2_sec %>%
  mutate_all(funs(est_pct = ./tot_est))



# (b) employment
dt_cbp_msa_emp_1_sec <- filter(dt_cbp_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(emp = sum(emp, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_msa_emp_2_sec <- spread(dt_cbp_msa_emp_1_sec, sector, emp) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_emp"))

dt_cbp_msa_emp_2_sec$tot_emp <- rowSums(dt_cbp_msa_emp_2_sec[,3:21], na.rm = TRUE)
dt_cbp_msa_emp_3_sec <- dt_cbp_msa_emp_2_sec %>%
  mutate_all(funs(emp_pct = ./tot_emp))


# (b) annual payroll
dt_cbp_msa_ap_1_sec <- filter(dt_cbp_d, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, msa, sector) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_msa_ap_2_sec <- spread(dt_cbp_msa_ap_1_sec, sector, ap) %>%
  rename_at(vars(-year,-msa), function(x) paste0(x, "_ap"))

dt_cbp_msa_ap_2_sec$tot_ap <- rowSums(dt_cbp_msa_ap_2_sec[,3:21], na.rm = TRUE)
dt_cbp_msa_ap_3_sec <- dt_cbp_msa_ap_2_sec %>%
  mutate_all(funs(pct = ./tot_ap))


## Combine (a),(b), and (c)
dt_cbp_msa_comb_sec_a <- left_join(dt_cbp_msa_est_3_sec, dt_cbp_msa_emp_3_sec, by = c("year", "msa"))
dt_cbp_msa_comb_sec_b <- left_join(dt_cbp_msa_comb_sec_a, dt_cbp_msa_ap_3_sec, by = c("year", "msa"))



dt_cbp_msa_comb_sec_c <- dt_cbp_msa_comb_sec_b %>%
  select(year, msa, Manufacturing_est, Manufacturing_est_est_pct, Manufacturing_emp, Manufacturing_emp_emp_pct,
         Manufacturing_ap, Manufacturing_ap_pct)


dt_cbp_msa_comb_sec_c %>%
  group_by(year) %>%
  summarize(Manufacturing_emp_emp_pct = mean(Manufacturing_emp_emp_pct, na.rm = TRUE))

dt_cbp_msa_comb_sec_d <- dt_cbp_msa_comb_sec_c %>%
  ungroup() %>%
  mutate(msa = as.numeric(msa)) %>%
  rename_at(vars(-year, -msa), function(x) paste0(x, "_msa2")) %>%
  filter(year > 2002) %>% # issue with 2002 and prior obs
  # bind_rows(dt_cbp_msa_comb_sec_d) %>%
  arrange(year, msa)




###############################################################################
## 4 SAVE and EXPORT
###############################################################################

CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"

setwd(CBP_CLEAN)


fwrite(dt_cbp_msa_comb_sec_d, paste0(CBP_CLEAN, "/CBP_msadata_manuf_msa_CLEAN.csv"))



