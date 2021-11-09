## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: NCHS Pop Import and Prep 
## File: 09_opioidsmanuf_pop.R
## Description: Imports and prepares NCHS pop data

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


fips <- fread("V:/noblesnchs/working/ns - recession/variousdata/fipscrosswalk.csv" , colClasses=list(character=1:3))
standardpop <- read.csv("V:/obrien ssa/data/various/standardpop2000.csv", stringsAsFactors = FALSE)



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



NCHS_tot_pop_1 <- fread("V:/obrien ssa/data/clean/NCHS_tot_pop_1.csv") 




totpop_1 <- NCHS_tot_pop_1 %>%
            rename(state_fips = ST_FIPS2,
                   county_fips = statecountyfips,
                   year = YEAR) %>%
            left_join(MSA_CTY_XWALK_2) %>%
            left_join(c_cz_cross_2) %>%
  filter(year > 1997)
        
## OVERALL

  totpop_2_cty <- totpop_1 %>%
                  group_by(county_fips, year) %>%
                  summarize(totpop_cty = sum(pop)) %>%
                  mutate(totpop_2_cty_avg = mean(totpop_cty))
  
  totpop_2_msa <- totpop_1 %>%
                  group_by(msa, year) %>%
                  summarize(totpop_msa = sum(pop)) %>%
                  mutate(totpop_2_msa_avg = mean(totpop_msa))
                  
  
  totpop_2_cz <- totpop_1 %>%
                  group_by(cz, year) %>%
                  summarize(totpop_cz = sum(pop)) %>%
                  mutate(totpop_2_cz_avg = mean(totpop_cz))
  
  totpop_2_st <- totpop_1 %>%
                  group_by(state_fips, year) %>%
                  summarize(totpop_st = sum(pop)) %>%
                  mutate(totpop_2_st_avg = mean(totpop_st))
  
  
##by gender
  genpop_2_cty <- totpop_1 %>%
                  group_by(county_fips, year, female) %>%
                  summarize(genpop_cty = sum(pop)) 
  
  genpop_3_cty_f <- filter(genpop_2_cty, female == 1) %>%
                    group_by(county_fips) %>%
                    mutate(genpop_2_cty_avg = mean(genpop_cty)) %>%
                    rename_at(vars(-county_fips, -year, -female), function(x) paste0(x, "_f")) %>%
                    select(-female)
  
  genpop_3_cty_m <- filter(genpop_2_cty, female == 0) %>%
                    group_by(county_fips) %>%
                    mutate(genpop_2_cty_avg = mean(genpop_cty)) %>%
                    rename_at(vars(-county_fips, -year, -female), function(x) paste0(x, "_m")) %>%
                    select(-female)
  
  
  genpop_2_st <- totpop_1 %>%
                  group_by(state_fips, year, female) %>%
                  summarize(genpop_st = sum(pop)) 
  
  genpop_3_st_f <- filter(genpop_2_st, female == 1) %>%
                    group_by(state_fips) %>%
                    mutate(genpop_2_st_avg = mean(genpop_st)) %>%
                    rename_at(vars(-state_fips, -year, -female), function(x) paste0(x, "_f")) %>%
                    select(-female)
  
  genpop_3_st_m <- filter(genpop_2_st, female == 0) %>%
                    group_by(state_fips) %>%
                    mutate(genpop_2_st_avg = mean(genpop_st)) %>%
                    rename_at(vars(-state_fips, -year, -female), function(x) paste0(x, "_m")) %>%
                    select(-female)
  
  
