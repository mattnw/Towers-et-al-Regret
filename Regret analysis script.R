####Licences

  #Data
    #The datasets complete_data.csv and reliability_data.csv are made available 
    #under the Open Data Commons Attribution License: 
    #http://opendatacommons.org/licenses/by/1.0.

  #Script
    #The analysis script 'Regret analysis script.R' is made available under the GNU General Public License: 
    #https://cran.r-project.org/web/licenses/GPL-3
    #This script is free software: you can redistribute it and/or modify
    #it under the terms of the GNU General Public License as published by
    #the Free Software Foundation, either version 3 of the License, or
    #(at your option) any later version.

    #This script is distributed in the hope that it will be useful,
    #but WITHOUT ANY WARRANTY; without even the implied warranty of
    #MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    #GNU General Public License for more details.


####Necessary packages

  require(MCMCpack)
  require(psych)


####Reading in the data
  
  complete_data = read.csv("complete_data.csv")
  
  #for convenience, a version of the imputed data without the original data appended
  complete_imp = complete_data[complete_data$.imp != 0,] 

####Descriptive statistics

  #Descriptive statistics for continuous variables
  range(complete_imp$LTRintensity)
  mean(complete_imp$LTRintensity)
  sd(complete_imp$LTRintensity)
  mean(complete_imp$LTRyears)
  sd(complete_imp$LTRyears)
  mean(complete_imp$LTRjustification)
  sd(complete_imp$LTRjustification)
  
  #Proportions for dichotomous data
  table(complete_imp$Social)/nrow(complete_imp) 
  table(complete_imp$LTRrules)/nrow(complete_imp)
  table(complete_imp$Action)/nrow(complete_imp)

####Bivariate analyses
  
  #Preliminary helper functions
  
    #A function to calculate Cohen's d on the basis of two vectors; note direction of x1-x2
    Cohens.D = function(x1, x2){
      (mean(x1)-mean(x2))/(sqrt((var(x1)*(length(x1)-1)+var(x2)*(length(x2)-1))/(length(x1) + length(x2) - 2)))}
    
    #A function to get a list of mcmc objects by fitting a model to each of the five datasets in complete_imp
    #Arguments are formula and prior on variances
    mcmc.on.miss = function(formula, prior){
      list = mcmc.list(
        MCMCregress(formula, data = complete_imp[complete_imp$.imp == 1,],
                    B0 = prior),
        MCMCregress(formula, data = complete_imp[complete_imp$.imp == 2,],
                    B0 = prior),
        MCMCregress(formula, data = complete_imp[complete_imp$.imp == 3,],
                    B0 = prior),
        MCMCregress(formula, data = complete_imp[complete_imp$.imp == 4,],
                    B0 = prior),
        MCMCregress(formula, data = complete_imp[complete_imp$.imp == 5,],
                    B0 = prior))
      as.mcmc(do.call(rbind,list))
    }
  
    
  #Mean differences on regret intensity according to dichotomous variables
    
    #Mean regret intensity by action/inaction, mean difference, sds, subsample n's, Cohen's d
    aggregate(complete_imp$LTRintensity, by = list(complete_imp$Action), FUN = mean)
    mean(complete_imp[complete_imp$Action == 1,"LTRintensity"])- mean(complete_imp[complete_imp$Action == 0,"LTRintensity"])
    aggregate(complete_imp$LTRintensity, by = list(complete_imp$Action), FUN = sd) #sd's
    table(complete_imp$Action)/5 #n for action/inaction. Note that this variable is partly imputed, so real rather than integer
    Cohens.D(complete_imp[complete_imp$Action == 0 & complete_imp$.imp != 0,]$LTRintensity, 
             complete_imp[complete_imp$Action == 1 & complete_imp$.imp != 0,]$LTRintensity)
    
    #Inferential analysis
    
      #Priors
      B0a = matrix(c(0, 0, 0, 1/(0.31/(sd(as.numeric(complete_imp$Action))/sd(complete_imp$LTRintensity)))^2), nrow = 2)
      #Prior placed on standardised effect (SD = 0.31), but re-parameterised to deal with following issues:
      #Prior needs to be placed on precision matrix, not variance matrix
      #Effects in model itself actually measured in unstandardised form
      
      #Bayesian model
      mcmcact = mcmc.on.miss(formula = 'LTRintensity ~ Action', prior = B0a)
      summary(mcmcact) 
      HPDinterval(mcmcact)
      sum(mcmcact[,2]>0)/nrow(mcmcact) #posterior probability effect positive
  
    #Mean regret intensity by social/nonsocial,  mean difference, sds, subsample n's, Cohen's d
    aggregate(complete_imp$LTRintensity, by = list(complete_imp$Social), FUN = mean) 
    mean(complete_imp[complete_imp$Social == 1,"LTRintensity"])- mean(complete_imp[complete_imp$Social == 0,"LTRintensity"])
    aggregate(complete_imp$LTRintensity, by = list(complete_imp$Social), FUN = sd) #sd's
    table(complete_imp$Social)/5 #n for social/nonsocial
    Cohens.D(complete_imp[complete_imp$Social == 0 & complete_imp$.imp != 0,]$LTRintensity, 
             complete_imp[complete_imp$Social == 1 & complete_imp$.imp != 0,]$LTRintensity)
  
    #Inferential analysis
  
      #Priors
      B0s = matrix(c(0, 0, 0, 1/(0.31/(sd(as.numeric(complete_imp$Social))/sd(complete_imp$LTRintensity)))^2), nrow = 2)
      
      #Modelling
      mcmcsoc = mcmc.on.miss(formula = 'LTRintensity ~ Social', prior = B0s)
      summary(mcmcsoc); HPDinterval(mcmcsoc)
      sum(mcmcsoc[,2]>0)/nrow(mcmcsoc) #Posterior probability effect positive
  
      #Mean regret intensity by life rules breached yes/no,  mean difference, sds, subsample n's, Cohen's d
      aggregate(complete_imp$LTRintensity, by = list(complete_imp$LTRrules), FUN = mean) #means
      mean(complete_imp[complete_imp$LTRrules == 1,"LTRintensity"])-mean(complete_imp[complete_imp$LTRrules == 0,"LTRintensity"])
      aggregate(complete_imp$LTRintensity, by = list(complete_imp$LTRrules), FUN = sd) #sd's
      table(complete_imp$LTRrules)/5 #n
      Cohens.D(complete_imp[complete_imp$LTRrules == 0 & complete_imp$.imp != 0,]$LTRintensity, 
               complete_imp[complete_imp$LTRrules == 1 & complete_imp$.imp != 0,]$LTRintensity)
      
      #Inferential analysis
      
        #Priors
        B0r = matrix(c(0, 0, 0, 1/(0.31/(sd(as.numeric(complete_imp$LTRrules))/sd(complete_imp$LTRintensity)))^2), nrow = 2)
        
        #Bayesian modelling
        mcmcrul = mcmc.on.miss(formula = 'LTRintensity ~ LTRrules', prior = B0r)
        summary(mcmcrul) 
        HPDinterval(mcmcrul)
        sum(mcmcrul[,2]>0)/nrow(mcmcrul) #posterior probability effect positive
  
  #Correlations between continuous variables
  
    #Correlations with credible intervals using Bayesian analysis for justification and regret intensity
    B0c =  B0r = matrix(c(0, 0, 0, 1/0.31^2), nrow = 2) #Prior - no need to translate to unstandardised metric now
    justr = mcmc.on.miss(formula = 'scale(LTRintensity) ~ scale(LTRjustification)', prior = B0c)
    summary(justr); HPDinterval(justr)
    sum(justr[,2]<0)/nrow(justr)
    
    #Correlations with credible intervals using Bayesian analysis for time since regret and regret Intensity
    yearsr= mcmc.on.miss(formula = 'scale(LTRintensity) ~ scale(LTRyears)', prior = B0c)
    summary(yearsr); HPDinterval(yearsr)
    sum(yearsr[,2]>0)/nrow(yearsr)
    
