** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Inpatient and Emergency Dept Admissions
** 21_opioidsmanuf_state_inpatientemergency


clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Male.dta"
** Note: does not matter whether you use male or female dataset b/c of wide variables

xtset state_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_st_l > 0 & year > 1998"
global ifconap "if  Manufacturing_ap_pct_st_l > 0 & year > 1998"
global ifconyear "if year > 1999"



global cov i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l
global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


// FEMALE ----------------------------------------------------------------------


** INPATIENT
//EMP
	//reg
	 xtreg log_IP_rate_f $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ip_emp_f1
	 xtreg log_IP_rate_f $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ip_emp_f2

//AP
	//reg
	 xtreg log_IP_rate_f $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ip_ap_f1
	 xtreg log_IP_rate_f $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ip_ap_f2


** EMERGENCY
//EMP
	//reg
	 xtreg log_ED_rate_f $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ed_emp_f1
	 xtreg log_ED_rate_f $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ed_emp_f2

//AP
	//reg
	 xtreg log_ED_rate_f $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ed_ap_f1
	 xtreg log_ED_rate_f $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ed_ap_f2

	
esttab ip_emp_f* ip_ap_f* , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic
esttab ed_emp_f* ed_ap_f* , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab ip_emp_f* ip_ap_f* using "V:\seltzer\mortality\output\results\opioidsmanuf_inpatient_Women_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic
esttab ed_emp_f* ed_ap_f* using "V:\seltzer\mortality\output\results\opioidsmanuf_emergency_Women_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic


// MALE ------------------------------------------------------------------------


** INPATIENT
//EMP
	//reg
	 xtreg log_IP_rate_m $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ip_emp_m1
	 xtreg log_IP_rate_m $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ip_emp_m2

//AP
	//reg
	 xtreg log_IP_rate_m $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ip_ap_m1
	 xtreg log_IP_rate_m $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ip_ap_m2


** EMERGENCY
//EMP
	//reg
	 xtreg log_ED_rate_m $cov Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ed_emp_m1
	 xtreg log_ED_rate_m $cov $pol Manufacturing_emp_emp_pct_st_l , fe vce(cluster state_fips)
		eststo ed_emp_m2

//AP
	//reg
	 xtreg log_ED_rate_m $cov Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ed_ap_m1
	 xtreg log_ED_rate_m $cov $pol Manufacturing_ap_pct_st_l , fe vce(cluster state_fips)
		eststo ed_ap_m2

	
esttab ip_emp_m* ip_ap_m* , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic
esttab ed_emp_m* ed_ap_m* , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab ip_emp_m* ip_ap_m* using "V:\seltzer\mortality\output\results\opioidsmanuf_inpatient_Men_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic
esttab ed_emp_m* ed_ap_m* using "V:\seltzer\mortality\output\results\opioidsmanuf_emergency_Men_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l  Manufacturing_ap_pct_st_l) se(3) b(3) bic