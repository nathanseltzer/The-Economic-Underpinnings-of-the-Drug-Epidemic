## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: AHRQ Import and Prep
## File: 11_opioidsmanuf_ahrq.R
## Description: Imports and prepares AHRQ data


OTHER_CLEAN <- "V:/seltzer/mortality/data/clean/other"


ahrq <- fread("V:/seltzer/mortality/ahrq/HCUP_Opioid_Raw.csv", header=T)

ahrq_1 <- ahrq %>%
          filter(Characteristic == "Total" | Characteristic == "Sex")
        

ahrq_2 <- ahrq_1 %>%
          gather(Year, rate, `2005`:`2017`) %>%
          filter(State != "National")


## Prep


    ahrq_3_IP_a <- ahrq_2 %>%
                    filter(`Hospital Setting` == "IP", `Characteristic Level` == "All Inpatient Stays") %>%
                    select(State, Year, rate) %>%
                    rename(IP_rate_all = rate)
    
    ahrq_3_IP_m <- ahrq_2 %>%
                    filter(`Hospital Setting` == "IP", `Characteristic Level` == "Males") %>%
                    select(State, Year, rate) %>%
                    rename(IP_rate_m = rate)
    
    ahrq_3_IP_f <- ahrq_2 %>%
                    filter(`Hospital Setting` == "IP", `Characteristic Level` == "Females") %>%
                    select(State, Year, rate) %>%
                    rename(IP_rate_f = rate)
    
    ahrq_3_ED_a <- ahrq_2 %>%
                    filter(`Hospital Setting` == "ED", `Characteristic Level` == "All ED Visits") %>%
                    select(State, Year, rate) %>%
                    rename(ED_rate_all = rate)
    
    ahrq_3_ED_m <- ahrq_2 %>%
                    filter(`Hospital Setting` == "ED", `Characteristic Level` == "Males") %>%
                    select(State, Year, rate) %>%
                    rename(ED_rate_m = rate)
    
    ahrq_3_ED_f <- ahrq_2 %>%
                    filter(`Hospital Setting` == "ED", `Characteristic Level` == "Females") %>%
                    select(State, Year, rate) %>%
                    rename(ED_rate_f = rate)
    
    
    
ahrq_4 <-           ahrq_3_IP_a   %>%
          left_join(ahrq_3_IP_m)  %>%
          left_join(ahrq_3_IP_f)  %>%
          left_join(ahrq_3_ED_a)  %>%
          left_join(ahrq_3_ED_m)  %>%
          left_join(ahrq_3_ED_f) %>%
          mutate_at(vars(-State, -Year), function(x) as.numeric(x)) %>%
          rename(Name = State,
                 year = Year) %>%
          left_join(fips) %>%
          rename(state = Name,
                 state_fips = Code) %>%
          mutate(state_fips = as.numeric(state_fips),
                 year = as.numeric(year))


fwrite(ahrq_4, paste0(OTHER_CLEAN, "/ahrq_4.csv"))

    
    