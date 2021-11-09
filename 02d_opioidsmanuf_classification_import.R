## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Corrected Opioid Deaths Import 
## File: 02d_opioidsmanuf_classification_import.R
## Description: Import and Prep NCHS MCOD data for predictions of unclassified
##  drug deaths

##Packages --------------------------------------------------------------------
library(foreign)
library(readstata13)
library(dplyr)
library(data.table)
library(ggplot2)
memory.limit(1000000)
options(scipen = 999)


##County/CZ Crosswalks, etc.. ------------------------------------------------- 

##county-cz crosswalk
c_cz_cross <- read.csv("V:/obrien ssa/data/various/cty_cz_st_crosswalk.csv") %>%
  mutate(statecountyfips = ifelse((nchar(cty))==4, paste0("0", cty), cty))




##IMPORTANT** - PRIOR to 2003 (1989-2002), state codes/fips codes are DIFFERENT*** - 
## NECESSARY TO USE THE SPECIAL FIPS VARS not the normal countyrs, etc.


fips <- read.csv("V:/obrien ssa/data/various/fipscrosswalk.csv")

fips_staters <- fips %>%
  rename(staters_char= stateabbrv) %>%
  mutate(code = ifelse(nchar(code) == 1,
                       paste0("0", code),
                       code))

fips <- fread("V:/noblesnchs/working/ns - recession/variousdata/fipscrosswalk.csv" , colClasses=list(character=1:3))
standardpop <- read.csv("V:/obrien ssa/data/various/standardpop2000.csv", stringsAsFactors = FALSE)



### LOAD IN POP DATA
NCHS_tot_pop_1 <- fread("V:/obrien ssa/data/clean/NCHS_tot_pop_1.csv")



setwd("V:/obrien ssa/data/clean/NCHS Mortality Clean")

##MORTALITY DATA IMPORT -------------------------------------------------------

## (1) 1989-1998 - not necessary for this project - omitted

## (2) 1999-2002 --------------------------------------------------------------

mort.1999.2002 <- data.frame()
for (year in 1999:2002){
  file_x <- fread(paste0("mortality",year,"-restricted-extract-2-26-2019.csv"),
                  select = c("year",
                             "countyoc",
                             "stateoc",
                             "countyrs",
                             "staters",
                             "fipsstr",
                             "fipsctyr",
                             "educ",
                             "sex",
                             "race",
                             "age",
                             "ager12",
                             "hispanic",
                             "indusr15",
                             "industry",
                             "occupr9",
                             "occup",
                             "ucod",
                             "record_1",
                             "record_2",
                             "record_3",
                             "record_4",
                             "record_5",
                             "record_6",
                             "record_7",
                             "record_8",
                             "record_9",
                             "record_10",
                             "record_11",
                             "record_12",
                             "record_13",
                             "record_14",
                             "record_15",
                             "record_16",
                             "record_17",
                             "record_18",
                             "record_19",
                             "record_20",
                             "marstat",
                             "weekday",
                             "monthdth",
                             "placdth",
                             "educr"))
  mort.1999.2002 <- bind_rows(mort.1999.2002,file_x)
  print(year)
  # datalist[[year]] <- file_x
  
}

mort.1999.2002_prep <-  mort.1999.2002 %>%
  mutate(statecountyfips = ifelse(nchar(fipsctyr)==4,
                                  paste0("0", fipsctyr),
                                  fipsctyr))

## (3) 2003-2004 --------------------------------------------------------------


mort.2003.2004 <- data.frame()
for (year in 2003:2004){
  file_x <- fread(paste0("mortality",year,"-restricted-extract-2-26-2019.csv"),
                  select = c("year",
                             "countyoc",
                             "stateoc",
                             "countyrs",
                             "staters",
                             "educ",
                             "sex",
                             "race",
                             "age",
                             "ager12",
                             "hispanic",
                             "indusr15",
                             "industry",
                             "occupr9",
                             "occup",
                             "ucod",
                             "record_1",
                             "record_2",
                             "record_3",
                             "record_4",
                             "record_5",
                             "record_6",
                             "record_7",
                             "record_8",
                             "record_9",
                             "record_10",
                             "record_11",
                             "record_12",
                             "record_13",
                             "record_14",
                             "record_15",
                             "record_16",
                             "record_17",
                             "record_18",
                             "record_19",
                             "record_20",
                             "marstat",
                             "weekday",
                             "monthdth",
                             "placdth"))
  mort.2003.2004 <- bind_rows(mort.2003.2004,file_x)
  print(year)
  # datalist[[year]] <- file_x
  
}

# table(nchar(mort.2003.2004$countyrs)) ## 32 obs in 2004 with only state in countyrs


