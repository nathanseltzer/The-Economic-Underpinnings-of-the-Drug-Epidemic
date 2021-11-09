** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Dataset Final Prep
** 16_opioidsmanuf_state_prep

////////////////////////////////////////////////////////////////////////////////
// MALE DATASET ----------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

clear all


use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_mortlabor_v3.dta", clear

cd "V:\seltzer\mortality\output\graphs"

keep if sex == 1

gen log_asmr_sex_drug_st = log(asmr_sex_drug_state)
gen log_asmr_sex_opioid_st = log(asmr_sex_opioid_state)
gen log_asmr_sex_opioid_state_pred = log(asmr_sex_opioid_state_pred)

gen logp1_asmr_sex_drug_st = log(asmr_sex_drug_state)
replace logp1_asmr_sex_drug_st = 0 if asmr_sex_drug_state == 0
gen logp1_asmr_sex_opioid_st = log(asmr_sex_opioid_state)
replace logp1_asmr_sex_opioid_st = 0 if asmr_sex_opioid_state == 0


gen log_IP_rate_m = log(IP_rate_m)
gen log_IP_rate_f = log(IP_rate_f)
gen log_ED_rate_m = log(ED_rate_m)
gen log_ED_rate_f = log(ED_rate_f)

gen triplicate = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 18 | state_fips == 26 | state_fips == 36 | state_fips == 48)



sort state_fips year

**Manuf Pct
//EMP
by state_fips: gen Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct[_n-1]*100
by state_fips: gen Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct[_n-2]*100
by state_fips: gen Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct[_n-3]*100

**ADD ADDITIONAL lags
replace Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct_1997  if year == 1998
replace Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct_1997  if year == 1999
replace Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct_1996  if year == 1998
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1997  if year == 2000
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1996  if year == 1999
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1995  if year == 1998

//AP
by state_fips: gen Manufacturing_ap_pct_st_l = Manufacturing_ap_pct[_n-1]*100
by state_fips: gen Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct[_n-2]*100
by state_fips: gen Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct[_n-3]*100

**ADD ADDITIONAL lags
replace Manufacturing_ap_pct_st_l = Manufacturing_ap_pct_1997  if year == 1998
replace Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct_1997  if year == 1999
replace Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct_1996  if year == 1998
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1997  if year == 2000
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1996  if year == 1999
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1995  if year == 1998

**Manuf Log Number
//EMP
by state_fips: gen Manufacturing_emp_st_l_log = log(Manufacturing_emp[_n-1])
//AP
by state_fips: gen Manufacturing_ap_st_l_log = log(Manufacturing_ap[_n-1])



**Covariates
//Unemployment
by state_fips: gen Unemployed_Rate_st_l = Unemployed_Rate_st[_n-1]*100
//Pop Log
by state_fips: gen totpop_st_log = log(totpop_st)
by state_fips: gen totpop_st_log_l = totpop_st_log[_n-1]

by state_fips: gen genpop_m_st_log = log(genpop_st_m)
by state_fips: gen genpop_f_st_log = log(genpop_st_f)


by state_fips: gen college_l = college[_n-1]
by state_fips: gen evermarried_l = evermarried[_n-1]
by state_fips: gen foreignborn_l = foreignborn[_n-1]
by state_fips: gen hispan_l = hispan[_n-1]
by state_fips: gen black_l = black[_n-1]
by state_fips: gen health_l = health[_n-1]
by state_fips: gen workingage_l = workingage[_n-1]
by state_fips: gen pct_cov_l = pct_cov[_n-1]
by state_fips: gen labforce_l = labforce[_n-1]
by state_fips: gen pct_metro_l = pct_metro[_n-1]*100
by state_fips: gen pct_lt15_st_l = pct_lt15_st[_n-1]
by state_fips: gen pct_1564_st_l = pct_1564_st[_n-1]
by state_fips: gen pct_gt65_st_l = pct_gt65_st[_n-1]





*by state_fips: gen pills_rate_st_l = pills_rate_st[_n-1]
by state_fips: gen rx_rate_st_l = rx_rates[_n-1]



	gen nal_imp = 0
	replace nal_imp = 1 if year >= naloxone_imp_yr

	gen nal_imp_lag = 0
	replace nal_imp_lag = 1 if year > naloxone_imp_yr

	gen goodsam_imp = 0
	replace goodsam_imp = 1 if year >= goodsam_imp_yr
	replace goodsam_imp = 0 if goodsam_law == 0

	gen goodsam_imp_lag = 0
	replace goodsam_imp_lag = 1 if year > goodsam_imp_yr
	replace goodsam_imp_lag = 0 if goodsam_law == 0
	
	gen pdmp_law_lag = 0
	replace pdmp_law_lag = 1 if year > pdmp_imp	
	

//CREATE LOGGED CRUDE RATES
foreach var of varlist  cr_NHWM_2534_drug_state cr_NHWM_3544_drug_state cr_NHWM_4554_drug_state cr_NHWM_5564_drug_state cr_NHWF_2534_drug_state cr_NHWF_3544_drug_state cr_NHWF_4554_drug_state cr_NHWF_5564_drug_state cr_NHBM_2534_drug_state cr_NHBM_3544_drug_state cr_NHBM_4554_drug_state cr_NHBM_5564_drug_state cr_NHBF_2534_drug_state cr_NHBF_3544_drug_state cr_NHBF_4554_drug_state cr_NHBF_5564_drug_state cr_NHWM_2534_opioid_state cr_NHWM_3544_opioid_state cr_NHWM_4554_opioid_state cr_NHWM_5564_opioid_state cr_NHWF_2534_opioid_state cr_NHWF_3544_opioid_state cr_NHWF_4554_opioid_state cr_NHWF_5564_opioid_state cr_NHBM_2534_opioid_state cr_NHBM_3544_opioid_state cr_NHBM_4554_opioid_state cr_NHBM_5564_opioid_state cr_NHBF_2534_opioid_state cr_NHBF_3544_opioid_state cr_NHBF_4554_opioid_state cr_NHBF_5564_opioid_state  {

replace `var' = 0 if `var' == .

gen log_`var' = log(`var')
gen logp1_`var' = log(`var')
replace logp1_`var' = 0 if `var' == 0


}

** ABBREVIATE

//DRUG
foreach v of var cr_NHWM_2534_drug_state cr_NHWM_3544_drug_state cr_NHWM_4554_drug_state cr_NHWM_5564_drug_state cr_NHWF_2534_drug_state cr_NHWF_3544_drug_state cr_NHWF_4554_drug_state cr_NHWF_5564_drug_state cr_NHBM_2534_drug_state cr_NHBM_3544_drug_state cr_NHBM_4554_drug_state cr_NHBM_5564_drug_state cr_NHBF_2534_drug_state cr_NHBF_3544_drug_state cr_NHBF_4554_drug_state cr_NHBF_5564_drug_state {
	local new = substr("`v'", 4, 12)
	rename `v' `new'
}

//OPIOID
foreach v of var cr_NHWM_2534_opioid_state cr_NHWM_3544_opioid_state cr_NHWM_4554_opioid_state cr_NHWM_5564_opioid_state cr_NHWF_2534_opioid_state cr_NHWF_3544_opioid_state cr_NHWF_4554_opioid_state cr_NHWF_5564_opioid_state cr_NHBM_2534_opioid_state cr_NHBM_3544_opioid_state cr_NHBM_4554_opioid_state cr_NHBM_5564_opioid_state cr_NHBF_2534_opioid_state cr_NHBF_3544_opioid_state cr_NHBF_4554_opioid_state cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 4, 12)
	rename `v' `new'
}


//LOG CR DRUG
*log
foreach v of var log_cr_NHWM_2534_drug_state log_cr_NHWM_3544_drug_state log_cr_NHWM_4554_drug_state log_cr_NHWM_5564_drug_state log_cr_NHWF_2534_drug_state log_cr_NHWF_3544_drug_state log_cr_NHWF_4554_drug_state log_cr_NHWF_5564_drug_state log_cr_NHBM_2534_drug_state log_cr_NHBM_3544_drug_state log_cr_NHBM_4554_drug_state log_cr_NHBM_5564_drug_state log_cr_NHBF_2534_drug_state log_cr_NHBF_3544_drug_state log_cr_NHBF_4554_drug_state log_cr_NHBF_5564_drug_state {
	local new = substr("`v'", 8, 12)
	rename `v' l_`new'
}
*log plus 1
foreach v of var logp1_cr_NHWM_2534_drug_state logp1_cr_NHWM_3544_drug_state logp1_cr_NHWM_4554_drug_state logp1_cr_NHWM_5564_drug_state logp1_cr_NHWF_2534_drug_state logp1_cr_NHWF_3544_drug_state logp1_cr_NHWF_4554_drug_state logp1_cr_NHWF_5564_drug_state logp1_cr_NHBM_2534_drug_state logp1_cr_NHBM_3544_drug_state logp1_cr_NHBM_4554_drug_state logp1_cr_NHBM_5564_drug_state logp1_cr_NHBF_2534_drug_state logp1_cr_NHBF_3544_drug_state logp1_cr_NHBF_4554_drug_state logp1_cr_NHBF_5564_drug_state {
	local new = substr("`v'", 10, 12)
	rename `v' l1_`new'
}
	

//LOG CR OPIOID
*log
foreach v of var log_cr_NHWM_2534_opioid_state log_cr_NHWM_3544_opioid_state log_cr_NHWM_4554_opioid_state log_cr_NHWM_5564_opioid_state log_cr_NHWF_2534_opioid_state log_cr_NHWF_3544_opioid_state log_cr_NHWF_4554_opioid_state log_cr_NHWF_5564_opioid_state log_cr_NHBM_2534_opioid_state log_cr_NHBM_3544_opioid_state log_cr_NHBM_4554_opioid_state log_cr_NHBM_5564_opioid_state log_cr_NHBF_2534_opioid_state log_cr_NHBF_3544_opioid_state log_cr_NHBF_4554_opioid_state log_cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 8, 12)
	rename `v' l_`new'
}

*log plus 1
foreach v of var logp1_cr_NHWM_2534_opioid_state logp1_cr_NHWM_3544_opioid_state logp1_cr_NHWM_4554_opioid_state logp1_cr_NHWM_5564_opioid_state logp1_cr_NHWF_2534_opioid_state logp1_cr_NHWF_3544_opioid_state logp1_cr_NHWF_4554_opioid_state logp1_cr_NHWF_5564_opioid_state logp1_cr_NHBM_2534_opioid_state logp1_cr_NHBM_3544_opioid_state logp1_cr_NHBM_4554_opioid_state logp1_cr_NHBM_5564_opioid_state logp1_cr_NHBF_2534_opioid_state logp1_cr_NHBF_3544_opioid_state logp1_cr_NHBF_4554_opioid_state logp1_cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 10, 12)
	rename `v' l1_`new'
}
	


xtset state_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_st_l > 0 & year > 1998"
global ifconap "if  Manufacturing_ap_pct_st_l > 0 & year > 1998"
global ifconyear "if year > 1999"



global cov i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l
global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


save "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Male.dta", replace


////////////////////////////////////////////////////////////////////////////////
// FEMALE DATASET --------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

clear all


use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_mortlabor_v2.dta", clear

cd "V:\seltzer\mortality\output\graphs"

keep if sex == 2

