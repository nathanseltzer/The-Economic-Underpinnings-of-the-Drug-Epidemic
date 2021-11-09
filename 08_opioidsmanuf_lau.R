## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: LAU Prep 
## File: 08_opioidsmanuf_lau.R
## Description: Imports and prepares LAU data

memory.limit(1000000)

OTHER_CLEAN <- "V:/seltzer/mortality/data/clean/other"


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

MSA_CTY_XWALK_2 <- MSA_CTY_XWALK %>%
  mutate(fipscty2 = ifelse(nchar(as.character(fipscty)) == 2, 
                           paste0("0", as.character(fipscty)),
                           ifelse(nchar(as.character(fipscty)) == 1, 
                                  paste0("00", as.character(fipscty)),   
                                  as.character(fipscty))),
         fipstate2 = ifelse(nchar(as.character(fipstate)) == 1, 
                            paste0("0", as.character(fipstate)),
                            as.character(fipstate)),
         county_fips = as.numeric(paste0(fipstate2, fipscty2)))

c_cz_cross_2 <- c_cz_cross %>%
  mutate(county_fips = as.numeric(statecountyfips))






## LAU DATA
setwd("V:/seltzer/manufacturing-mobility/data/lau/raw")
filenames_lau <- list.files(path = "V:/seltzer/manufacturing-mobility/data/lau/raw", pattern = "csv")
lst_lau <- lapply(filenames_lau, fread, colClasses=list(character=1:4) )
dt_lau <- data.frame(rbindlist(lst_lau))
dt_lau$County.FIPS.Code2 <- ifelse(nchar(as.character(dt_lau$County.FIPS.Code)) == 2, 
                                   paste0("0", as.character(dt_lau$County.FIPS.Code)),
                                   ifelse(nchar(as.character(dt_lau$County.FIPS.Code)) == 1, 
                                          paste0("00", as.character(dt_lau$County.FIPS.Code)),   
                                          as.character(dt_lau$County.FIPS.Code)))
dt_lau$State.FIPS.Code2 <- ifelse(nchar(as.character(dt_lau$State.FIPS.Code)) == 1, 
                                  paste0("0", as.character(dt_lau$State.FIPS.Code)),
                                  as.character(dt_lau$State.FIPS.Code))
dt_lau$county_fips <- as.numeric(paste0(dt_lau$State.FIPS.Code2, dt_lau$County.FIPS.Code2))


dt_lau2 <- dt_lau %>%
           left_join(select(MSA_CTY_XWALK_2, -fipstate, -fipscty, -fipscty2, -fipstate2)) %>%
           left_join(select(c_cz_cross_2, -statename, -state_fips, -stateabbrv, -statecountyfips, -cty))

dt_lau3_cty <- dt_lau2 %>%
                group_by(Year, county_fips) %>%
                summarize(Labor.Force = sum(Labor.Force),
                          Employed = sum(Employed),
                          Level = sum(Level),
                          Unemployed.Rate = Level/Labor.Force) %>%
                select(Year, county_fips, Labor.Force, Unemployed.Rate) %>%
                rename(year = Year) %>%
                rename_at(vars(-year, -county_fips), function(x) paste0(x, ".cty"))
  

dt_lau3_cbsa <- dt_lau2 %>%
                group_by(Year, msa) %>%
                summarize(Labor.Force = sum(Labor.Force),
                          Employed = sum(Employed),
                          Level = sum(Level),
                          Unemployed.Rate = Level/Labor.Force) %>%
                select(Year, msa, Labor.Force, Unemployed.Rate) %>%
                rename(year = Year) %>%
                rename_at(vars(-year, -msa), function(x) paste0(x, ".msa"))

dt_lau3_cz <- dt_lau2 %>%
              group_by(Year, cz) %>%
              summarize(Labor.Force = sum(Labor.Force),
                        Employed = sum(Employed),
                        Level = sum(Level),
                        Unemployed.Rate = Level/Labor.Force) %>%
              select(Year, cz, Labor.Force, Unemployed.Rate) %>%
              rename(year = Year) %>%
              rename_at(vars(-year, -cz), function(x) paste0(x, ".cz"))

dt_lau3_state <- dt_lau2 %>%
                  group_by(Year, State.FIPS.Code) %>%
                  summarize(Labor.Force = sum(Labor.Force, na.rm = TRUE),
                            Employed = sum(Employed, na.rm = TRUE),
                            Level = sum(Level, na.rm = TRUE),
                            Unemployed.Rate = Level/Labor.Force) %>%
                  select(Year, State.FIPS.Code, Labor.Force, Unemployed.Rate) %>%
                  rename(year = Year) %>%
                  rename_at(vars(-year, -State.FIPS.Code), function(x) paste0(x, ".st")) %>%
                  filter(year > 1997) %>%
                  mutate(state_fips = as.numeric(State.FIPS.Code))


fwrite(dt_lau2, paste0(OTHER_CLEAN, "/dt_lau2_CLEAN.csv"))

fwrite(dt_lau3_cty, paste0(OTHER_CLEAN, "/dt_lau3_cty_CLEAN.csv"))
fwrite(dt_lau3_cbsa, paste0(OTHER_CLEAN, "/dt_lau3_cbsa_CLEAN.csv"))
fwrite(dt_lau3_cz, paste0(OTHER_CLEAN, "/dt_lau3_cz_CLEAN.csv"))
fwrite(dt_lau3_state, paste0(OTHER_CLEAN, "/dt_lau3_state_CLEAN.csv"))




