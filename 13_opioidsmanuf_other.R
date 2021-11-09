## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Other Data Import and Prep
## File: 13_opioidsmanuf_other.R
## Description: Imports and prepares:
##  (1) Union Statistics
##  (2) drug laws from PDAPs
##  (3) state rx rates from CDC/IQVIA


library(readstata13)


## UNION STATS ----------------------------------------------------------------

union <- read.dta13("V:/seltzer/mortality/unionstats_gsu/union_memb_cov_CLEAN_simple.dta") %>%
         left_join(rename(fips, State = Name)) %>%
         mutate(state_fips = as.numeric(Code)) %>%
         select(-State, -mrstate, -Code)


substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


## DRUG LAWS ------------------------------------------------------------------

naloxone <- read.dta13("V:/seltzer/mortality/pdaps/PDAP_naloxone_clean_firststarted.dta") %>%
            left_join(rename(fips, State = Name)) %>%
            mutate(state_fips = as.numeric(Code)) %>%
            select(-State, -mrstate, -Code)

goodsam <- read.dta13("V:/seltzer/mortality/pdaps/PDAP_goodsamaritan_clean_firststarted.dta") %>%
            left_join(rename(fips, State = Name)) %>%
            mutate(state_fips = as.numeric(Code)) %>%
            select(-State, -mrstate, -Code)


pdmp <- read.csv("V:/seltzer/mortality/more/pdmp_firststarted.csv") %>%
        mutate(State = as.character(State),
               date_imp = substrRight(as.character(first_enacted), 4)) %>%
        group_by(State) %>%
        summarise(pdmp_imp = as.numeric(min(date_imp))) %>%
        left_join(rename(fips, State = Name)) %>%
        mutate(state_fips = as.numeric(Code)) %>%
        select(-State, -mrstate, -Code)

## State Rx Rates -------------------------------------------------------------

staterx <- read.csv("V:/seltzer/mortality/more/rxstate2006-2018clean.csv")
staterx2 <- staterx %>%
            gather(X2006:X2016, key = "year", value ="rx_rates") %>%
            mutate(year = as.numeric(substrRight(year, 4))) %>%
            left_join(rename(fips, State = Name)) %>%
            mutate(state_fips = as.numeric(Code)) %>%
            select(-State, -mrstate, -Code, - stateabbrv)


