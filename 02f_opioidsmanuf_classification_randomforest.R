## "The Economic Underpinnings of the Drug Epidemic" - Nathan Seltzer
## DOI: https://doi.org/10.1016/j.ssmph.2020.100679

## Title: Corrected Random Forest Logit Predictions
## File: 02f_opioidsmanuf_classification_randomforest.R
## Description: Creates Random Forest program to predict unspecified opioid-related
##  drug deaths


library(randomForest)



opioidmodel.rf <- function(df, yr) {
  
  # df <- unk
  # yr = 1999
  
  data <- filter(df, year == yr & unclassified.classification != 1)
  
  # data <- unk2016
  # data <- NULL
  
  smp_size <- floor(0.80 * nrow(data))
  
  ## set the seed to make your partition reproducible
  set.seed(151)
  train_ind <- sample(seq_len(nrow(data)), size = smp_size)
  
  train <- data[train_ind, ]
  test <- data[-train_ind, ]
  
  
  
  train$opioid.death <- factor(train$opioid.death)
  rfmodel <- randomForest(opioid.death ~ agecat + race_r + sex + hisp + marstat + weekday + monthdth + placdth + state_fips , 
                    data = train, 
                    na.action = na.omit,
                    ntree = 1000)
  summary(rfmodel)
  rfmodel
  
  train$prob.train <- rfmodel %>%
    predict(train, type = "response")
  
  train$pred.train <- as.numeric(as.character(train$prob.train))
  
  test$prob.test <- rfmodel %>%
    predict(test, type = "response")
  
  test$pred.test <- as.numeric(as.character(test$prob.test))
  
  
  library(caret)
  confusionMatrix(factor(train$opioid.death), factor(train$pred.train))
  confusionMatrix(factor(test$opioid.death), factor(test$pred.test))
  
  ##get accuracy
  
  cm_train <- table(train$opioid.death, train$pred.train)
  
  acc_train <- (cm_train[1,1] + cm_train[2,2] )/ (cm_train[1,1] + cm_train[2,2] + cm_train[1,2] + cm_train[2,1] )
  
  
  
  cm_test <- table(test$opioid.death, test$pred.test)
  
  acc_test <- (cm_test[1,1] + cm_test[2,2] )/ (cm_test[1,1] + cm_test[2,2] + cm_test[1,2] + cm_test[2,1] )
  
  ## predict deaths of unclassified
  
  corrected_data <- filter(df, year == yr)
  
  corrected_data$prob <- rfmodel %>%
    predict(corrected_data, type = "response")
  
  corrected_data$pred <- as.numeric(corrected_data$prob)
  
  corrected_data$prob_mix = ifelse(corrected_data$unclassified.classification == 1, corrected_data$prob, corrected_data$opioid.death)
  corrected_data$pred_mix = ifelse(corrected_data$unclassified.classification == 1, corrected_data$pred, corrected_data$opioid.death)
  
  
  ##total deaths
  
  total <- summarize(corrected_data, 
                     alldrug = sum(death),
                     opioid = sum(opioid.death),
                     opioid_plus_predicted = sum(pred_mix, na.rm = TRUE))
  
  
  elements <- list(train, test, rfmodel, cm_train, acc_train, cm_test, acc_test, corrected_data, total)
  
  # 1. train dataset
  # 2. test dataset
  # 3. logit model
  # 4. confusion matrix train
  # 5. predicted accuracy train
  # 6. confusion matrix test
  # 7. predicted accuracy train
  # 8. corrected dataset with predictions
  # 9. totals
  
  return(elements)
  
}


