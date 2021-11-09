## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP state Data
## File: 06a_opioidsmanuf_cbp_statedata.R
## Description: Uses state-level CBP data to create:
##  (1) state measures


path_state <- "V:/seltzer/cbp/state"



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




##### -------------------------------------------------------------------------
# c # IMPORT CBP DATA -
##### -------------------------------------------------------------------------

#note: different var names for different years; slight differences in codes,
#      but not really relevant for how i'm categorizing them
#note: using data downloaded via internet, not API


## Read In CBP files and compile all into one dataframe
setwd(path_state)
filenames_cbp_a_st_00s10s <- list.files(path = path_state, pattern = ".txt")
lst_cbp_a_st_00s10s <- lapply(filenames_cbp_a_st_00s10s, fread, colClasses=list(character=1:2),
                              select = c("fipstate", "naics", "lfo", "est", "emp", "ap", "qp1"), data.table = FALSE)
lst_cbp_a_st_00s10s[[1]]$year <- 2000
lst_cbp_a_st_00s10s[[2]]$year <- 2001
lst_cbp_a_st_00s10s[[3]]$year <- 2002
lst_cbp_a_st_00s10s[[4]]$year <- 2003
lst_cbp_a_st_00s10s[[5]]$year <- 2004
lst_cbp_a_st_00s10s[[6]]$year <- 2005
lst_cbp_a_st_00s10s[[7]]$year <- 2006
lst_cbp_a_st_00s10s[[8]]$year <- 2007
lst_cbp_a_st_00s10s[[9]]$year <- 2008
lst_cbp_a_st_00s10s[[10]]$year <- 2009
lst_cbp_a_st_00s10s[[11]]$year <- 2010
lst_cbp_a_st_00s10s[[12]]$year <- 2011
lst_cbp_a_st_00s10s[[13]]$year <- 2012
lst_cbp_a_st_00s10s[[14]]$year <- 2013
lst_cbp_a_st_00s10s[[15]]$year <- 2014
lst_cbp_a_st_00s10s[[16]]$year <- 2015
lst_cbp_a_st_00s10s[[17]]$year <- 2016
lst_cbp_a_st_00s10s[[18]]$year <- 1998
lst_cbp_a_st_00s10s[[19]]$year <- 1999


dt_cbp_a_st_00s10s <- data.frame(rbindlist(lst_cbp_a_st_00s10s, fill = TRUE)) %>%
  filter(lfo == "-" | is.na(lfo)==TRUE) %>%
  mutate(NAICS2Digit = substr(naics, 1, 2))


dt_cbp_a_st <- dt_cbp_a_st_00s10s

dt_cbp_b_st <- left_join(dt_cbp_a_st, NAICS_cross, by.x = "NAICS2Digit", by.y = "NAICS2Digit", all.x= TRUE) 

dt_cbp_c_st <- dt_cbp_b_st %>%
  filter(substr(naics,3,6) == "----", NAICS2Digit != "--", is.na(sector)==FALSE) %>%
  filter(year >=1997) #should already be doing this, but for good measure



##### -------------------------------------------------------------------------
# d # Wrangling CBP DATA - STATE
##### -------------------------------------------------------------------------      


## (a) business composition
dt_cbp_state_est_1 <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, domain) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(domain != "NA")

dt_cbp_state_est_2 <- spread(dt_cbp_state_est_1, domain, establishments) %>%
  mutate(pct_goodsproducing_est = GoodsProducing/(GoodsProducing + ServiceProviding),
         pct_serviceproviding_est = ServiceProviding/(GoodsProducing + ServiceProviding)) %>%
  rename(GoodsProducing_est = GoodsProducing,
         ServiceProviding_est = ServiceProviding)

## (b) worker composition

dt_cbp_state_emp_1 <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, domain) %>%
  summarise(employees = sum(emp, na.rm = TRUE)) %>%
  filter(domain != "NA")

dt_cbp_state_emp_2 <- spread(dt_cbp_state_emp_1, domain, employees) %>%
  mutate(pct_goodsproducing_emp = GoodsProducing/(GoodsProducing + ServiceProviding),
         pct_serviceproviding_emp = ServiceProviding/(GoodsProducing + ServiceProviding)) %>%
  rename(GoodsProducing_emp = GoodsProducing,
         ServiceProviding_emp = ServiceProviding)
