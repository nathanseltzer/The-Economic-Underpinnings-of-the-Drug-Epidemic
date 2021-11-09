** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** County Main Models
** 24_opioidsmanuf_county_mainmodels


////////////////////////////////////////////////////////////////////////////////
// MALE  -----------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Male.dta"


xtset county_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_cty_l > 0"
global ifconempmsa "if Manufacturing_emp_emp_pct_msa2_l > 0"
global ifconap "if  Manufacturing_ap_pct_cty_l > 0"
global ifconapmsa "if Manufacturing_ap_pct_msa2_l > 0"
global ifconyear "if year > 1999"


global weight "[pw=totpop_2_cty_avg]"

global cov i.year Unemployed_Rate_cty_l 


global covst i.year labforce_l college_l evermarried_l hispan_l black_l health_l 
global polst  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag pct_metro_l



global covcty i.year Unemployed_Rate_cty_l college_l evermarried_l hispan_l black_l health_l 


************** FINAL MODELS


global covcty i.year lfp_cty_l    hispanic_pct_cty nhblack_pct_cty 

global covst college_l foreignborn_l evermarried_l health_l pct_metro_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85
global polst  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// 1. DRUG


// COUNTY --------------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_cty_imp_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_emp_imp

// METRO ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emppctctyms_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_appctctyms_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_msa_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_emp_imp	 
	 
// COMMUTING ZONE ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_cz_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_cz_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_cz_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_emp_imp
	 
// STATE ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_st_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_st_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_st_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_st_ap	 


esttab dr_cty_emp dr_cty_emp_imp dr_msa_emp dr_msa_emp_imp dr_cz_emp dr_cz_emp_imp dr_st_emp using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_DRUG_emp_MEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_cty_l Manufacturing_emp_pct_cty_imp_l Manufacturing_emp_emppctctyms_l Manufacturing_emp_pct_msa_imp_l Manufacturing_emp_emp_pct_cz_l Manufacturing_emp_pct_cz_imp_l Manufacturing_emp_emp_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
esttab dr_cty_ap dr_msa_ap dr_cz_ap dr_st_ap using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_DRUG_ap_MEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_ap_pct_cty_l Manufacturing_appctctyms_l Manufacturing_ap_pct_cz_l Manufacturing_ap_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
	 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// 2. OPIOID (CORRECTED)


// COUNTY --------------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_cty_imp_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_emp_imp

// METRO ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emppctctyms_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_appctctyms_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_msa_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_emp_imp	 
	 
// COMMUTING ZONE ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_cz_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_cz_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_cz_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_emp_imp
	 
// STATE ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_st_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_st_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_st_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_st_ap	 


esttab op_cty_emp op_cty_emp_imp op_msa_emp op_msa_emp_imp op_cz_emp op_cz_emp_imp op_st_emp using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_OPIOID_emp_MEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_cty_l Manufacturing_emp_pct_cty_imp_l Manufacturing_emp_emppctctyms_l Manufacturing_emp_pct_msa_imp_l Manufacturing_emp_emp_pct_cz_l Manufacturing_emp_pct_cz_imp_l Manufacturing_emp_emp_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
esttab op_cty_ap op_msa_ap op_cz_ap op_st_ap using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_OPIOID_ap_MEN_10-28-2020.csv.csv", replace compress nogaps mtitle keep( Manufacturing_ap_pct_cty_l Manufacturing_appctctyms_l Manufacturing_ap_pct_cz_l Manufacturing_ap_pct_st_l) se(4) b(4) bic sca(N_g)
	 	 
		 
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
		 
		 
		 
////////////////////////////////////////////////////////////////////////////////
// FEMALE  ---------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Female.dta"


xtset county_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_cty_l > 0"
global ifconempmsa "if Manufacturing_emp_emp_pct_msa2_l > 0"
global ifconap "if  Manufacturing_ap_pct_cty_l > 0"
global ifconapmsa "if Manufacturing_ap_pct_msa2_l > 0"
global ifconyear "if year > 1999"


global weight "[pw=totpop_2_cty_avg]"

global cov i.year Unemployed_Rate_cty_l 


global covst i.year labforce_l college_l evermarried_l hispan_l black_l health_l 
global polst  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag pct_metro_l



global covcty i.year Unemployed_Rate_cty_l college_l evermarried_l hispan_l black_l health_l 


************** FINAL MODELS