####Multiple regression analysis
    
    #Place an informative prior on effect size: M = 0, SD = 0.31 on standardised effect size,
    #re-parameterised to apply on unstandardised scale
    B0mod = diag(c(0, 
                   1/(0.31/(sd(complete_imp$Action)/sd(complete_imp$LTRintensity)))^2,
                   1/(0.31/(sd(complete_imp$LTRyears)/sd(complete_imp$LTRintensity)))^2,
                   1/(0.31/(sd(complete_imp$LTRjustification)/sd(complete_imp$LTRintensity)))^2,
                   1/(0.31/(sd(complete_imp$LTRrules)/sd(complete_imp$LTRintensity)))^2,
                   1/(0.31/(sd(complete_imp$Social)/sd(complete_imp$LTRintensity)))^2,
                   1/(0.31/(sd(complete_imp$Action*complete_imp$LTRyears)/sd(complete_imp$LTRintensity)))^2
    ))
    
    #Run the Bayesian model
    Bmod = mcmc.on.miss(formula = 'LTRintensity ~ Action + LTRyears +  Action*LTRyears + LTRjustification +
                        LTRrules + Social',
                        prior = B0mod)
    summary(Bmod); HPDinterval(Bmod) 
    
    
    
    #Standardised coefficients
    XSDvector = c(NA, sapply(X = complete_imp[, c("Action", "LTRyears",  "LTRjustification", "LTRrules", "Social", "ActionxYear")]
                             , FUN = sd))
    YSD = sd(complete_imp$LTRintensity)
    std.coefs = summary(Bmod)$statistics[-8,1]*(XSDvector/YSD)
    
    #Probability that each effect positive?
    countpos = function(X){sum(X>0)}
    apply(Bmod, 2, countpos)/nrow(Bmod)
    
  
####Post-review request: Interrater reliability
    
    rel_data = read.csv("reliability_data.csv")
    #Check README.md for variables names and codings, which are fairly self-explanatory
    #Note participant 40 is not in the individual codings files due to just saying "No regrets".
    #And therefore N here = 499 rather than 500
    
    #Check interrater reliability for action/inaction
    rel_data$agree_action = rel_data$Coder1_Action == rel_data$Coder2_Action
    sum(rel_data$agree_action, na.rm = TRUE)/nrow(rel_data) #90% agreement
    cohen.kappa(rel_data[,c("Coder1_Action", "Coder2_Action")]) #kappa
    
    #Check interrater reliability for social/not
    rel_data$agree_social = rel_data$Coder3_Social == rel_data$Coder4_Social
    sum(rel_data$agree_social, na.rm = TRUE)/nrow(rel_data) #83% agreement
    cohen.kappa(rel_data[,c("Coder3_Social", "Coder4_Social")]) #kappa
    
    