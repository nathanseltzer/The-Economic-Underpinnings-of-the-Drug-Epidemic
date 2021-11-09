** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Rx Rate Robustness Models
** 19_opioidsmanuf_state_rx_robustnessmodels

////////////////////////////////////////////////////////////////////////////////
// MALE  -----------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Male.dta"

// RX RATE ROBUSTNESS MODELS ---------------------------------------------------

global covrx i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l rx_rate_st_l

global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


** DRUG ***
//EMP
	//log
	 xtreg log_asmr_sex_drug_st $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_dr_m1_log
	 xtreg log_asmr_sex_drug_st $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_dr_m2_log	

//AP
	//log
	 xtreg log_asmr_sex_drug_st $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_dr_m1_log
	 xtreg log_asmr_sex_drug_st $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_dr_m2_log

	
** Opioid ***
//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m1_log
	 xtreg log_asmr_sex_opioid_st $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m2_log
		

//AP
	//log
	 xtreg log_asmr_sex_opioid_st $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m1_log
	 xtreg log_asmr_sex_opioid_st $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m2_log	
	
	
** Opioid PREDICTED ***
//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m2_logpr
			

//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m2_logpr	
		
	
	
esttab rx*_emp*dr*log rx*_ap_*dr*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab rx*_emp*op*log rx*_ap_*op*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


esttab rx*_emp*dr*log rx*_ap_*dr*log using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_Drug_log_Men_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab rx*_emp*op*log rx*_ap_*op*log using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_Opioid_log_Men_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


esttab rx*_emp*op*logpr rx*_ap_*op*logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_OpioidPREDICTED_log_Men_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic



////////////////////////////////////////////////////////////////////////////////
// FEMALE  ---------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Female.dta"

// RX RATE ROBUSTNESS MODELS ---------------------------------------------------

global covrx i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l rx_rate_st_l

global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


** DRUG ***
//EMP
	//log
	 xtreg log_asmr_sex_drug_st $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_dr_m1_log
	 xtreg log_asmr_sex_drug_st $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_dr_m2_log	

//AP
	//log
	 xtreg log_asmr_sex_drug_st $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_dr_m1_log
	 xtreg log_asmr_sex_drug_st $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_dr_m2_log

	
** Opioid ***
//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m1_log
	 xtreg log_asmr_sex_opioid_st $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m2_log
		

//AP
	//log
	 xtreg log_asmr_sex_opioid_st $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m1_log
	 xtreg log_asmr_sex_opioid_st $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m2_log	
		
	
** Opioid PREDICTED ***
//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covrx Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $covrx $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo rx_emp_op_m2_logpr
			

//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covrx Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $covrx $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo rx_ap_op_m2_logpr	
		
	
	
esttab rx*_emp*dr*log rx*_ap_*dr*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab rx*_emp*op*log rx*_ap_*op*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


esttab rx*_emp*dr*log rx*_ap_*dr*log using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_Drug_log_Women_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab rx*_emp*op*log rx*_ap_*op*log using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_Opioid_log_Women_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab rx*_emp*op*logpr rx*_ap_*op*logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_rx_OpioidPREDICTED_log_Women_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic
