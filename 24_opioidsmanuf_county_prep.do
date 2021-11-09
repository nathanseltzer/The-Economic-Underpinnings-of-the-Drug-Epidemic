** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** County Dataset Final Prep
** 23_opioidsmanuf_county_prep

////////////////////////////////////////////////////////////////////////////////
// MALE DATASET ----------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

clear all

use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_mortlabor_v3.dta", clear

cd "V:\seltzer\mortality\output\results\cty"

keep if sex == 1

gen log_asmr_sex_drug_cty = log(asmr_sex_drug_cty + 1)
gen log_asmr_sex_opioid_cty = log(asmr_sex_opioid_cty + 1)
gen log_asmr_sex_opioid_county_pred = log(asmr_sex_opioid_county_pred + 1)



sort statecountyfips year

**Manuf Pct

//EMP
by statecountyfips: gen Manufacturing_emp_pct_cty_imp_l = Manufacturing_emp_mp_pct_cty_mp[_n-1]*100
by statecountyfips: gen Manufacturing_emp_pct_msa_imp_l = Manufacturng_mp_mp_pct_ctyms_mp[_n-1]*100
by statecountyfips: gen Manufacturing_emp_pct_cz_imp_l = Manufacturing_emp_emp_pct_cz_mp[_n-1]*100