gen log_asmr_sex_drug_st = log(asmr_sex_drug_state)
gen log_asmr_sex_opioid_st = log(asmr_sex_opioid_state)
gen log_asmr_sex_opioid_state_pred = log(asmr_sex_opioid_state_pred)

gen logp1_asmr_sex_drug_st = log(asmr_sex_drug_state)
replace logp1_asmr_sex_drug_st = 0 if asmr_sex_drug_state == 0
gen logp1_asmr_sex_opioid_st = log(asmr_sex_opioid_state)
replace logp1_asmr_sex_opioid_st = 0 if asmr_sex_opioid_state == 0


gen log_IP_rate_m = log(IP_rate_m)
gen log_IP_rate_f = log(IP_rate_f)
gen log_ED_rate_m = log(ED_rate_m)
gen log_ED_rate_f = log(ED_rate_f)

gen triplicate = (state_fips == 6 | state_fips == 16 | state_fips == 17 | state_fips == 18 | state_fips == 26 | state_fips == 36 | state_fips == 48)



sort state_fips year

**Manuf Pct
//EMP
by state_fips: gen Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct[_n-1]*100
by state_fips: gen Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct[_n-2]*100
by state_fips: gen Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct[_n-3]*100

**ADD ADDITIONAL lags
replace Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct_1997  if year == 1998
replace Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct_1997  if year == 1999
replace Manufacturing_emp_emp_pct_st_l2 = Manufacturing_emp_emp_pct_1996  if year == 1998
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1997  if year == 2000
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1996  if year == 1999
replace Manufacturing_emp_emp_pct_st_l3 = Manufacturing_emp_emp_pct_1995  if year == 1998

//AP
by state_fips: gen Manufacturing_ap_pct_st_l = Manufacturing_ap_pct[_n-1]*100
by state_fips: gen Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct[_n-2]*100
by state_fips: gen Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct[_n-3]*100

**ADD ADDITIONAL lags
replace Manufacturing_ap_pct_st_l = Manufacturing_ap_pct_1997  if year == 1998
replace Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct_1997  if year == 1999
replace Manufacturing_ap_pct_st_l2 = Manufacturing_ap_pct_1996  if year == 1998
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1997  if year == 2000
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1996  if year == 1999
replace Manufacturing_ap_pct_st_l3 = Manufacturing_ap_pct_1995  if year == 1998

**Manuf Log Number
//EMP
by state_fips: gen Manufacturing_emp_st_l_log = log(Manufacturing_emp[_n-1])
//AP
by state_fips: gen Manufacturing_ap_st_l_log = log(Manufacturing_ap[_n-1])



**Covariates
//Unemployment
by state_fips: gen Unemployed_Rate_st_l = Unemployed_Rate_st[_n-1]*100
//Pop Log
by state_fips: gen totpop_st_log = log(totpop_st)
by state_fips: gen totpop_st_log_l = totpop_st_log[_n-1]

by state_fips: gen genpop_m_st_log = log(genpop_st_m)
by state_fips: gen genpop_f_st_log = log(genpop_st_f)


by state_fips: gen college_l = college[_n-1]
by state_fips: gen evermarried_l = evermarried[_n-1]
by state_fips: gen foreignborn_l = foreignborn[_n-1]
by state_fips: gen hispan_l = hispan[_n-1]
by state_fips: gen black_l = black[_n-1]
by state_fips: gen health_l = health[_n-1]
by state_fips: gen workingage_l = workingage[_n-1]
by state_fips: gen pct_cov_l = pct_cov[_n-1]
by state_fips: gen labforce_l = labforce[_n-1]
by state_fips: gen pct_metro_l = pct_metro[_n-1]*100
by state_fips: gen pct_lt15_st_l = pct_lt15_st[_n-1]
by state_fips: gen pct_1564_st_l = pct_1564_st[_n-1]
by state_fips: gen pct_gt65_st_l = pct_gt65_st[_n-1]





