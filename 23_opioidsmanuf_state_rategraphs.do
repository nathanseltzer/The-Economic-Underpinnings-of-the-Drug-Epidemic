** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** State Rate and Logged Rate Graphs
** 22_opioidsmanuf_state_rategraphs


clear all


use "V:/seltzer/mortality/data/clean/final/restricted-KEEPONWINSTAT-state_mortlabor_v2.dta", clear

cd "V:\seltzer\mortality\output\graphs"


gen log_asmr_sex_drug_st = log(asmr_sex_drug_state)
gen log_asmr_sex_opioid_st = log(asmr_sex_opioid_state)
gen log_asmr_sex_opioid_state_pred = log(asmr_sex_opioid_state_pred)

********
set scheme s1mono
twoway  kdensity asmr_sex_drug_state if sex == 2, color(green) || ///
		kdensity asmr_sex_drug_state if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Drug Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Drug_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Drug_dist_10-28-2020.png", replace	

twoway  kdensity asmr_sex_opioid_state if sex == 2, color(green) || ///
		kdensity asmr_sex_opioid_state if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Opioid Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Opioid_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Opioid_dist_10-28-2020.png", replace		

twoway  kdensity log_asmr_sex_drug_st if sex == 2, color(green) || ///
		kdensity log_asmr_sex_drug_st if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Logged Drug Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Drug_log_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Drug_log_dist_10-28-2020.png", replace	

twoway  kdensity log_asmr_sex_opioid_st if sex == 2, color(green) || ///
		kdensity log_asmr_sex_opioid_st if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Logged Opioid Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Opioid_log_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Opioid_log_dist_10-28-2020.png", replace


twoway  kdensity asmr_sex_opioid_state_pred	 if sex == 2, color(green) || ///
		kdensity asmr_sex_opioid_state_pred if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Opioid Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Opioidpr_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Opioidpr_dist_10-28-2020.png", replace			
		
twoway  kdensity log_asmr_sex_opioid_state_pred if sex == 2, color(green) || ///
		kdensity log_asmr_sex_opioid_state_pred if sex == 1, color(navy)  ///
		lpattern(dash) legend(order(1 "Female" 2 "Male" )) ///
		ytitle("Density") xtitle("Logged Opioid Mortality Rate") ///
		saving("V:\seltzer\mortality\graphs\Fig_Opioidpr_log_dist_10-28-2020.gph", replace)
		graph export "V:\seltzer\mortality\graphs\Fig_Opioidpr_log_dist_10-28-2020.png", replace