pred.rf_1999	<- opioidmodel.rf(unk, 	1999	)
pred.rf_2000	<- opioidmodel.rf(unk, 	2000	)
pred.rf_2001	<- opioidmodel.rf(unk, 	2001	)
pred.rf_2002	<- opioidmodel.rf(unk, 	2002	)
pred.rf_2003	<- opioidmodel.rf(unk, 	2003	)
pred.rf_2004	<- opioidmodel.rf(unk, 	2004	)
pred.rf_2005	<- opioidmodel.rf(unk, 	2005	)
pred.rf_2006	<- opioidmodel.rf(unk, 	2006	)
pred.rf_2007	<- opioidmodel.rf(unk, 	2007	)
pred.rf_2008	<- opioidmodel.rf(unk, 	2008	)
pred.rf_2009	<- opioidmodel.rf(unk, 	2009	)
pred.rf_2010	<- opioidmodel.rf(unk, 	2010	)
pred.rf_2011	<- opioidmodel.rf(unk, 	2011	)
pred.rf_2012	<- opioidmodel.rf(unk, 	2012	)
pred.rf_2013	<- opioidmodel.rf(unk, 	2013	)
pred.rf_2014	<- opioidmodel.rf(unk, 	2014	)
pred.rf_2015	<- opioidmodel.rf(unk, 	2015	)
pred.rf_2016	<- opioidmodel.rf(unk, 	2016	)
pred.rf_2017	<- opioidmodel.rf(unk, 	2017	)






c <- data.frame(
  year = 1999:2017,
  test_acc =c (pred.rf_1999[[7]],
               pred.rf_2000[[7]],
               pred.rf_2001[[7]],
               pred.rf_2002[[7]],
               pred.rf_2003[[7]],
               pred.rf_2004[[7]],
               pred.rf_2005[[7]],
               pred.rf_2006[[7]],
               pred.rf_2007[[7]],
               pred.rf_2008[[7]],
               pred.rf_2009[[7]],
               pred.rf_2010[[7]],
               pred.rf_2011[[7]],
               pred.rf_2012[[7]],
               pred.rf_2013[[7]],
               pred.rf_2014[[7]],
               pred.rf_2015[[7]],
               pred.rf_2016[[7]],
               pred.rf_2017[[7]]),
  train_acc =c (pred.rf_1999[[5]],
                pred.rf_2000[[5]],
                pred.rf_2001[[5]],
                pred.rf_2002[[5]],
                pred.rf_2003[[5]],
                pred.rf_2004[[5]],
                pred.rf_2005[[5]],
                pred.rf_2006[[5]],
                pred.rf_2007[[5]],
                pred.rf_2008[[5]],
                pred.rf_2009[[5]],
                pred.rf_2010[[5]],
                pred.rf_2011[[5]],
                pred.rf_2012[[5]],
                pred.rf_2013[[5]],
                pred.rf_2014[[5]],
                pred.rf_2015[[5]],
                pred.rf_2016[[5]],
                pred.rf_2017[[5]]),
  alldrug   =c (pred.rf_1999[[9]][[1]],
                pred.rf_2000[[9]][[1]],
                pred.rf_2001[[9]][[1]],
                pred.rf_2002[[9]][[1]],
                pred.rf_2003[[9]][[1]],
                pred.rf_2004[[9]][[1]],
                pred.rf_2005[[9]][[1]],
                pred.rf_2006[[9]][[1]],
                pred.rf_2007[[9]][[1]],
                pred.rf_2008[[9]][[1]],
                pred.rf_2009[[9]][[1]],
                pred.rf_2010[[9]][[1]],
                pred.rf_2011[[9]][[1]],
                pred.rf_2012[[9]][[1]],
                pred.rf_2013[[9]][[1]],
                pred.rf_2014[[9]][[1]],
                pred.rf_2015[[9]][[1]],
                pred.rf_2016[[9]][[1]],
                pred.rf_2017[[9]][[1]]),
  opioid   =c (pred.rf_1999[[9]][[2]],
               pred.rf_2000[[9]][[2]],
               pred.rf_2001[[9]][[2]],
               pred.rf_2002[[9]][[2]],
               pred.rf_2003[[9]][[2]],
               pred.rf_2004[[9]][[2]],
               pred.rf_2005[[9]][[2]],
               pred.rf_2006[[9]][[2]],
               pred.rf_2007[[9]][[2]],
               pred.rf_2008[[9]][[2]],
               pred.rf_2009[[9]][[2]],
               pred.rf_2010[[9]][[2]],
               pred.rf_2011[[9]][[2]],
               pred.rf_2012[[9]][[2]],
               pred.rf_2013[[9]][[2]],
               pred.rf_2014[[9]][[2]],
               pred.rf_2015[[9]][[2]],
               pred.rf_2016[[9]][[2]],
               pred.rf_2017[[9]][[2]]),  
  opioid_plus_predicted   =c (pred.rf_1999[[9]][[3]],
                              pred.rf_2000[[9]][[3]],
                              pred.rf_2001[[9]][[3]],
                              pred.rf_2002[[9]][[3]],
                              pred.rf_2003[[9]][[3]],
                              pred.rf_2004[[9]][[3]],
                              pred.rf_2005[[9]][[3]],
                              pred.rf_2006[[9]][[3]],
                              pred.rf_2007[[9]][[3]],
                              pred.rf_2008[[9]][[3]],
                              pred.rf_2009[[9]][[3]],
                              pred.rf_2010[[9]][[3]],
                              pred.rf_2011[[9]][[3]],
                              pred.rf_2012[[9]][[3]],
                              pred.rf_2013[[9]][[3]],
                              pred.rf_2014[[9]][[3]],
                              pred.rf_2015[[9]][[3]],
                              pred.rf_2016[[9]][[3]],
                              pred.rf_2017[[9]][[3]]))