*by state_fips: gen pills_rate_st_l = pills_rate_st[_n-1]
by state_fips: gen rx_rate_st_l = rx_rates[_n-1]



	gen nal_imp = 0
	replace nal_imp = 1 if year >= naloxone_imp_yr

	gen nal_imp_lag = 0
	replace nal_imp_lag = 1 if year > naloxone_imp_yr

	gen goodsam_imp = 0
	replace goodsam_imp = 1 if year >= goodsam_imp_yr
	replace goodsam_imp = 0 if goodsam_law == 0

	gen goodsam_imp_lag = 0
	replace goodsam_imp_lag = 1 if year > goodsam_imp_yr
	replace goodsam_imp_lag = 0 if goodsam_law == 0
	
	gen pdmp_law_lag = 0
	replace pdmp_law_lag = 1 if year > pdmp_imp	
	

//CREATE LOGGED CRUDE RATES
foreach var of varlist  cr_NHWM_2534_drug_state cr_NHWM_3544_drug_state cr_NHWM_4554_drug_state cr_NHWM_5564_drug_state cr_NHWF_2534_drug_state cr_NHWF_3544_drug_state cr_NHWF_4554_drug_state cr_NHWF_5564_drug_state cr_NHBM_2534_drug_state cr_NHBM_3544_drug_state cr_NHBM_4554_drug_state cr_NHBM_5564_drug_state cr_NHBF_2534_drug_state cr_NHBF_3544_drug_state cr_NHBF_4554_drug_state cr_NHBF_5564_drug_state cr_NHWM_2534_opioid_state cr_NHWM_3544_opioid_state cr_NHWM_4554_opioid_state cr_NHWM_5564_opioid_state cr_NHWF_2534_opioid_state cr_NHWF_3544_opioid_state cr_NHWF_4554_opioid_state cr_NHWF_5564_opioid_state cr_NHBM_2534_opioid_state cr_NHBM_3544_opioid_state cr_NHBM_4554_opioid_state cr_NHBM_5564_opioid_state cr_NHBF_2534_opioid_state cr_NHBF_3544_opioid_state cr_NHBF_4554_opioid_state cr_NHBF_5564_opioid_state  {

replace `var' = 0 if `var' == .

gen log_`var' = log(`var')
gen logp1_`var' = log(`var')
replace logp1_`var' = 0 if `var' == 0


}

** ABBREVIATE

//DRUG
foreach v of var cr_NHWM_2534_drug_state cr_NHWM_3544_drug_state cr_NHWM_4554_drug_state cr_NHWM_5564_drug_state cr_NHWF_2534_drug_state cr_NHWF_3544_drug_state cr_NHWF_4554_drug_state cr_NHWF_5564_drug_state cr_NHBM_2534_drug_state cr_NHBM_3544_drug_state cr_NHBM_4554_drug_state cr_NHBM_5564_drug_state cr_NHBF_2534_drug_state cr_NHBF_3544_drug_state cr_NHBF_4554_drug_state cr_NHBF_5564_drug_state {
	local new = substr("`v'", 4, 12)
	rename `v' `new'
}

//OPIOID
foreach v of var cr_NHWM_2534_opioid_state cr_NHWM_3544_opioid_state cr_NHWM_4554_opioid_state cr_NHWM_5564_opioid_state cr_NHWF_2534_opioid_state cr_NHWF_3544_opioid_state cr_NHWF_4554_opioid_state cr_NHWF_5564_opioid_state cr_NHBM_2534_opioid_state cr_NHBM_3544_opioid_state cr_NHBM_4554_opioid_state cr_NHBM_5564_opioid_state cr_NHBF_2534_opioid_state cr_NHBF_3544_opioid_state cr_NHBF_4554_opioid_state cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 4, 12)
	rename `v' `new'
}


