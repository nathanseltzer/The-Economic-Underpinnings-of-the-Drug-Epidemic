## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Assembly of Imported and Cleaned Data
## File: 15_opioidsmanuf_assembledata.R
## Description: Creates final county and state datasets


Mort_full6_sex_county_comb
Mort_full6_sex_cz_comb
Mort_full6_sex_cbsa_comb
Mort_full6_sex_state_comb


dt_county_comb_sec_d 
dt_ctymsa_comb_sec_d 
dt_cz_comb_sec_d

dt_cbp_msa_comb_sec_d
dt_cbp_state_comb_both_2 <- mutate(dt_cbp_state_comb_both, 
                                   fipstate = NULL)

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

regions <- read.csv("V:/seltzer/data/state_region_crosswalk.csv")

msa <- fread("V:/seltzer/mortality/more/msa_type.csv")



## County

  county_data_1 <- left_join(Mort_full6_sex_county_comb, dt_county_comb_sec_d) %>%
                   left_join(dt_county_IMP_comb_sec_d) %>%
                   left_join(dt_lau3_cty) %>%
                   left_join(totpop_2_cty) %>%
                   left_join(genpop_3_cty_f) %>%
                   left_join(genpop_3_cty_m) %>%
                   # left_join(arcos_summary_cty) %>%
                   left_join(struc_2_cty) %>%
                   left_join(struc_det_2_cty) %>%
                   left_join(pop_race_sex_hisp3) %>%
                   left_join(ers_final) %>%
              ## MSA/CBSA-level
                   left_join(MSA_CTY_XWALK_2) %>%
                   left_join(dt_ctymsa_comb_sec_d) %>%
                   left_join(dt_ctymsa_IMP_comb_sec_d) %>%
                   left_join(dt_cbp_msa_comb_sec_d) %>%
                   left_join(dt_lau3_cbsa) %>%
                   left_join(Mort_full6_sex_cbsa_comb) %>%
                   left_join(totpop_2_msa) %>%
              ## CZ-level
                   left_join(c_cz_cross_2) %>%
                   left_join(dt_cz_comb_sec_d) %>%
                   left_join(dt_cz_IMP_comb_sec_d) %>%
                   left_join(dt_lau3_cz) %>%
                   left_join(Mort_full6_sex_cz_comb) %>%
                   left_join(totpop_2_cz) %>%
                   left_join(struc_2_cz) %>%
              ## State-level
                   left_join(dt_cbp_state_comb_both_2) %>%
                   left_join(dt_lau3_state) %>%
                   left_join(Mort_full6_sex_state_comb) %>%
                   left_join(totpop_2_st) %>%
                   # left_join(arcos_summary_st) %>%
                   left_join(ahrq_4) %>%
                   left_join(union) %>%
                   left_join(naloxone) %>%
                   left_join(goodsam) %>%
                   left_join(pdmp) %>%
                   left_join(staterx2) %>%
                   left_join(cps_d) %>%
                   left_join(genpop_3_st_f) %>%
                   left_join(genpop_3_st_m) %>%
                   # left_join(mort_full10_sexrace_state_comb) %>%
                   left_join(mort_full10_sexraceage_state_comb) %>%
                   left_join(regions) %>%
                   left_join(struc_2_st) %>%
                   left_join(rural_5) %>%
                   left_join(mort_full6_sex_county_opioid_pred) %>%
                   left_join(msa)
  
    
    

  ## MSA
  
  msa_data_1 <- left_join(Mort_full6_sex_cbsa_comb, dt_ctymsa_comb_sec_d) %>%
                left_join(dt_ctymsa_IMP_comb_sec_d) %>%
                left_join(dt_cbp_msa_comb_sec_d) %>%
                left_join(dt_lau3_cbsa) %>%
                left_join(totpop_2_msa) %>%
                left_join(msa)
    

  ## CZ
  cz_data_1 <-  left_join(Mort_full6_sex_cz_comb, dt_cz_comb_sec_d) %>%
                left_join(dt_cz_IMP_comb_sec_d) %>%
                left_join(dt_lau3_cz) %>%
                left_join(totpop_2_cz)
    
  
  
  
  ## State
  st_data_1 <-  left_join(Mort_full6_sex_state_comb, dt_cbp_state_comb_both_2) %>%
                left_join(dt_lau3_state) %>%
                left_join(totpop_2_st) %>%
                left_join(struc_det_2_st) %>%
                # left_join(arcos_summary_st) %>%
                left_join(ahrq_4) %>%
                left_join(union) %>%
                left_join(naloxone) %>%
                left_join(goodsam) %>%
                left_join(pdmp) %>%
                left_join(staterx2) %>%
                left_join(cps_d) %>%
                left_join(genpop_3_st_f) %>%
                left_join(genpop_3_st_m) %>%
                # left_join(mort_full10_sexrace_state_comb) %>%
                left_join(mort_full10_sexraceage_state_comb) %>%
                left_join(regions) %>%
                left_join(struc_2_st) %>%
                left_join(rural_5) %>%
                left_join(mort_full6_sex_state_opioid_pred) %>%
                left_join(dt_cbp_a9_SIC)
  
  
                


  write.dta(county_data_1, "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_mortlabor_v3.dta")
  write.dta(msa_data_1, "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-msa_mortlabor_v3.dta")
  write.dta(cz_data_1, "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-cz_mortlabor_v3.dta")
  write.dta(st_data_1, "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_mortlabor_v3.dta")
  


  