## (c) annual payroll


dt_cbp_state_ap_1 <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, domain) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(domain != "NA")

dt_cbp_state_ap_2 <- spread(dt_cbp_state_ap_1, domain, ap) %>%
  mutate(pct_goodsproducing_ap = GoodsProducing/(GoodsProducing + ServiceProviding),
         pct_serviceproviding_ap = ServiceProviding/(GoodsProducing + ServiceProviding)) %>%
  rename(GoodsProducing_ap = GoodsProducing,
         ServiceProviding_ap = ServiceProviding)


## Combine (a),(b), and (c)
dt_cbp_state_comb_a <- left_join(dt_cbp_state_est_2, dt_cbp_state_emp_2, by = c("year", "fipstate"))
dt_cbp_state_comb_b <- left_join(dt_cbp_state_comb_a, dt_cbp_state_ap_2, by = c("year", "fipstate"))



######## ----------------------------------------------------------------------
### by sector
# (a) business composition
dt_cbp_state_est_1_sec <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, sector) %>%
  summarise(establishments = sum(est, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_state_est_2_sec <- spread(dt_cbp_state_est_1_sec, sector, establishments) %>%
  rename_at(vars(-year,-fipstate), function(x) paste0(x, "_est"))

dt_cbp_state_est_2_sec$tot_est <- rowSums(dt_cbp_state_est_2_sec[,3:21], na.rm = TRUE)
dt_cbp_state_est_3_sec <- dt_cbp_state_est_2_sec %>%
  mutate_all(funs(est_pct = ./tot_est))



# (b) employment
dt_cbp_state_emp_1_sec <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, sector) %>%
  summarise(emp = sum(emp, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_state_emp_2_sec <- spread(dt_cbp_state_emp_1_sec, sector, emp) %>%
  rename_at(vars(-year,-fipstate), function(x) paste0(x, "_emp"))

dt_cbp_state_emp_2_sec$tot_emp <- rowSums(dt_cbp_state_emp_2_sec[,3:21], na.rm = TRUE)
dt_cbp_state_emp_3_sec <- dt_cbp_state_emp_2_sec %>%
  mutate_all(funs(emp_pct = ./tot_emp))


# (b) annual payroll
dt_cbp_state_ap_1_sec <- filter(dt_cbp_c_st, NAICS2Digit != "--") %>%
  filter(substr(naics,3,6) == "----") %>%
  group_by(year, fipstate, sector) %>%
  summarise(ap = sum(ap, na.rm = TRUE)) %>%
  filter(sector != "NA")

dt_cbp_state_ap_2_sec <- spread(dt_cbp_state_ap_1_sec, sector, ap) %>%
  rename_at(vars(-year,-fipstate), function(x) paste0(x, "_ap"))

dt_cbp_state_ap_2_sec$tot_ap <- rowSums(dt_cbp_state_ap_2_sec[,3:21], na.rm = TRUE)
dt_cbp_state_ap_3_sec <- dt_cbp_state_ap_2_sec %>%
  mutate_all(funs(pct = ./tot_ap))


## Combine (a),(b), and (c)
dt_cbp_state_comb_sec_a <- left_join(dt_cbp_state_est_3_sec, dt_cbp_state_emp_3_sec, by = c("year", "fipstate"))
dt_cbp_state_comb_sec_b <- left_join(dt_cbp_state_comb_sec_a, dt_cbp_state_ap_3_sec, by = c("year", "fipstate"))


##combine both domain and sector

dt_cbp_state_comb_both <- left_join(dt_cbp_state_comb_b, dt_cbp_state_comb_sec_b, by = c("year", "fipstate")) %>%
  mutate(state_fips = as.integer(fipstate))
names(dt_cbp_state_comb_both) <- gsub(" ", "_", names(dt_cbp_state_comb_both))




###############################################################################
## 4 SAVE and EXPORT
###############################################################################

CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"

setwd(CBP_CLEAN)


fwrite(dt_cbp_state_comb_both, paste0(CBP_CLEAN, "/CBP_statedata_manuf_state_CLEAN.csv"))



