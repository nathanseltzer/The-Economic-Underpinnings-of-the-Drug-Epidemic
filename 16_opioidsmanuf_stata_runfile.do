** "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
** Stata PRG RunFile
** 26_opioidsmanuf_stata_runfile

log using "V:/seltzer/mortality/output/log/opioidsmanuf_stata_models.smcl", replace


cd "V:/seltzer/mortality/prg"


clear all
macro drop _all

do "V:/seltzer/mortality/prg/17_opioidsmanuf_state_prep.do"
do "V:/seltzer/mortality/prg/18_opioidsmanuf_state_mainmodels.do"
do "V:/seltzer/mortality/prg/19_opioidsmanuf_state_racesexagemodels.do"
do "V:/seltzer/mortality/prg/20_opioidsmanuf_state_rx_robustnessmodels.do"
do "V:/seltzer/mortality/prg/21_opioidsmanuf_state_additionalrobustness.do"
do "V:/seltzer/mortality/prg/22_opioidsmanuf_state_inpatientemergency.do"
do "V:/seltzer/mortality/prg/23_opioidsmanuf_state_rategraphs.do"
do "V:/seltzer/mortality/prg/24_opioidsmanuf_county_prep.do"
do "V:/seltzer/mortality/prg/25_opioidsmanuf_county_mainmodels.do"
do "V:/seltzer/mortality/prg/26_opioidsmanuf_county_triplicatemodels.do"
	




capture log close

translate "V:/seltzer/mortality/output/log/opioidsmanuf_stata_models.smcl" "V:/seltzer/mortality/output/log/opioidsmanuf_stata_models.pdf", replace

translate "V:/seltzer/mortality/output/log/opioidsmanuf_stata_models.smcl" "V:/seltzer/mortality/output/log/opioidsmanuf_stata_models.log", replace