mort.2003.2004_prep <-  mort.2003.2004 %>%
  mutate(countyoc = as.integer(substr(countyoc, 3,5)),
         countyrs = as.character(substr(countyrs, 3,5)),
         stateoc_char = stateoc,
         stateoc = NULL,
         staters_char = staters,
         staters = NULL,
         sex = ifelse(sex == "F", 2,
                      ifelse(sex == "M", 1, NA))) %>%
  left_join(fips_staters, by = "staters_char") %>%
  mutate(statecountyfips = paste0(code, countyrs))


## (4) 2005-2017 --------------------------------------------------------------

mort.2005.2017 <- data.frame()
for (year in 2005:2017){
  file_x <- fread(paste0("mortality",year,"-restricted-extract-2-26-2019.csv"),
                  select = c("datayear",
                             "year",
                             "countyoc",
                             "stateoc",
                             "ostate",
                             "octyfips",
                             "countyrs",
                             "staters",
                             "rstate",
                             "rctyfips",
                             "educ",
                             "sex",
                             "race",
                             "age",
                             "ager12",
                             "hispanic",
                             "indusr15",
                             "industry",
                             "occupr9",
                             "occup",
                             "ucod",
                             "record_1",
                             "record_2",
                             "record_3",
                             "record_4",
                             "record_5",
                             "record_6",
                             "record_7",
                             "record_8",
                             "record_9",
                             "record_10",
                             "record_11",
                             "record_12",
                             "record_13",
                             "record_14",
                             "record_15",
                             "record_16",
                             "record_17",
                             "record_18",
                             "record_19",
                             "record_20"))
  mort.2005.2017 <- bind_rows(mort.2005.2017,file_x)
  print(year)
  # datalist[[year]] <- file_x
  
}


mort.2005.2017_prep <-  mort.2005.2017 %>%
  mutate(countyrs = as.character(countyrs),
         stateoc_char = stateoc,
         stateoc = NULL,
         staters_char = staters,
         staters = NULL,
         sex = ifelse(sex == "F", 2,
                      ifelse(sex == "M", 1, NA))) %>%
  mutate(countyrs = ifelse(nchar(countyrs) == 1, paste0("00", countyrs),
                           ifelse(nchar(countyrs) == 2, paste0("0", countyrs),
                                  countyrs))) %>%
  left_join(fips_staters, by = "staters_char") %>%
  mutate(statecountyfips = paste0(code, countyrs))




head(mort.2005.2017_prep)



## (5) COMBINE ALL FILES ------------------------------------------------------


mort_full <- bind_rows(mort.1999.2002_prep,
                       mort.2003.2004_prep,
                       mort.2005.2017_prep)

fwrite(mort_full, "V:/seltzer/mortality/full_mortality_data_1999_2017-RESTRICTED_keeponwinstat.csv")

# mort_full <- fread("V:/seltzer/mortality/full_mortality_data_1989_2017-RESTRICTED_keeponwinstat.csv")


mort_full2 <- mort_full %>%
  mutate(st = substr(statecountyfips, 1,2),
         cty = substr(statecountyfips, 3,5),
         death = 1,
         agecat = ifelse(ager12 ==1, "<1",
                         ifelse(ager12 ==2, "1-4",
                                ifelse(ager12 ==3, "5-14",
                                       ifelse(ager12 ==4, "15-24",
                                              ifelse(ager12 ==5, "25-34",
                                                     ifelse(ager12 ==6, "35-44",
                                                            ifelse(ager12 ==7, "45-54",
                                                                   ifelse(ager12 ==8, "55-64",
                                                                          ifelse(ager12 ==9, "65-74",
                                                                                 ifelse(ager12 ==10, "75-84",
                                                                                        ifelse(ager12 ==11, "85+", NA))))))))))))