global covcty i.year lfp_cty_l    hispanic_pct_cty nhblack_pct_cty 

global covst college_l foreignborn_l evermarried_l health_l pct_metro_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85
global polst  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// 1. DRUG


// COUNTY --------------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_cty_imp_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cty_emp_imp

// METRO ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emppctctyms_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_appctctyms_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_msa_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_msa_emp_imp	 
	 
// COMMUTING ZONE ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_cz_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_cz_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_ap	 

** DRUG CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_pct_cz_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_cz_emp_imp
	 
// STATE ------------------------------------
** DRUG CZ MANUF
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_emp_emp_pct_st_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_st_emp
	 
	 xtreg log_asmr_sex_drug_cty $covcty $covst $polst  Manufacturing_ap_pct_st_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto dr_st_ap	 


esttab dr_cty_emp dr_cty_emp_imp dr_msa_emp dr_msa_emp_imp dr_cz_emp dr_cz_emp_imp dr_st_emp using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_DRUG_emp_WOMEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_cty_l Manufacturing_emp_pct_cty_imp_l Manufacturing_emp_emppctctyms_l Manufacturing_emp_pct_msa_imp_l Manufacturing_emp_emp_pct_cz_l Manufacturing_emp_pct_cz_imp_l Manufacturing_emp_emp_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
esttab dr_cty_ap dr_msa_ap dr_cz_ap dr_st_ap using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_DRUG_ap_WOMEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_ap_pct_cty_l Manufacturing_appctctyms_l Manufacturing_ap_pct_cz_l Manufacturing_ap_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
	 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// 2. OPIOID (CORRECTED)


// COUNTY --------------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_cty_l if  max_emppct_cty  > 0  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_cty_imp_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cty_emp_imp

// METRO ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emppctctyms_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_appctctyms_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_msa_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_msa_emp_imp	 
	 
// COMMUTING ZONE ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_cz_l  [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_cz_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_ap	 

** OPIOID CZ MANUF IMPUTATION (emp only)
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_pct_cz_imp_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_cz_emp_imp
	 
// STATE ------------------------------------
** OPIOID CZ MANUF
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_emp_emp_pct_st_l   [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_st_emp
	 
	 xtreg log_asmr_sex_opioid_county_pred $covcty $covst $polst  Manufacturing_ap_pct_st_l [pw = totpop_2_cty_1999] , fe  vce(cluster state_fips)
	 est sto op_st_ap	 


esttab op_cty_emp op_cty_emp_imp op_msa_emp op_msa_emp_imp op_cz_emp op_cz_emp_imp op_st_emp using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_OPIOID_emp_WOMEN_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_cty_l Manufacturing_emp_pct_cty_imp_l Manufacturing_emp_emppctctyms_l Manufacturing_emp_pct_msa_imp_l Manufacturing_emp_emp_pct_cz_l Manufacturing_emp_pct_cz_imp_l Manufacturing_emp_emp_pct_st_l) se(4) b(4) bic sca(N_g)
	 
	 
esttab op_cty_ap op_msa_ap op_cz_ap op_st_ap using "V:\seltzer\mortality\output\results\opioidsmanuf_levelcomparison_OPIOID_ap_WOMEN_10-28-2020.csv.csv", replace compress nogaps mtitle keep( Manufacturing_ap_pct_cty_l Manufacturing_appctctyms_l Manufacturing_ap_pct_cz_l Manufacturing_ap_pct_st_l) se(4) b(4) bic sca(N_g)		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
di (1-exp(-0.0158))*100	// women - imputed - coef cz
di (1-exp(-0.0204))*100 // men - imputed - coef cz

tab year  [aw = totpop_2_cty_1999] , summarize (Manufacturing_emp_pct_cz_imp_l)
 di  15.747541  -  9.9416817 // get change in manufacturing employment
di 5.8058593


** WOMEN	 
tab year [aw = totpop_2_cty_1999], summarize(log_asmr_sex_drug_cty)
di 2.530262 - 1.3747121  // W get total increase in drug deaths
summ log_asmr_sex_drug_cty if year > 1998 [aw = totpop_2_cty_1999], det
di 	  2.020194 * .015675835 // W multiply avg of drug deaths by exp(coeff)
di .03166823 * 5.8058593 // W multiply 1 percentage point change by total decline in manuf employment
di 	 .18386129/1.1555499 // W divide deaths explained by manuf by overall change in deaths
di .15911151

