## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CPS Import and Prep
## File: 12_opioidsmanuf_cps.R
## Description: Imports and prepares CPS data



library(ipumsr)
library(data.table)
# library(dplyr)
# library(ggplot2)
# library(Hmisc)
# library(ggthemes)
# theme_set(theme_tufte())

setwd("V:/seltzer/mortality/cps")


#INPUT - READ FILE
##see: https://cran.r-project.org/web/packages/ipumsr/vignettes/ipums-cps.html
cps_ddi_file <- "cps_00026.xml"
cps_data_file <- "cps_00026.dat"
cps_ddi <- read_ipums_ddi(cps_ddi_file)
cps_data <- read_ipums_micro(cps_ddi_file, data_file = cps_data_file )
ipums_val_labels(cps_ddi, HHINCOME)


##convert to 2012 dollars (same as Health Inequality)
cps_data <- cps_data %>%
  mutate(HHINCOME_1999 = HHINCOME * CPI99, #Transform to 1999 dollars http://answers.popdata.org/Using-CPS-CPI99-adjust-inflation-q2377627.aspx
         HHINCOME_2012 = HHINCOME_1999 * 1.377) # transform 1999 to 2012 https://cps.ipums.org/cps/cpi99.shtml

cps_b <- cps_data %>%
  mutate(college = as.numeric(EDUC99>=15),
         evermarried = as.numeric(MARST<6),
         foreignborn = as.numeric(NATIVITY == 5),
         hispan = as.numeric(HISPAN >= 100 & HISPAN <= 500),
         labforce = ifelse(LABFORCE == 2, 1,
                           ifelse(LABFORCE == 1, 0, NA)), # code 0 NIU as NA
         movedintostate = as.numeric(MIGRATE1 == 5 | MIGRATE1 == 6),
         fulltime = ifelse(WKSTAT >= 10 & WKSTAT <= 15, 1,
                           ifelse(WKSTAT >= 20 & WKSTAT <= 42, 0, NA)), #code unemployed categories and NIU as NA
         black = as.numeric(RACE == 200),
         age40plus = as.numeric(AGE>=40),
         cps_unemploy = ifelse(EMPSTAT >= 20 & EMPSTAT <= 22, 1,
                               ifelse(EMPSTAT == 10 | EMPSTAT == 12, 0, NA)),
         workingage  = ifelse(AGE >= 25 & AGE <= 64, 1, 0),
         child_deps = ifelse(AGE < 25, 1, 0),
         old_deps = ifelse(AGE > 64, 1, 0))

cps_c <- cps_b %>%
  group_by(YEAR, STATEFIP) %>%
  summarise(college = weighted.mean(college, ASECWT, na.rm = TRUE),
            evermarried = weighted.mean(evermarried, ASECWT, na.rm = TRUE),
            foreignborn = weighted.mean(foreignborn, ASECWT, na.rm = TRUE),
            hispan = weighted.mean(hispan, ASECWT, na.rm = TRUE),
            labforce = weighted.mean(labforce, ASECWT, na.rm = TRUE),
            movedintostate = weighted.mean(movedintostate, ASECWT, na.rm = TRUE),
            fulltime = weighted.mean(fulltime, ASECWT, na.rm = TRUE),
            black = weighted.mean(black, ASECWT, na.rm = TRUE),
            age40plus = weighted.mean(age40plus, ASECWT, na.rm = TRUE),
            health = weighted.mean(HEALTH, ASECWT, na.rm = TRUE),
            cps_unemploy = weighted.mean(cps_unemploy, ASECWT, na.rm = TRUE),
            workingage = weighted.mean(workingage, ASECWT, na.rm = TRUE),
            child_deps = weighted.mean(child_deps, ASECWT, na.rm = TRUE),
            old_deps = weighted.mean(old_deps, ASECWT, na.rm = TRUE)) %>%
  arrange(YEAR, STATEFIP)

cps_d <- cps_c %>%
  rename(year = YEAR,
         state_fips = STATEFIP) %>%
  mutate_at(vars(-year, -state_fips, -health), function(x) x*100)

rm(cps_data)
rm(cps_b)

###############################################################################
###   SAVE RECODE FILE
###############################################################################
setwd("V:/seltzer/mortality/cps")

# library(foreign)

##Extract
write.dta(cps_d, "clean cps_d_11-25-2018.dta")
fwrite(cps_d, "clean cps_d_11-25-2018.csv")