mort_full3 <- mort_full2 %>%
  left_join(c_cz_cross, by = "statecountyfips") %>%
  mutate(T40.0 = ifelse(	record_1	==	"T400" |			
                           record_2	==	"T400" |			
                           record_3	==	"T400" |			
                           record_4	==	"T400" |			
                           record_5	==	"T400" |			
                           record_6	==	"T400" |			
                           record_7	==	"T400" |			
                           record_8	==	"T400" |			
                           record_9	==	"T400" |			
                           record_10	==	"T400" |			
                           record_11	==	"T400" |			
                           record_12	==	"T400" |			
                           record_13	==	"T400" |			
                           record_14	==	"T400" |			
                           record_15	==	"T400" |			
                           record_16	==	"T400" |			
                           record_17	==	"T400" |			
                           record_18	==	"T400" |			
                           record_19	==	"T400" |			
                           record_20	==	"T400" ,	1,	NA	),
         T40.1 = ifelse(	record_1	==	"T401" |			
                           record_2	==	"T401" |			
                           record_3	==	"T401" |			
                           record_4	==	"T401" |			
                           record_5	==	"T401" |			
                           record_6	==	"T401" |			
                           record_7	==	"T401" |			
                           record_8	==	"T401" |			
                           record_9	==	"T401" |			
                           record_10	==	"T401" |			
                           record_11	==	"T401" |			
                           record_12	==	"T401" |			
                           record_13	==	"T401" |			
                           record_14	==	"T401" |			
                           record_15	==	"T401" |			
                           record_16	==	"T401" |			
                           record_17	==	"T401" |			
                           record_18	==	"T401" |			
                           record_19	==	"T401" |			
                           record_20	==	"T401" ,	1,	NA	),
         T40.2 = ifelse(	record_1	==	"T402" |			
                           record_2	==	"T402" |			
                           record_3	==	"T402" |			
                           record_4	==	"T402" |			
                           record_5	==	"T402" |			
                           record_6	==	"T402" |			
                           record_7	==	"T402" |			
                           record_8	==	"T402" |			
                           record_9	==	"T402" |			
                           record_10	==	"T402" |			
                           record_11	==	"T402" |			
                           record_12	==	"T402" |			
                           record_13	==	"T402" |			
                           record_14	==	"T402" |			
                           record_15	==	"T402" |			
                           record_16	==	"T402" |			
                           record_17	==	"T402" |			
                           record_18	==	"T402" |			
                           record_19	==	"T402" |			
                           record_20	==	"T402" ,	1,	NA	),
         T40.3 = ifelse(	record_1	==	"T403" |			
                           record_2	==	"T403" |			
                           record_3	==	"T403" |			
                           record_4	==	"T403" |			
                           record_5	==	"T403" |			
                           record_6	==	"T403" |			
                           record_7	==	"T403" |			
                           record_8	==	"T403" |			
                           record_9	==	"T403" |			
                           record_10	==	"T403" |			
                           record_11	==	"T403" |			
                           record_12	==	"T403" |			
                           record_13	==	"T403" |			
                           record_14	==	"T403" |			
                           record_15	==	"T403" |			
                           record_16	==	"T403" |			
                           record_17	==	"T403" |			
                           record_18	==	"T403" |			
                           record_19	==	"T403" |			
                           record_20	==	"T403" ,	1,	NA	),
         T40.4 = ifelse(	record_1	==	"T404" |			
                           record_2	==	"T404" |			
                           record_3	==	"T404" |			
                           record_4	==	"T404" |			
                           record_5	==	"T404" |			
                           record_6	==	"T404" |			
                           record_7	==	"T404" |			
                           record_8	==	"T404" |			
                           record_9	==	"T404" |			
                           record_10	==	"T404" |			
                           record_11	==	"T404" |			
                           record_12	==	"T404" |			
                           record_13	==	"T404" |			
                           record_14	==	"T404" |			
                           record_15	==	"T404" |			
                           record_16	==	"T404" |			
                           record_17	==	"T404" |			
                           record_18	==	"T404" |			
                           record_19	==	"T404" |			
                           record_20	==	"T404" ,	1,	NA	),
         T40.6 = ifelse(	record_1	==	"T406" |			
                           record_2	==	"T406" |			
                           record_3	==	"T406" |			
                           record_4	==	"T406" |			
                           record_5	==	"T406" |			
                           record_6	==	"T406" |			
                           record_7	==	"T406" |			
                           record_8	==	"T406" |			
                           record_9	==	"T406" |			
                           record_10	==	"T406" |			
                           record_11	==	"T406" |			
                           record_12	==	"T406" |			
                           record_13	==	"T406" |			
                           record_14	==	"T406" |			
                           record_15	==	"T406" |			
                           record_16	==	"T406" |			
                           record_17	==	"T406" |			
                           record_18	==	"T406" |			
                           record_19	==	"T406" |			
                           record_20	==	"T406" ,	1,	NA	),
         opioid = ifelse(T40.0 == 1 |
                           T40.1 == 1 |
                           T40.2 == 1 |
                           T40.3 == 1 | 
                           T40.4 == 1 | 
                           T40.6 == 1, 1, 0))

fwrite(mort_full3, "V:/seltzer/mortality/data/full_mortality_data_1999_2017_mort_full3_-RESTRICTED_keeponwinstat.csv")

# mort_full3 <- fread( "V:/seltzer/mortality/data/full_mortality_data_1999_2017_mort_full3_-RESTRICTED_keeponwinstat.csv")