//LOG CR DRUG
*log
foreach v of var log_cr_NHWM_2534_drug_state log_cr_NHWM_3544_drug_state log_cr_NHWM_4554_drug_state log_cr_NHWM_5564_drug_state log_cr_NHWF_2534_drug_state log_cr_NHWF_3544_drug_state log_cr_NHWF_4554_drug_state log_cr_NHWF_5564_drug_state log_cr_NHBM_2534_drug_state log_cr_NHBM_3544_drug_state log_cr_NHBM_4554_drug_state log_cr_NHBM_5564_drug_state log_cr_NHBF_2534_drug_state log_cr_NHBF_3544_drug_state log_cr_NHBF_4554_drug_state log_cr_NHBF_5564_drug_state {
	local new = substr("`v'", 8, 12)
	rename `v' l_`new'
}
*log plus 1
foreach v of var logp1_cr_NHWM_2534_drug_state logp1_cr_NHWM_3544_drug_state logp1_cr_NHWM_4554_drug_state logp1_cr_NHWM_5564_drug_state logp1_cr_NHWF_2534_drug_state logp1_cr_NHWF_3544_drug_state logp1_cr_NHWF_4554_drug_state logp1_cr_NHWF_5564_drug_state logp1_cr_NHBM_2534_drug_state logp1_cr_NHBM_3544_drug_state logp1_cr_NHBM_4554_drug_state logp1_cr_NHBM_5564_drug_state logp1_cr_NHBF_2534_drug_state logp1_cr_NHBF_3544_drug_state logp1_cr_NHBF_4554_drug_state logp1_cr_NHBF_5564_drug_state {
	local new = substr("`v'", 10, 12)
	rename `v' l1_`new'
}
	

//LOG CR OPIOID
*log
foreach v of var log_cr_NHWM_2534_opioid_state log_cr_NHWM_3544_opioid_state log_cr_NHWM_4554_opioid_state log_cr_NHWM_5564_opioid_state log_cr_NHWF_2534_opioid_state log_cr_NHWF_3544_opioid_state log_cr_NHWF_4554_opioid_state log_cr_NHWF_5564_opioid_state log_cr_NHBM_2534_opioid_state log_cr_NHBM_3544_opioid_state log_cr_NHBM_4554_opioid_state log_cr_NHBM_5564_opioid_state log_cr_NHBF_2534_opioid_state log_cr_NHBF_3544_opioid_state log_cr_NHBF_4554_opioid_state log_cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 8, 12)
	rename `v' l_`new'
}

*log plus 1
foreach v of var logp1_cr_NHWM_2534_opioid_state logp1_cr_NHWM_3544_opioid_state logp1_cr_NHWM_4554_opioid_state logp1_cr_NHWM_5564_opioid_state logp1_cr_NHWF_2534_opioid_state logp1_cr_NHWF_3544_opioid_state logp1_cr_NHWF_4554_opioid_state logp1_cr_NHWF_5564_opioid_state logp1_cr_NHBM_2534_opioid_state logp1_cr_NHBM_3544_opioid_state logp1_cr_NHBM_4554_opioid_state logp1_cr_NHBM_5564_opioid_state logp1_cr_NHBF_2534_opioid_state logp1_cr_NHBF_3544_opioid_state logp1_cr_NHBF_4554_opioid_state logp1_cr_NHBF_5564_opioid_state {
	local new = substr("`v'", 10, 12)
	rename `v' l1_`new'
}
	


xtset state_fips year


global ifconemp "if  Manufacturing_emp_emp_pct_st_l > 0 & year > 1998"
global ifconap "if  Manufacturing_ap_pct_st_l > 0 & year > 1998"
global ifconyear "if year > 1999"



global cov i.year labforce_l college_l evermarried_l hispan_l black_l health_l pct_1564_st_l pct_gt65_st_l pct_metro_l
global pol  pct_cov_l goodsam_imp_lag nal_imp_lag pdmp_law_lag 


save "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_CLEAN_Female.dta", replace
