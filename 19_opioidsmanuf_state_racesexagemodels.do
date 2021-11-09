** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Race Sex Age Drug Models
** 18_opioidsmanuf_state_racesexagemodels

clear all
use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Male.dta"
** Note: does not matter whether you use male or female dataset b/c of wide variables


// AGE SEX RACE ----------------------------------------------------------------

mvencode d_NHWM_2534_drug_state d_NHWM_3544_drug_state d_NHWM_4554_drug_state d_NHWM_5564_drug_state d_NHWF_2534_drug_state d_NHWF_3544_drug_state d_NHWF_4554_drug_state d_NHWF_5564_drug_state d_NHBM_2534_drug_state d_NHBM_3544_drug_state d_NHBM_4554_drug_state d_NHBM_5564_drug_state d_NHBF_2534_drug_state d_NHBF_3544_drug_state d_NHBF_4554_drug_state d_NHBF_5564_drug_state, mv(. = 0)

//CR ---------------------------------------------------------------------------

mvdecode NHBM_2534_dr NHBM_3544_dr NHBM_4554_dr NHBM_5564_dr NHBF_2534_dr NHBF_3544_dr NHBF_4554_dr NHBF_5564_dr NHBM_2534_op NHBM_3544_op NHBM_4554_op NHBM_5564_op NHBF_2534_op NHBF_3544_op NHBF_4554_op NHBF_5564_op , mv(0 = .)

** Drug- XTNBREG
foreach var of varlist d_NHWM_2534_drug_state d_NHWM_3544_drug_state d_NHWM_4554_drug_state d_NHWM_5564_drug_state  d_NHBM_2534_drug_state d_NHBM_3544_drug_state d_NHBM_4554_drug_state d_NHBM_5564_drug_state  {
	
	replace `var' = 0 if `var' == .

	//EMP
	 xtnbreg  `var' $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo d1`var'nbE
	 xtnbreg  `var' $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo d2`var'nbE
		
		
	//AP
	 xtnbreg  `var' $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo d1`var'nbA
	 xtnbreg  `var' $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_m)
		eststo d2`var'nbA	
		
}




foreach var of varlist d_NHWF_2534_drug_state d_NHWF_3544_drug_state d_NHWF_4554_drug_state d_NHWF_5564_drug_state  d_NHBF_2534_drug_state d_NHBF_3544_drug_state d_NHBF_4554_drug_state d_NHBF_5564_drug_state {
	
	replace `var' = 0 if `var' == .

	//EMP
	 xtnbreg  `var' $cov Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_f)
		eststo d1`var'nbE
	 xtnbreg  `var' $cov $pol Manufacturing_emp_emp_pct_st_l , fe  irr exposure(genpop_st_f)
		eststo d2`var'nbE
		
		
	//AP
	 xtnbreg  `var' $cov Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_f)
		eststo d1`var'nbA
	 xtnbreg  `var' $cov $pol Manufacturing_ap_pct_st_l , fe  irr exposure(genpop_st_f)
		eststo d2`var'nbA	
		
}


esttab *NHWM*nbE  , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l ) se(3) b(3) bic
esttab *NHWF*nbE  , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l ) se(3) b(3) bic
esttab *NHBM*nbE  , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l ) se(3) b(3) bic
esttab *NHBF*nbE  , compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l ) se(3) b(3) bic


esttab *NHWM*nbA  , compress nogaps mtitle keep( Manufacturing_ap_pct_st_l ) se(3) b(3) bic
esttab *NHWF*nbA  , compress nogaps mtitle keep( Manufacturing_ap_pct_st_l ) se(3) b(3) bic
esttab *NHBM*nbA  , compress nogaps mtitle keep( Manufacturing_ap_pct_st_l ) se(3) b(3) bic
esttab *NHBF*nbA  , compress nogaps mtitle keep( Manufacturing_ap_pct_st_l ) se(3) b(3) bic


esttab *NHWM*nbE *NHWM*nbA using "V:\seltzer\mortality\output\results\opioidsmanuf_count_CR_NHWM_drug_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab *NHWF*nbE *NHWF*nbA using "V:\seltzer\mortality\output\results\opioidsmanuf_count_CR_NHWF_drug_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab *NHBM*nbE *NHBM*nbA using "V:\seltzer\mortality\output\results\opioidsmanuf_count_CR_NHBM_drug_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l Manufacturing_ap_pct_st_l) se(3) b(3) bic

esttab *NHBF*nbE *NHBF*nbA using "V:\seltzer\mortality\output\results\opioidsmanuf_count_CR_NHBF_drug_10-28-2020.csv", replace compress nogaps mtitle keep( Manufacturing_emp_emp_pct_st_l Manufacturing_ap_pct_st_l) se(3) b(3) bic