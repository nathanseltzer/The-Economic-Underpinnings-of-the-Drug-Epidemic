** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Main Models
** 17_opioidsmanuf_state_mainmodels


////////////////////////////////////////////////////////////////////////////////
// MALE  -----------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Male.dta"


xtset state_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_st_l > 0 & year > 1998"
global ifconap "if  Manufacturing_ap_pct_st_l > 0 & year > 1998"
global ifconyear "if year > 1999"



global cov i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l
global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


*xtnbreg d_NHWM_4554_drug_state  $cov Manufacturing_emp_emp_pct_st_l $ifconemp , fe  irr exposure(totpop_2_st_avg)


// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_log
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_log	
	//counts
	 xtnbreg deaths_sex_drug_state $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_dr_m1_nb
	 xtnbreg deaths_sex_drug_state $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_dr_m2_nb		
		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_log
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_log
	//counts
	 xtnbreg deaths_sex_drug_state $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_dr_m1_nb
	 xtnbreg deaths_sex_drug_state $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_dr_m2_nb		
	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_op_m1_log
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_op_m2_log	
	//counts
	 xtnbreg deaths_sex_opioid_state $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_op_m1_nb
	 xtnbreg deaths_sex_opioid_state $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_op_m2_nb		
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_op_m1_log
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_op_m2_log
	//counts
	 xtnbreg deaths_sex_opioid_state $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_op_m1_nb
	 xtnbreg deaths_sex_opioid_state $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_op_m2_nb		
	
** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logpr	
	//counts
	 xtnbreg deaths_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_op_m1_nbpr
	 xtnbreg deaths_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_emp_op_m2_nbpr		
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logpr
	//counts
	 xtnbreg deaths_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_op_m1_nbpr
	 xtnbreg deaths_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo m_ap_op_m2_nbpr		
		
	
esttab m_emp*dr*log m_ap_*dr*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*dr*nb m_ap*dr*nb , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*log m_ap_*op*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*nb m_ap*op*nb , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


esttab m_emp*dr*log m_ap_*dr*log using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*dr*nb m_ap*dr*nb using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_count_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*log m_ap_*op*log using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*nb m_ap*op*nb using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_count_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logpr m_ap_*op*logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*nbpr m_ap*op*nbpr using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_count_Men_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


** FULL OUTPUT **
esttab m_emp_dr_m*_log m_ap_dr_m*_log m_emp_op_m*_log m_ap_op_m*_log m_emp_op_m*_logpr m_ap_op_m*_logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_DrugandOpioid_log_Men_10-28-2020_FULLMODELS-FULLOUTPUT.csv", replace compress nogaps mtitle se(3) b(3) bic r2



////////////////////////////////////////////////////////////////////////////////
// FEMALE  ---------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Female.dta"


xtset state_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_st_l > 0 & year > 1998"
global ifconap "if  Manufacturing_ap_pct_st_l > 0 & year > 1998"
global ifconyear "if year > 1999"



global cov i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l
global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


*xtnbreg d_NHWM_4554_drug_state  $cov Manufacturing_emp_emp_pct_st_l $ifconemp , fe  irr exposure(totpop_2_st_avg)


// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_dr_m1_log
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_dr_m2_log	
	//counts
	 xtnbreg deaths_sex_drug_state $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_dr_m1_nb
	 xtnbreg deaths_sex_drug_state $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_dr_m2_nb		
		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_dr_m1_log
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_dr_m2_log
	//counts
	 xtnbreg deaths_sex_drug_state $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_dr_m1_nb
	 xtnbreg deaths_sex_drug_state $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_dr_m2_nb		
	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_op_m1_log
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_op_m2_log	
	//counts
	 xtnbreg deaths_sex_opioid_state $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_op_m1_nb
	 xtnbreg deaths_sex_opioid_state $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_op_m2_nb		
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_op_m1_log
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_op_m2_log
	//counts
	 xtnbreg deaths_sex_opioid_state $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_op_m1_nb
	 xtnbreg deaths_sex_opioid_state $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_op_m2_nb		
	
** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo f_emp_op_m2_logpr	
	//counts
	 xtnbreg deaths_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_op_m1_nbpr
	 xtnbreg deaths_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_emp_op_m2_nbpr		
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_op_m1_logpr
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo f_ap_op_m2_logpr
	//counts
	 xtnbreg deaths_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_op_m1_nbpr
	 xtnbreg deaths_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo f_ap_op_m2_nbpr		
		
	
esttab f_emp*dr*log f_ap_*dr*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*dr*nb f_ap*dr*nb , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*log f_ap_*op*log , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*nb f_ap*op*nb , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


esttab f_emp*dr*log f_ap_*dr*log using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*dr*nb f_ap*dr*nb using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_count_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*log f_ap_*op*log using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*nb f_ap*op*nb using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_count_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*logpr f_ap_*op*logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab f_emp*op*nbpr f_ap*op*nbpr using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_count_Women_10-28-2020_FULLMODELS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


** FULL OUTPUT **
esttab f_emp_dr_m*_log f_ap_dr_m*_log f_emp_op_m*_log f_ap_op_m*_log f_emp_op_m*_logpr f_ap_op_m*_logpr using "V:\seltzer\mortality\output\results\opioidsmanuf_DrugandOpioid_log_Women_10-28-2020_FULLMODELS-FULLOUTPUT.csv", replace compress nogaps mtitle se(3) b(3) bic r2