## By Age
  
  
  ## STATE - broad
  totpop_1_structure_st <- totpop_1 %>%
    mutate(structure = ifelse(AGE < 15, "pct_lt15_st",
                       ifelse(AGE >= 15 & AGE < 65, "pct_1564_st",
                       ifelse(AGE >= 65, "pct_gt65_st", NA))))
 
  struc_1_st <- totpop_1_structure_st %>% 
    group_by(state_fips, structure, year) %>%
    summarize(totpop_st = sum(pop)) %>%
    group_by(state_fips, year) %>%
    mutate(sum = sum(totpop_st),
           struc = (totpop_st/sum)*100) %>%
    arrange(year, state_fips, structure)
  
  struc_2_st <- struc_1_st %>%
    select(state_fips, structure, year, struc) %>%
    spread(structure, struc)
  
  ## STATE - specific
  totpop_1_structure_det_st <- totpop_1 %>%
    mutate(structure_det = case_when(AGE <  5              ~ 'pct_0',
                                     AGE >= 5   & AGE < 10 ~ 'pct_5',
                                     AGE >= 10  & AGE < 15 ~ 'pct_10',
                                     AGE >= 15  & AGE < 20 ~ 'pct_15',
                                     AGE >= 20  & AGE < 25 ~ 'pct_20',
                                     AGE >= 25  & AGE < 30 ~ 'pct_25',
                                     AGE >= 30  & AGE < 35 ~ 'pct_30',
                                     AGE >= 35  & AGE < 40 ~ 'pct_35',
                                     AGE >= 40  & AGE < 45 ~ 'pct_40',
                                     AGE >= 45  & AGE < 50 ~ 'pct_45',
                                     AGE >= 50  & AGE < 55 ~ 'pct_50',
                                     AGE >= 55  & AGE < 60 ~ 'pct_55',
                                     AGE >= 60  & AGE < 65 ~ 'pct_60',
                                     AGE >= 65  & AGE < 70 ~ 'pct_65',
                                     AGE >= 70  & AGE < 75 ~ 'pct_70',
                                     AGE >= 75  & AGE < 80 ~ 'pct_75',
                                     AGE >= 80  & AGE < 85 ~ 'pct_80',
                                     AGE >= 85             ~ 'pct_85'))
           
  struc_det_1_st <- totpop_1_structure_det_st %>% 
    group_by(state_fips, structure_det, year) %>%
    summarize(totpop_st = sum(pop)) %>%
    group_by(state_fips, year) %>%
    mutate(sum = sum(totpop_st),
           struc_det = (totpop_st/sum)*100) %>%
    arrange(year, state_fips, structure_det)
  
  struc_det_2_st <- struc_det_1_st %>%
    select(state_fips, structure_det, year, struc_det) %>%
    spread(structure_det, struc_det)
  
 
  ## COUNTY - broad
  totpop_1_structure_cty <- totpop_1 %>%
    mutate(structure = ifelse(AGE < 15, "pct_lt15_cty",
                              ifelse(AGE >= 15 & AGE < 65, "pct_1564_cty",
                                     ifelse(AGE >= 65, "pct_gt65_cty", NA))))
  
  struc_1_cty <- totpop_1_structure_cty %>% 
    group_by(county_fips, structure, year) %>%
    summarize(totpop_cty = sum(pop)) %>%
    group_by(county_fips, year) %>%
    mutate(sum = sum(totpop_cty),
           struc = (totpop_cty/sum)*100) %>%
    arrange(year, county_fips, structure)
  
  struc_2_cty <- struc_1_cty %>%
    select(county_fips, structure, year, struc) %>%
    spread(structure, struc)
   
  ## County - specific
  totpop_1_structure_det_cty <- totpop_1 %>%
    mutate(structure_det = case_when(AGE <  5              ~ 'pct_0',
                                     AGE >= 5   & AGE < 10 ~ 'pct_5',
                                     AGE >= 10  & AGE < 15 ~ 'pct_10',
                                     AGE >= 15  & AGE < 20 ~ 'pct_15',
                                     AGE >= 20  & AGE < 25 ~ 'pct_20',
                                     AGE >= 25  & AGE < 30 ~ 'pct_25',
                                     AGE >= 30  & AGE < 35 ~ 'pct_30',
                                     AGE >= 35  & AGE < 40 ~ 'pct_35',
                                     AGE >= 40  & AGE < 45 ~ 'pct_40',
                                     AGE >= 45  & AGE < 50 ~ 'pct_45',
                                     AGE >= 50  & AGE < 55 ~ 'pct_50',
                                     AGE >= 55  & AGE < 60 ~ 'pct_55',
                                     AGE >= 60  & AGE < 65 ~ 'pct_60',
                                     AGE >= 65  & AGE < 70 ~ 'pct_65',
                                     AGE >= 70  & AGE < 75 ~ 'pct_70',
                                     AGE >= 75  & AGE < 80 ~ 'pct_75',
                                     AGE >= 80  & AGE < 85 ~ 'pct_80',
                                     AGE >= 85             ~ 'pct_85'))
  
  struc_det_1_cty <- totpop_1_structure_det_cty %>% 
    group_by(county_fips, structure_det, year) %>%
    summarize(totpop_cty = sum(pop)) %>%
    group_by(county_fips, year) %>%
    mutate(sum = sum(totpop_cty),
           struc_det = (totpop_cty/sum)*100) %>%
    arrange(year, county_fips, structure_det)
  
  struc_det_2_cty <- struc_det_1_cty %>%
    select(county_fips, structure_det, year, struc_det) %>%
    spread(structure_det, struc_det)
  
  
  ## COMMUTING ZONE - broad
  totpop_1_structure_cz <- totpop_1 %>%
    mutate(structure = ifelse(AGE < 15, "pct_lt15_cz",
                              ifelse(AGE >= 15 & AGE < 65, "pct_1564_cz",
                                     ifelse(AGE >= 65, "pct_gt65_cz", NA))))
  
  struc_1_cz <- totpop_1_structure_cz %>% 
    group_by(cz, structure, year) %>%
    summarize(totpop_cz = sum(pop)) %>%
    group_by(cz, year) %>%
    mutate(sum = sum(totpop_cz),
           struc = (totpop_cz/sum)*100) %>%
    arrange(year, cz, structure)
  
  struc_2_cz <- struc_1_cz %>%
    select(cz, structure, year, struc) %>%
    spread(structure, struc)  
  
  
  
  
  
  
    
