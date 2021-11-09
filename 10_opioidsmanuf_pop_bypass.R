## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: NCHS Pop Bypass 
## File: 10_opioidsmanuf_pop_bypass.R
## Description: Imports all data cleaned and created from file 09


OTHER_CLEAN <- "V:/seltzer/mortality/data/clean/other"


totpop_2_cty <- fread(paste0(OTHER_CLEAN, "/totpop_2_cty_CLEAN.csv"))
totpop_2_msa <- fread(paste0(OTHER_CLEAN, "/totpop_2_msa_CLEAN.csv"))
totpop_2_cz <- fread(paste0(OTHER_CLEAN, "/totpop_2_cz_CLEAN.csv"))
totpop_2_st <- fread(paste0(OTHER_CLEAN, "/totpop_2_st_CLEAN.csv"))


genpop_3_cty_f <- fread(paste0(OTHER_CLEAN, "/genpop_3_cty_f.csv"))
genpop_3_cty_m <- fread(paste0(OTHER_CLEAN, "/genpop_3_cty_m.csv"))
genpop_3_st_f <- fread(paste0(OTHER_CLEAN, "/genpop_3_st_f.csv"))
genpop_3_st_m <- fread(paste0(OTHER_CLEAN, "/genpop_3_st_m.csv"))


rural_5 <- fread(paste0(OTHER_CLEAN, "/rural_5_st_CLEAN.csv"))


struc_2_st <- fread(paste0(OTHER_CLEAN, "/struc_2_st_CLEAN.csv"))
struc_2_cz <- fread(paste0(OTHER_CLEAN, "/struc_2_cz_CLEAN.csv"))
struc_2_cty <- fread(paste0(OTHER_CLEAN, "/struc_2_cty_CLEAN.csv"))
struc_det_2_st <- fread(paste0(OTHER_CLEAN, "/struc_det_2_st.csv"))
struc_det_2_cty <- fread(paste0(OTHER_CLEAN, "/struc_det_2_cty.csv"))


pop_race_sex_hisp3 <-  fread(paste0(OTHER_CLEAN, "/pop_race_sex_hisp3.csv"))



