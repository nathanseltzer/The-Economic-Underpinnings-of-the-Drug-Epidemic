## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP state Data (pre 1998)
## File: 06b_opioidsmanuf_cbp_statedata_pre1998.R
## Description: Uses pre1998 state-level CBP data to create:
##  (1) state measures

library(tidyverse)
library(data.table)

path_state1997 <- "V:/seltzer/cbp/state/state_pre1998"
CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"



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


# # #   ############# -- commented out because takes long time to run
##1987-1997
setwd("V:/seltzer/cbp/state/state_pre1998")
filenames_cbp_a_SIC <- list.files(path = "V:/seltzer/cbp/state/state_pre1998", pattern = ".txt")
lst_cbp_a_SIC <- lapply(filenames_cbp_a_SIC, fread, colClasses=list(character=1:2),
                        select = c("fipstate", "naics", "sic", "est",
                                   "emp", "qp1", "ap"), data.table = FALSE)
lst_cbp_a_SIC[[1]]$year <- 1995
lst_cbp_a_SIC[[2]]$year <- 1996
lst_cbp_a_SIC[[3]]$year <- 1997

dt_cbp_a_SIC <- data.frame(rbindlist(lst_cbp_a_SIC)) %>%
  filter(year != 1986)

dt_cbp_a2_SIC <- mutate(dt_cbp_a_SIC,
                        dash = grepl("--", sic),
                        SIC2Digit = substr(sic, 1, 2)) %>%
  filter(dash == TRUE, sic != "----")
dt_cbp_a4_SIC <- left_join(dt_cbp_a2_SIC, SIC_cross, by.x = "SIC2Digit", by.y = "SIC2Digit", all.x= TRUE) %>%
  filter(supersector != "NA") %>%  ##remove unclassified establishments
  mutate(manufacturing = ifelse(sic == "20--", "Manufacturing", "NonManufacturing")) 
dt_cbp_a5_SIC <- group_by(dt_cbp_a4_SIC, year, fipstate, manufacturing) %>%
  summarize(establishments = sum(est, na.rm = TRUE),
            march_emp      = sum(emp, na.rm = TRUE),
            Q1_payroll     = sum(qp1, na.rm = TRUE),
            a_payroll      = sum(ap,  na.rm = TRUE))

##est
dt_cbp_a6_SIC_est <- select(dt_cbp_a5_SIC, -march_emp, -Q1_payroll, -a_payroll) %>%
  spread(manufacturing, establishments) %>%
  mutate(Manufacturing_est_est_pct = Manufacturing/(Manufacturing + NonManufacturing)) %>%
  rename(Manufacturing_est = Manufacturing)

##emp
dt_cbp_a6_SIC_emp <- select(dt_cbp_a5_SIC, -establishments, -Q1_payroll, -a_payroll) %>%
  spread(manufacturing, march_emp) %>%
  mutate(Manufacturing_emp_emp_pct = Manufacturing/(Manufacturing + NonManufacturing)) %>%
  rename(Manufacturing_emp   = Manufacturing)

##Q1 Payroll
dt_cbp_a6_SIC_q1 <- select(dt_cbp_a5_SIC, -establishments, -march_emp, -a_payroll) %>%
  spread(manufacturing, Q1_payroll) %>%
  mutate(pct_Manufacturing_q1p = Manufacturing/(Manufacturing + NonManufacturing)) %>%
  rename(Manufacturing_q1p   = Manufacturing)

##annual Payroll
dt_cbp_a6_SIC_ap <- select(dt_cbp_a5_SIC, -establishments, -march_emp, -Q1_payroll) %>%
  spread(manufacturing, a_payroll) %>%
  mutate(Manufacturing_ap_pct = Manufacturing/(Manufacturing + NonManufacturing)) %>%
  rename(Manufacturing_ap   = Manufacturing)

##COMBINE ALL
dt_cbp_a6_SIC_prep1 <- left_join(dt_cbp_a6_SIC_est, dt_cbp_a6_SIC_emp, by =c("year", "fipstate"))
dt_cbp_a6_SIC_prep2 <- left_join(dt_cbp_a6_SIC_prep1, dt_cbp_a6_SIC_q1, by =c("year", "fipstate"))
dt_cbp_a6_SIC       <- left_join(dt_cbp_a6_SIC_prep2, dt_cbp_a6_SIC_ap, by =c("year", "fipstate"))

dt_cbp_a7_SIC <- dt_cbp_a6_SIC %>%
  select(-NonManufacturing.x, -NonManufacturing.x.x, -NonManufacturing.y, -NonManufacturing.y.y) %>%
  mutate(state_fips = as.numeric(fipstate))


dt_cbp_a8_SIC <- dt_cbp_a7_SIC %>%
  ungroup(fipstate) %>%
  select(year, state_fips, Manufacturing_emp_emp_pct, Manufacturing_ap_pct) %>%
  mutate(Manufacturing_emp_emp_pct = Manufacturing_emp_emp_pct*100,
         Manufacturing_ap_pct = Manufacturing_ap_pct*100)
  
  
dt_cbp_a8_SIC_95 <- filter(dt_cbp_a8_SIC, year == 1995) %>%
  rename(Manufacturing_emp_emp_pct_1995  = Manufacturing_emp_emp_pct,
         Manufacturing_ap_pct_1995 = Manufacturing_ap_pct) %>%
  ungroup() %>%
  mutate(year = NULL)

dt_cbp_a8_SIC_96 <- filter(dt_cbp_a8_SIC, year == 1996) %>%
  rename(Manufacturing_emp_emp_pct_1996  = Manufacturing_emp_emp_pct,
         Manufacturing_ap_pct_1996 = Manufacturing_ap_pct) %>%
  ungroup() %>%
  mutate(year = NULL)


dt_cbp_a8_SIC_97 <- filter(dt_cbp_a8_SIC, year == 1997) %>%
  rename(Manufacturing_emp_emp_pct_1997  = Manufacturing_emp_emp_pct,
         Manufacturing_ap_pct_1997 = Manufacturing_ap_pct) %>%
  ungroup() %>%
  mutate(year = NULL)

dt_cbp_a9_SIC <- left_join(dt_cbp_a8_SIC_95, dt_cbp_a8_SIC_96) %>%
                  left_join(dt_cbp_a8_SIC_97)


fwrite(dt_cbp_a9_SIC, paste0(CBP_CLEAN, "/dt_cbp_a9_SICpre1998_CLEAN.csv"))


