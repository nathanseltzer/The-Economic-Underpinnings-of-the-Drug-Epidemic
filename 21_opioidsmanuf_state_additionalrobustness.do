** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Additional Robustness Checks
** 20_opioidsmanuf_state_additionalrobustness


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

********************************************************************************
** POPULATION WEIGHTS **********************************************************
********************************************************************************

global wt totpop_2_st_avg

// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_logw
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_logw	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_logw
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_logw

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logw
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logw	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logw
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logw

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprw
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprw	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprw
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprw


esttab m_emp*dr*logw m_ap_*dr*logw using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logw m_ap_*op*logw using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Men_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprw m_ap_*op*logprw using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Men_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** NO LABOR FORCE PARTICIPATION ************************************************
********************************************************************************

global covnolab i.year  college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l

// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_lognolab
	 xtreg log_asmr_sex_drug_st $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_lognolab	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_lognolab
	 xtreg log_asmr_sex_drug_st $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_lognolab

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_lognolab
	 xtreg log_asmr_sex_opioid_st $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_lognolab	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_lognolab
	 xtreg log_asmr_sex_opioid_st $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_lognolab

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprgnolab
	 xtreg log_asmr_sex_opioid_state_pred $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprgnolab	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprgnolab
	 xtreg log_asmr_sex_opioid_state_pred $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprgnolab


esttab m_emp*dr*lognolab m_ap_*dr*lognolab using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*lognolab m_ap_*op*lognolab using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Men_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprgnolab m_ap_*op*logprgnolab using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Men_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** ADDITIONAL COVARIATES *******************************************************
********************************************************************************



global cov_plus_foreign i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l foreignborn_l

global cov_but_det_agestruct i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_metro_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85

global cov_foreign_det_agestruct i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_metro_l foreignborn_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85


** AGE STRUCTURE DETAILED
xtreg log_asmr_sex_drug_st $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_dr

xtreg log_asmr_sex_drug_st $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_dr
	
xtreg log_asmr_sex_opioid_st $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_opraw

xtreg log_asmr_sex_opioid_st $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_opraw	

xtreg log_asmr_sex_opioid_state_pred $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_op

xtreg log_asmr_sex_opioid_state_pred $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_op

	
** FOREIGN
xtreg log_asmr_sex_drug_st $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_dr

xtreg log_asmr_sex_drug_st $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_dr
	
xtreg log_asmr_sex_opioid_st $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_opraw

xtreg log_asmr_sex_opioid_st $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_opraw	

xtreg log_asmr_sex_opioid_state_pred $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_op

xtreg log_asmr_sex_opioid_state_pred $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_op
	


	
esttab emp_struct_dr emp_struct_opraw emp_struct_op emp_foreign_dr emp_foreign_opraw emp_foreign_op using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_ADDITIONALCOVS_emp.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  ) se(3) b(3) bic

esttab ap_struct_dr ap_struct_opraw ap_struct_op ap_foreign_dr ap_foreign_opraw ap_foreign_op using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_ADDITIONALCOVS_ap.csv", replace compress nogaps mtitle keep(   Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** STATE BY YEAR TRENDS ********************************************************
********************************************************************************


// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_logtrend
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_logtrend	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_logtrend
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_logtrend

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logtrend
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logtrend	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logtrend
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logtrend

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprgtrend
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprgtrend	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprgtrend
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprgtrend


esttab m_emp*dr*logtrend m_ap_*dr*logtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Men_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logtrend m_ap_*op*logtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Men_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprgtrend m_ap_*op*logprgtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Men_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



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

********************************************************************************
** POPULATION WEIGHTS **********************************************************
********************************************************************************

global wt totpop_2_st_avg

// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_logw
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_logw	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_logw
	 xtreg log_asmr_sex_drug_st $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_logw

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logw
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logw	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logw
	 xtreg log_asmr_sex_opioid_st $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logw

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprw
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_emp_emp_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprw	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $cov Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprw
	 xtreg log_asmr_sex_opioid_state_pred $cov $pol Manufacturing_ap_pct_st_l [pw=$wt] , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprw


esttab m_emp*dr*logw m_ap_*dr*logw using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logw m_ap_*op*logw using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Women_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprw m_ap_*op*logprw using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Women_10-28-2020_FULLMODELS-WEIGHTS.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** NO LABOR FORCE PARTICIPATION ************************************************
********************************************************************************