## RURAL POPULATION
  
  
  
  rural_1 <- read.csv("V:/seltzer/mortality/more/ruralurbancodes2013.csv")            
  
  rural_2 <- rural_1 %>%
    mutate(rural = case_when(RUCC_2013 >= 4 ~ 1,
                             RUCC_2013 <= 3 ~ 0)) %>%
    select(county_fips, rural)
  
  
  rural_3 <- left_join(rural_2, totpop_1) %>%
    group_by(state_fips, county_fips, rural, year) %>%
    summarize(totpop_cty = sum(pop))
  
  rural_4 <- rural_3 %>%
    group_by(state_fips, year, rural) %>%
    summarize(totpop_cty2 = sum(totpop_cty)) %>%
    group_by(state_fips, year) %>%
    mutate(cty_total = sum(totpop_cty2),
           pct = totpop_cty2/cty_total) 
  
  rural_5 <- rural_4 %>%
    filter(rural == 0) %>%
    select(state_fips, year, pct) %>%
    rename(pct_metro = pct)
  

### RACE - COUNTY
  pop_race_sex_hisp1 <- totpop_1 %>%
    mutate(race_r = case_when(RACESEX == 1 | RACESEX == 2 ~ "white",
                              RACESEX == 3 | RACESEX == 4 ~ "black",
                              RACESEX == 5 | RACESEX == 6 ~ "aian",
                              RACESEX == 7 | RACESEX == 8 ~ "api"),
           raceeth_r = case_when(race_r == "white" & hisp == 1 ~ "nhwhite_pct_cty",
                                 race_r == "black" & hisp == 1 ~ "nhblack_pct_cty",
                                 race_r == "aian" & hisp == 1 ~ "nhaian_pct_cty",
                                 race_r == "api" & hisp == 1 ~ "nhapi_pct_cty",
                                 (race_r == "white" | race_r == "black" |
                                    race_r == "aian" | race_r == "api") & hisp == 2 ~ "hispanic_pct_cty"))
  
  pop_race_sex_hisp2 <-  pop_race_sex_hisp1 %>%
    group_by(county_fips, year, raceeth_r ) %>%
    summarize(pop = sum(pop)) %>%
    group_by(county_fips, year) %>%
    mutate(pct = (pop/sum(pop))*100) %>%
    select(-pop)
  
  pop_race_sex_hisp3 <- pop_race_sex_hisp2 %>%
    spread(raceeth_r, pct)
  
  head(pop_race_sex_hisp1)
  head(pop_race_sex_hisp2)
  head(pop_race_sex_hisp3)
  
  
    
## SAVE  
  
fwrite(totpop_2_cty, paste0(OTHER_CLEAN, "/totpop_2_cty_CLEAN.csv"))
fwrite(totpop_2_msa, paste0(OTHER_CLEAN, "/totpop_2_msa_CLEAN.csv"))
fwrite(totpop_2_cz, paste0(OTHER_CLEAN, "/totpop_2_cz_CLEAN.csv"))
fwrite(totpop_2_st, paste0(OTHER_CLEAN, "/totpop_2_st_CLEAN.csv"))

fwrite(genpop_3_cty_f, paste0(OTHER_CLEAN, "/genpop_3_cty_f.csv"))
fwrite(genpop_3_cty_m, paste0(OTHER_CLEAN, "/genpop_3_cty_m.csv"))
fwrite(genpop_3_st_f, paste0(OTHER_CLEAN, "/genpop_3_st_f.csv"))
fwrite(genpop_3_st_m, paste0(OTHER_CLEAN, "/genpop_3_st_m.csv"))
            
            
fwrite(struc_2_cty, paste0(OTHER_CLEAN, "/struc_2_cty_CLEAN.csv"))
fwrite(struc_2_cz, paste0(OTHER_CLEAN, "/struc_2_cz_CLEAN.csv"))
fwrite(struc_2_st, paste0(OTHER_CLEAN, "/struc_2_st_CLEAN.csv"))
fwrite(struc_det_2_st, paste0(OTHER_CLEAN, "/struc_det_2_st.csv"))
fwrite(struc_det_2_cty, paste0(OTHER_CLEAN, "/struc_det_2_cty.csv"))

fwrite(rural_5, paste0(OTHER_CLEAN, "/rural_5_st_CLEAN.csv"))

fwrite(pop_race_sex_hisp3, paste0(OTHER_CLEAN, "/pop_race_sex_hisp3.csv"))

            






