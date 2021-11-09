## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: CBP Data Import and Prep Bypass
## File: 07_opioidsmanuf_cbp_bypass.R
## Description: Loads in CBP data to bypass raw import and recodes


CBP_CLEAN <- "V:/seltzer/mortality/data/clean/cbp"


dt_county_comb_sec_d <- fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_county_CLEAN.csv"))
dt_ctymsa_comb_sec_d <-  fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_msa_CLEAN.csv"))
dt_cz_comb_sec_d <- fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_cz_CLEAN.csv"))
dt_cbp_msa_comb_sec_d <- fread(paste0(CBP_CLEAN, "/CBP_msadata_manuf_msa_CLEAN.csv"))
dt_cbp_state_comb_both <- fread(paste0(CBP_CLEAN, "/CBP_statedata_manuf_state_CLEAN.csv"))


dt_county_IMP_comb_sec_d <- fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_county_imputed_CLEAN.csv"))
dt_ctymsa_IMP_comb_sec_d <- fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_msa_imputed_CLEAN.csv"))
dt_cz_IMP_comb_sec_d <-  fread(paste0(CBP_CLEAN, "/CBP_countydata_manuf_cz_imputed_CLEAN.csv"))


dt_cbp_state_comb_both_2 <- mutate(dt_cbp_state_comb_both, 
                                   fipstate = NULL)

dt_cbp_a9_SIC <- fread(paste0(CBP_CLEAN, "/dt_cbp_a9_SICpre1998_CLEAN.csv"))