** WOMEN	 -- on the response
tab year [aw = totpop_2_cty_1999], summarize(asmr_sex_drug_cty)
di   14.936329  - 3.9566791    // W get total increase in drug deaths
summ asmr_sex_drug_cty if year > 1998 [aw = totpop_2_cty_1999], det
di 	  8.922198 * .015675835 // W multiply avg of drug deaths by exp(coeff)
di .1398629 * 5.8058593 // W multiply 1 percentage point change by total decline in manuf employment
di 	 .81202432/10.97965 // W divide deaths explained by manuf by overall change in deaths
di .07395721	

**state	  - W
di 	   8.922198 * -.031880743 // M multiply avg of drug deaths by exp(coeff)
di -.2844463 * 6.4090661 // M multiply 1 percentage point change by total decline in manuf employment
di 	 -1.8230351/10.97965 // M divide deaths explained by manuf by overall change in deaths
di -.16603763	


** MEN	 
tab year [aw = totpop_2_cty_1999], summarize(log_asmr_sex_drug_cty)
di  3.1987701  - 1.9077696   // M get total increase in drug deaths
summ log_asmr_sex_drug_cty if year > 1998 [aw = totpop_2_cty_1999], det
di 	  2.532204 * .020193328 // M multiply avg of drug deaths by exp(coeff)
di .05113363 * 5.8058593 // M multiply 1 percentage point change by total decline in manuf employment
di 	 .29687466/1.2910005 // M divide deaths explained by manuf by overall change in deaths
di .22995704	 


** MEN	 - on the response
tab year [aw = totpop_2_cty_1999], summarize(asmr_sex_drug_cty)
di  30.567872   -  8.2022968   // M get total increase in drug deaths
summ asmr_sex_drug_cty if year > 1998 [aw = totpop_2_cty_1999], det
di 	   15.73111 * .020193328 // M multiply avg of drug deaths by exp(coeff)
di .31766346 * 5.8058593 // M multiply 1 percentage point change by total decline in manuf employment
di 	 1.8443094/22.365575 // M divide deaths explained by manuf by overall change in deaths
di .08246197			 
	 
**state	 
di 	   15.73111 * -.046770895 // M multiply avg of drug deaths by exp(coeff)
di -.73575809 * 6.4090661 // M multiply 1 percentage point change by total decline in manuf employment
di 	 -4.7155222/22.365575 // M divide deaths explained by manuf by overall change in deaths
di -.21083841		
	 
**cz nonlogged mort rate	 
di  -.2481905 * 5.8058593 // M multiply 1 percentage point change by total decline in manuf employment
di 	 -1.4409591/22.365575 // M divide deaths explained by manuf by overall change in deaths
di -.06442755	 


** MEN	 - on the response AP
tab year [aw = totpop_2_cty_1999], summarize(asmr_sex_drug_cty)
di  30.567872   -  8.2022968   // M get total increase in drug deaths
summ asmr_sex_drug_cty if year > 1998 [aw = totpop_2_cty_1999], det
di 	   15.73111 * .0124222 // M multiply avg of drug deaths by exp(coeff)
di .19541499 * 7.900244 // M multiply 1 percentage point change by total decline in manuf employment
di 	 1.5438261/22.365575 // M divide deaths explained by manuf by overall change in deaths
di .08246197	


sort county_fips year
gen Manuf_cz_imp_l_1999prep = Manufacturing_emp_pct_cz_imp_l if year == 1999
by county_fips : egen Manuf_cz_imp_l_1999 = max(Manuf_cz_imp_l_1999prep)
xtile quart = Manuf_cz_imp_l_1999  [pw=totpop_2_cty_1999] , nq(4)


tab year if quart == 1 [aw=totpop_2_cty_1999], summarize(asmr_sex_drug_cty  )
tab year if quart == 1 [aw=totpop_2_cty_1999], summarize(Manufacturing_emp_pct_cz_imp_l )

di .31766346 * 3.0221662
di .96003177/19.39056
*Q1 .04951027

tab year if quart == 4 [aw=totpop_2_cty_1999], summarize(asmr_sex_drug_cty  )
tab year if quart == 4 [aw=totpop_2_cty_1999], summarize(Manufacturing_emp_pct_cz_imp_l )

di .31766346 * 8.839985
di 2.8081402/25.828431
*Q4 .10872283