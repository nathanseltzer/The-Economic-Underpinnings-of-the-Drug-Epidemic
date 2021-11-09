## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Runfile
## File:  00_opioidsmanuf_runfile.R
## Description: This file executes all .R prg files

prg <- "V:/seltzer/mortality/prg"


setwd(prg)
source(paste0(prg, "/01_opioidsmanuf_mort_import.R"))
source(paste0(prg, "/02a_opioidsmanuf_mort_ratecreator.R"))
source(paste0(prg, "/02b_opioidsmanuf_mort_ratecreator_racesex.R"))
source(paste0(prg, "/02c_opioidsmanuf_mort_ratecreator_racesexage.R"))
source(paste0(prg, "/02d_opioidsmanuf_classification_import.R"))
source(paste0(prg, "/02e_opioidsmanuf_classification_logit.R"))
source(paste0(prg, "/02f_opioidsmanuf_classification_randomforest.R"))
source(paste0(prg, "/03_opioidsmanuf_mort_bypass.R"))
source(paste0(prg, "/04a_opioidsmanuf_cbp_countydata.R"))
source(paste0(prg, "/04b_opioidsmanuf_cbp_countydata_imputed.R"))
source(paste0(prg, "/05_opioidsmanuf_cbp_msadata.R"))
source(paste0(prg, "/06a_opioidsmanuf_cbp_statedata.R"))
source(paste0(prg, "/06b_opioidsmanuf_cbp_statedata_pre1998.R"))
source(paste0(prg, "/07_opioidsmanuf_cbp_bypass.R"))
source(paste0(prg, "/08_opioidsmanuf_lau.R"))
source(paste0(prg, "/09_opioidsmanuf_pop.R"))
source(paste0(prg, "/10_opioidsmanuf_pop_bypass.R"))
source(paste0(prg, "/11_opioidsmanuf_ahrq.R"))
source(paste0(prg, "/12_opioidsmanuf_cps.R"))
source(paste0(prg, "/13_opioidsmanuf_other.R"))
source(paste0(prg, "/14_opioidsmanuf_ers.R"))


# ## BYPASS
# setwd(prg)
# # source(paste0(prg, "/01_opioidsmanuf_mort_import.R"))
# # source(paste0(prg, "/02a_opioidsmanuf_mort_ratecreator.R"))
# # source(paste0(prg, "/02b_opioidsmanuf_mort_ratecreator_racesex.R"))
# # source(paste0(prg, "/02c_opioidsmanuf_mort_ratecreator_racesexage.R"))
# # source(paste0(prg, "/02d_opioidsmanuf_classification_import.R"))
# # source(paste0(prg, "/02e_opioidsmanuf_classification_logit.R"))
# # source(paste0(prg, "/02f_opioidsmanuf_classification_randomforest.R"))
# source(paste0(prg, "/03_opioidsmanuf_mort_bypass.R"))
# # source(paste0(prg, "/04a_opioidsmanuf_cbp_countydata.R"))
# # source(paste0(prg, "/04b_opioidsmanuf_cbp_countydata_imputed.R"))
# # source(paste0(prg, "/05_opioidsmanuf_cbp_msadata.R"))
# # source(paste0(prg, "/06a_opioidsmanuf_cbp_statedata.R"))
# # source(paste0(prg, "/06b_opioidsmanuf_cbp_statedata_pre1998.R"))
# source(paste0(prg, "/07_opioidsmanuf_cbp_bypass.R"))
# source(paste0(prg, "/08_opioidsmanuf_lau.R"))
# # source(paste0(prg, "/09_opioidsmanuf_pop.R"))
# source(paste0(prg, "/10_opioidsmanuf_pop_bypass.R"))
# source(paste0(prg, "/11_opioidsmanuf_ahrq.R"))
# source(paste0(prg, "/12_opioidsmanuf_cps.R"))
# source(paste0(prg, "/13_opioidsmanuf_other.R"))
# source(paste0(prg, "/14_opioidsmanuf_ers.R"))



source(paste0(prg, "/15_opioidsmanuf_assembledata.R"))