library(viridis)
library(scico)
library(ggthemes)


ggplot(c, aes(x = year, y = test_acc)) +
  geom_point(size = 1.25) +
  geom_smooth(se = FALSE, size = 1.25, color = "dodgerblue3") +
  geom_point(size = 1.25, color = "black") +
  scale_y_continuous(breaks=seq(.65,.8,.5)) +
  ylim(.61,.809) +
  theme_tufte() +
  xlab("Year") +
  ylab("Predictive Accuracy Rate") 
ggsave(device = "png", 
       filename = "V:/seltzer/mortality/output/PredictiveAccuracy_RF.png",
       width = 5,
       height = 5,
       dpi = 700)


c2 <- gather(c, "measure", "value", 2:6) %>%
  filter(measure %in% c("alldrug", "opioid", "opioid_plus_predicted"))



c2$measure <- factor(c2$measure , levels = c("alldrug","opioid_plus_predicted","opioid"),
                     labels = c("Total Drug Overdoses", 
                                "Specified Opioid Overdoses + Predicted Opioid Overdoses", 
                                "Specified Opioid Overdoses"))

ggplot(c2, aes(x = year, y = value, group(measure))) + 
  geom_point(aes(color = measure), size = 1.25) +
  geom_smooth(aes(color =measure), se = FALSE, size = 1.25) +
  scale_y_continuous(labels = scales::comma) +
  theme_tufte()  +
  xlab("Year") +
  ylab("Number of Deaths") +
  scale_colour_manual(values = c("gray5", "gray45", "gray80")) + 
  theme(legend.position=c(.4,.75),
        legend.title=element_blank())
ggsave(device = "png", 
       filename = "V:/seltzer/mortality/output/Predicted_Opioid_Deaths_RF.png",
       width = 5,
       height = 5,
       dpi = 700)

########

b$Model <- "Logit"
c$Model <- "Random Forest"
d <- bind_rows(b, c)

d$Model <- factor(d$Model)

ggplot(d, aes(x = year, y = test_acc, color = Model)) +
  geom_point(size = 1.25) +
  geom_smooth(se = FALSE, size = 1.25) +
  geom_point(size = 1.25) +
  scale_y_continuous(breaks=seq(.65,.8,.5)) +
  scale_colour_manual(values = c("#CC6677", "#888888")) + 
  ylim(.61,.809) +
  theme_tufte() +
  theme(legend.position=c(.2,.75)) + 
  xlab("Year") +
  ylab("Predictive Accuracy Rate") 
ggsave(device = "png", 
       filename = "V:/seltzer/mortality/output/PredictiveAccuracy_RFvsLogit.png",
       width = 5,
       height = 5,
       dpi = 700)