by statecountyfips: gen Manufacturing_emp_emp_pct_cty_l = Manufacturing_emp_emp_pct_cty[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emppctctyms_l = Manufacturing_emp_emp_pct_ctyms[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_msa2_l = Manufacturing_emp_emp_pct_msa2[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_cz_l = Manufacturing_emp_emp_pct_cz[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct[_n-1]*100

//AP
by statecountyfips: gen Manufacturing_ap_pct_cty_l = Manufacturing_ap_pct_cty[_n-1]*100
by statecountyfips: gen Manufacturing_appctctyms_l = Manufacturing_ap_pct_ctyms[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_msa2_l = Manufacturing_ap_pct_msa2[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_cz_l = Manufacturing_ap_pct_cz[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_st_l = Manufacturing_ap_pct[_n-1]*100

//EMP IMPUTED
by statecountyfips: gen Manuf_emp_pct_cty_imp_l = Manufacturing_emp_mp_pct_cty_mp[_n-1]*100


**Manuf Log Number
//EMP
by statecountyfips: gen Manufacturing_emp_cty_imp_l_log = log(Manufacturing_emp_cty_imp[_n-1])

by statecountyfips: gen Manufacturing_emp_cty_l_log = log(Manufacturing_emp_cty[_n-1])
by statecountyfips: gen Manufacturing_emp_ctymsa_l_log = log(Manufacturing_emp_ctymsa[_n-1])
by statecountyfips: gen Manufacturing_emp_msa2_l_log = log(Manufacturing_emp_msa2[_n-1])
by statecountyfips: gen Manufacturing_emp_cz_l_log = log(Manufacturing_emp_cz[_n-1])
by statecountyfips: gen Manufacturing_emp_st_l_log = log(Manufacturing_emp[_n-1])

//AP
by statecountyfips: gen Manufacturing_ap_cty_l_log = log(Manufacturing_ap_cty[_n-1])
by statecountyfips: gen Manufacturing_ap_ctymsa_l_log = log(Manufacturing_ap_ctymsa[_n-1])
by statecountyfips: gen Manufacturing_ap_msa2_l_log = log(Manufacturing_ap_msa2[_n-1])
by statecountyfips: gen Manufacturing_ap_cz_l_log = log(Manufacturing_ap_cz[_n-1])
by statecountyfips: gen Manufacturing_ap_st_l_log = log(Manufacturing_ap[_n-1])



**Covariates
//Unemployment
by statecountyfips: gen Unemployed_Rate_cty_l = Unemployed_Rate_cty[_n-1]*100
by statecountyfips: gen Unemployed_Rate_msa_l = Unemployed_Rate_msa[_n-1]*100
by statecountyfips: gen Unemployed_Rate_cz_l = Unemployed_Rate_cz[_n-1]*100
by statecountyfips: gen Unemployed_Rate_st_l = Unemployed_Rate_st[_n-1]*100
//Pop Log
by statecountyfips: gen totpop_cty_log = log(totpop_cty)
by statecountyfips: gen totpop_msa_log = log(totpop_msa)
by statecountyfips: gen totpop_cz_log = log(totpop_cz)
by statecountyfips: gen totpop_st_log = log(totpop_st)

** state

sort statecountyfips year

**Covariates
//Pop Log

by statecountyfips: gen genpop_m_st_log = log(genpop_st_m)
by statecountyfips: gen genpop_f_st_log = log(genpop_st_f)


by statecountyfips: gen college_l = college[_n-1]
by statecountyfips: gen evermarried_l = evermarried[_n-1]
by statecountyfips: gen foreignborn_l = foreignborn[_n-1]
by statecountyfips: gen hispan_l = hispan[_n-1]
by statecountyfips: gen black_l = black[_n-1]
by statecountyfips: gen health_l = health[_n-1]
by statecountyfips: gen workingage_l = workingage[_n-1]
by statecountyfips: gen pct_cov_l = pct_cov[_n-1]
by statecountyfips: gen labforce_l = labforce[_n-1]
by statecountyfips: gen pct_metro_l = pct_metro[_n-1]*100
by statecountyfips: gen pct_lt15_st_l = pct_lt15_st[_n-1]
by statecountyfips: gen pct_1564_st_l = pct_1564_st[_n-1]
by statecountyfips: gen pct_gt65_st_l = pct_gt65_st[_n-1]

by statecountyfips: gen pct_lt15_cty_l = pct_lt15_cty[_n-1]
by statecountyfips: gen pct_1564_cty_l = pct_1564_cty[_n-1]
by statecountyfips: gen pct_gt65_cty_l = pct_gt65_cty[_n-1]


by statecountyfips: gen Labor_Force_cty_l = Labor_Force_cty[_n-1]
by statecountyfips: gen Labor_Force_cz_l = Labor_Force_cz[_n-1]




*by statecountyfips: gen pills_rate_st_l = pills_rate_st[_n-1]
by statecountyfips: gen rx_rate_st_l = rx_rates[_n-1]


gen pop_15above_cty = ((pct_1564_cty + pct_gt65_cty)/100) * totpop_cty
gen pop_15above_cz = ((pct_1564_cz + pct_gt65_cz)/100) * totpop_cz

gen lfp_cty = Labor_Force_cty/pop_15above_cty
gen lfp_cz = Labor_Force_cz/pop_15above_cz


by statecountyfips: gen lfp_cty_l = 100*lfp_cty[_n-1]
by statecountyfips: gen lfp_cz_l = 100*lfp_cz[_n-1]





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


gen metro = (msa_type == "Metro")

gen pct_hsorless_lag = pct_intrp_lths_lag + pct_intrp_hs_lag
gen pct_scorless_lag = pct_intrp_sc_lag + pct_intrp_ba_lag


gen totpop_2_cty_1999_prep = totpop_2_cty if year == 1999

sort county_fips year
by county_fips: egen totpop_2_cty_1999 = max(totpop_2_cty_1999_prep )
by county_fips : egen max_emppct_cty = max(Manufacturing_emp_emp_pct_cty_l )

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


save "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Male.dta", replace


////////////////////////////////////////////////////////////////////////////////
// FEMALE DATASET --------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

clear all

use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_mortlabor_v1.dta", clear

cd "V:\seltzer\mortality\output\results\cty"

keep if sex == 2

gen log_asmr_sex_drug_cty = log(asmr_sex_drug_cty + 1)
gen log_asmr_sex_opioid_cty = log(asmr_sex_opioid_cty + 1)
gen log_asmr_sex_opioid_county_pred = log(asmr_sex_opioid_county_pred + 1)



sort statecountyfips year

**Manuf Pct

//EMP
by statecountyfips: gen Manufacturing_emp_pct_cty_imp_l = Manufacturing_emp_mp_pct_cty_mp[_n-1]*100
by statecountyfips: gen Manufacturing_emp_pct_msa_imp_l = Manufacturng_mp_mp_pct_ctyms_mp[_n-1]*100
by statecountyfips: gen Manufacturing_emp_pct_cz_imp_l = Manufacturing_emp_emp_pct_cz_mp[_n-1]*100

by statecountyfips: gen Manufacturing_emp_emp_pct_cty_l = Manufacturing_emp_emp_pct_cty[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emppctctyms_l = Manufacturing_emp_emp_pct_ctyms[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_msa2_l = Manufacturing_emp_emp_pct_msa2[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_cz_l = Manufacturing_emp_emp_pct_cz[_n-1]*100
by statecountyfips: gen Manufacturing_emp_emp_pct_st_l = Manufacturing_emp_emp_pct[_n-1]*100

//AP
by statecountyfips: gen Manufacturing_ap_pct_cty_l = Manufacturing_ap_pct_cty[_n-1]*100
by statecountyfips: gen Manufacturing_appctctyms_l = Manufacturing_ap_pct_ctyms[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_msa2_l = Manufacturing_ap_pct_msa2[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_cz_l = Manufacturing_ap_pct_cz[_n-1]*100
by statecountyfips: gen Manufacturing_ap_pct_st_l = Manufacturing_ap_pct[_n-1]*100

//EMP IMPUTED
by statecountyfips: gen Manuf_emp_pct_cty_imp_l = Manufacturing_emp_mp_pct_cty_mp[_n-1]*100


**Manuf Log Number
//EMP
by statecountyfips: gen Manufacturing_emp_cty_imp_l_log = log(Manufacturing_emp_cty_imp[_n-1])

by statecountyfips: gen Manufacturing_emp_cty_l_log = log(Manufacturing_emp_cty[_n-1])
by statecountyfips: gen Manufacturing_emp_ctymsa_l_log = log(Manufacturing_emp_ctymsa[_n-1])
by statecountyfips: gen Manufacturing_emp_msa2_l_log = log(Manufacturing_emp_msa2[_n-1])
by statecountyfips: gen Manufacturing_emp_cz_l_log = log(Manufacturing_emp_cz[_n-1])
by statecountyfips: gen Manufacturing_emp_st_l_log = log(Manufacturing_emp[_n-1])

//AP
by statecountyfips: gen Manufacturing_ap_cty_l_log = log(Manufacturing_ap_cty[_n-1])
by statecountyfips: gen Manufacturing_ap_ctymsa_l_log = log(Manufacturing_ap_ctymsa[_n-1])
by statecountyfips: gen Manufacturing_ap_msa2_l_log = log(Manufacturing_ap_msa2[_n-1])
by statecountyfips: gen Manufacturing_ap_cz_l_log = log(Manufacturing_ap_cz[_n-1])
by statecountyfips: gen Manufacturing_ap_st_l_log = log(Manufacturing_ap[_n-1])



**Covariates
//Unemployment
by statecountyfips: gen Unemployed_Rate_cty_l = Unemployed_Rate_cty[_n-1]*100
by statecountyfips: gen Unemployed_Rate_msa_l = Unemployed_Rate_msa[_n-1]*100
by statecountyfips: gen Unemployed_Rate_cz_l = Unemployed_Rate_cz[_n-1]*100
by statecountyfips: gen Unemployed_Rate_st_l = Unemployed_Rate_st[_n-1]*100
//Pop Log
by statecountyfips: gen totpop_cty_log = log(totpop_cty)
by statecountyfips: gen totpop_msa_log = log(totpop_msa)
by statecountyfips: gen totpop_cz_log = log(totpop_cz)
by statecountyfips: gen totpop_st_log = log(totpop_st)

** state

sort statecountyfips year

**Covariates
//Pop Log

by statecountyfips: gen genpop_m_st_log = log(genpop_st_m)
by statecountyfips: gen genpop_f_st_log = log(genpop_st_f)


by statecountyfips: gen college_l = college[_n-1]
by statecountyfips: gen evermarried_l = evermarried[_n-1]
by statecountyfips: gen foreignborn_l = foreignborn[_n-1]
by statecountyfips: gen hispan_l = hispan[_n-1]
by statecountyfips: gen black_l = black[_n-1]
by statecountyfips: gen health_l = health[_n-1]
by statecountyfips: gen workingage_l = workingage[_n-1]
by statecountyfips: gen pct_cov_l = pct_cov[_n-1]
by statecountyfips: gen labforce_l = labforce[_n-1]
by statecountyfips: gen pct_metro_l = pct_metro[_n-1]*100
by statecountyfips: gen pct_lt15_st_l = pct_lt15_st[_n-1]
by statecountyfips: gen pct_1564_st_l = pct_1564_st[_n-1]
by statecountyfips: gen pct_gt65_st_l = pct_gt65_st[_n-1]

by statecountyfips: gen pct_lt15_cty_l = pct_lt15_cty[_n-1]
by statecountyfips: gen pct_1564_cty_l = pct_1564_cty[_n-1]
by statecountyfips: gen pct_gt65_cty_l = pct_gt65_cty[_n-1]


by statecountyfips: gen Labor_Force_cty_l = Labor_Force_cty[_n-1]
by statecountyfips: gen Labor_Force_cz_l = Labor_Force_cz[_n-1]




*by statecountyfips: gen pills_rate_st_l = pills_rate_st[_n-1]
by statecountyfips: gen rx_rate_st_l = rx_rates[_n-1]


gen pop_15above_cty = ((pct_1564_cty + pct_gt65_cty)/100) * totpop_cty
gen pop_15above_cz = ((pct_1564_cz + pct_gt65_cz)/100) * totpop_cz

gen lfp_cty = Labor_Force_cty/pop_15above_cty
gen lfp_cz = Labor_Force_cz/pop_15above_cz


by statecountyfips: gen lfp_cty_l = 100*lfp_cty[_n-1]
by statecountyfips: gen lfp_cz_l = 100*lfp_cz[_n-1]





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


gen metro = (msa_type == "Metro")

gen pct_hsorless_lag = pct_intrp_lths_lag + pct_intrp_hs_lag
gen pct_scorless_lag = pct_intrp_sc_lag + pct_intrp_ba_lag


gen totpop_2_cty_1999_prep = totpop_2_cty if year == 1999

sort county_fips year
by county_fips: egen totpop_2_cty_1999 = max(totpop_2_cty_1999_prep )
by county_fips : egen max_emppct_cty = max(Manufacturing_emp_emp_pct_cty_l )

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


save "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-county_CLEAN_Female.dta", replace
