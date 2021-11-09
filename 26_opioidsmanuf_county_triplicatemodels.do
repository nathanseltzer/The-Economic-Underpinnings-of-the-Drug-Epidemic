** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** County Triplicate Models
** 25_opioidsmanuf_county_triplicatemodels



////////////////////////////////////////////////////////////////////////////////
// MALE  -----------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Male.dta"



gen triplicate = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 18 | state_fips == 26 | state_fips == 36 | state_fips == 48)

gen triplicate_restricted = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 36 | state_fips == 48)


gen triplicate_3 = triplicate
replace triplicate_3 = 2 if state_fips == 18 | state_fips == 26

tab state_fips triplicate_3

tab state_fips triplicate_restricted



** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_dr_m2_log	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_dr_m2_log
	
	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_op_m2_log	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_op_m2_log
	
	
** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_county_pred i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_oppred_m2_log	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_county_pred i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_oppred_m2_log
	
		
esttab trip_m_emp_dr_m2_log trip_m_ap_dr_m2_log trip_m_emp_op_m2_log trip_m_ap_op_m2_log trip_m_emp_oppred_m2_log trip_m_ap_oppred_m2_log using "V:\seltzer\mortality\output\results\opioidsmanuf_triplicate_5states_MALE_OLS_10-28-2020.csv", replace compress  nogaps mtitle keep( Manufacturing_emp_emp_pct_cz_l  1.triplicate_restricted#c.Manufacturing_emp_emp_pct_cz_l   Manufacturing_ap_pct_cz_l  1.triplicate_restricted#c.Manufacturing_ap_pct_cz_l ) se(4) b(4) bic



////////////////////////////////////////////////////////////////////////////////
// FEMALE  -----------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Female.dta"



gen triplicate = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 18 | state_fips == 26 | state_fips == 36 | state_fips == 48)

gen triplicate_restricted = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 36 | state_fips == 48)


gen triplicate_3 = triplicate
replace triplicate_3 = 2 if state_fips == 18 | state_fips == 26

tab state_fips triplicate_3

tab state_fips triplicate_restricted



** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_dr_m2_log	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_dr_m2_log
	
	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_op_m2_log	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_cty i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_op_m2_log
	
	
** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_county_pred i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_emp_emp_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_emp_oppred_m2_log	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_county_pred i.triplicate_restricted##(i.year c.lfp_cty_l    c.hispanic_pct_cty c.nhblack_pct_cty  c.college_l c.foreignborn_l c.evermarried_l c.health_l c.pct_metro_l c.pct_5 c.pct_10 c.pct_15 c.pct_20 c.pct_25 c.pct_30 c.pct_35 c.pct_40 c.pct_45  c.pct_50 c.pct_55 c.pct_60 c.pct_65 c.pct_70 c.pct_75 c.pct_80 c.pct_85 c.pct_cov_l i.goodsam_imp_lag i.nal_imp_lag i.pdmp_law_lag   c.Manufacturing_ap_pct_cz_l)   [pw = totpop_2_cty_1999] , fe vce(cluster state_fips)
		eststo trip_m_ap_oppred_m2_log
	
		
esttab trip_m_emp_dr_m2_log trip_m_ap_dr_m2_log trip_m_emp_op_m2_log trip_m_ap_op_m2_log trip_m_emp_oppred_m2_log trip_m_ap_oppred_m2_log using "V:\seltzer\mortality\output\results\opioidsmanuf_triplicate_5states_FEMALE_OLS_10-28-2020.csv", replace compress  nogaps mtitle keep( Manufacturing_emp_emp_pct_cz_l  1.triplicate_restricted#c.Manufacturing_emp_emp_pct_cz_l   Manufacturing_ap_pct_cz_l  1.triplicate_restricted#c.Manufacturing_ap_pct_cz_l ) se(4) b(4) bic