global covnolab i.year  college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l

// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_lognolab
	 xtreg log_asmr_sex_drug_st $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_lognolab	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_lognolab
	 xtreg log_asmr_sex_drug_st $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_lognolab

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_lognolab
	 xtreg log_asmr_sex_opioid_st $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_lognolab	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_lognolab
	 xtreg log_asmr_sex_opioid_st $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_lognolab

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covnolab Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprgnolab
	 xtreg log_asmr_sex_opioid_state_pred $covnolab $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprgnolab	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred $covnolab Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprgnolab
	 xtreg log_asmr_sex_opioid_state_pred $covnolab $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprgnolab


esttab m_emp*dr*lognolab m_ap_*dr*lognolab using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*lognolab m_ap_*op*lognolab using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Women_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprgnolab m_ap_*op*logprgnolab using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Women_10-28-2020_FULLMODELS-nolaborforce.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** ADDITIONAL COVARIATES *******************************************************
********************************************************************************



global cov_plus_foreign i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l foreignborn_l

global cov_but_det_agestruct i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_metro_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85

global cov_foreign_det_agestruct i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_metro_l foreignborn_l pct_5 pct_10 pct_15 pct_20 pct_25 pct_30 pct_35 pct_40 pct_45  pct_50 pct_55 pct_60 pct_65 pct_70 pct_75 pct_80 pct_85


** AGE STRUCTURE DETAILED
xtreg log_asmr_sex_drug_st $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_dr

xtreg log_asmr_sex_drug_st $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_dr
	
xtreg log_asmr_sex_opioid_st $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_opraw

xtreg log_asmr_sex_opioid_st $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_opraw	

xtreg log_asmr_sex_opioid_state_pred $cov_but_det_agestruct $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_struct_op

xtreg log_asmr_sex_opioid_state_pred $cov_but_det_agestruct $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_struct_op

	
** FOREIGN
xtreg log_asmr_sex_drug_st $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_dr

xtreg log_asmr_sex_drug_st $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_dr
	
xtreg log_asmr_sex_opioid_st $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_opraw

xtreg log_asmr_sex_opioid_st $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_opraw	

xtreg log_asmr_sex_opioid_state_pred $cov_plus_foreign $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
	est sto emp_foreign_op

xtreg log_asmr_sex_opioid_state_pred $cov_plus_foreign $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
	est sto ap_foreign_op
	


	
esttab emp_struct_dr emp_struct_opraw emp_struct_op emp_foreign_dr emp_foreign_opraw emp_foreign_op using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_ADDITIONALCOVS_emp.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  ) se(3) b(3) bic

esttab ap_struct_dr ap_struct_opraw ap_struct_op ap_foreign_dr ap_foreign_opraw ap_foreign_op using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_ADDITIONALCOVS_ap.csv", replace compress nogaps mtitle keep(   Manufacturing_ap_pct_st_l) se(3) b(3) bic


********************************************************************************
** STATE BY YEAR TRENDS ********************************************************
********************************************************************************


// MAIN MODELS -----------------------------------------------------------------
** DRUG ***

//EMP
	//log
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m1_logtrend
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_dr_m2_logtrend	

		
//AP
	//log
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m1_logtrend
	 xtreg log_asmr_sex_drug_st c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_dr_m2_logtrend

	
** Opioid ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logtrend
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logtrend	
	
		
//AP
	//log
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logtrend
	 xtreg log_asmr_sex_opioid_st c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logtrend

** Opioid PREDICTED ***

//EMP
	//log
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m1_logprgtrend
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov $pol Manufacturing_emp_emp_pct_st_l  , fe vce(cluster state_fips)
		eststo m_emp_op_m2_logprgtrend	
	
//AP
	//log
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m1_logprgtrend
	 xtreg log_asmr_sex_opioid_state_pred c.year##i.state_fips  $cov $pol Manufacturing_ap_pct_st_l  , fe vce(cluster state_fips)
		eststo m_ap_op_m2_logprgtrend


esttab m_emp*dr*logtrend m_ap_*dr*logtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_Drug_log_Women_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logtrend m_ap_*op*logtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_Opioid_log_Women_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab m_emp*op*logprgtrend m_ap_*op*logprgtrend using "V:\seltzer\mortality\output\results\opioidsmanuf_OpioidPREDICTED_log_Women_10-28-2020_FULLMODELS-trend.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


