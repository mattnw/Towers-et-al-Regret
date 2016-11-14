# DESCRIPTION OF REPOSITORY #

This repository contains data and analysis scripts for the article:
"What makes for the most intense regrets? Comparing the effects of several theoretical predictors of regret intensity"
by Towers, Williams, Hill, Philipp and Flett.

# DESCRIPTION OF DATASET 'complete_data.csv' #

The complete_data.csv dataset contains data on the key study variables used in the article.
This dataset does not contain data on all the variables originally collected, nor participants' original qualitative descriptions of their regrets.
It also does not contain data for the demographic variables mentioned in the article (age, gender, ethnicity, education).
These latter variables are excluded on the small chance that these combination of variables could allow individual participants to be identified.

The dataset includes both the original data for the sample of 500 participants described in the article (including some missing data), as well as five multiply imputed databases.
Missing data were imputed based both on the study variables included here as well as the demographic variables mentioned in the article.
Data and scripts for the missing data imputation process is not included here based on the identifiability concern mentioned above.
Instead, the analysis script below shows the substantive analyses conducted in the article.

## Variables and codes used in dataset ##

* .imp			The imputation number of a particular row. 0 = the original dataset; 1-5 = each of the imputed datasets
* .id			The participant id number
* Action			Whether the participant's greatest lifetime regret was an action (1) or an inaction (0)
* LTRintensity		Regret intensity ("How intense are your feelings of regret?") Rating scale with a possible range of 1-9
* LTRjustification	Justification level ("At the time it happened, how justified was the event or decision?") Rating scale with a possible range of 1-5
* LTRrules		Whether the regretted decision breached the participant's life rules. ("Do you feel that the decision you made or event you experienced contradicts any of your personal rules?") 0=No it does not, 1 = Yes it does.
* LTRyears		The number of years since the participant's greatest lifetime regret (recoded from the original collection in months and weeks). 
* Social			Whether the participant's greatest lifetime regret was in a social domain (1) or a non-social domain (0)
* ActionxYear		Interaction term

# DESCRIPTION OF DATASET 'reliability_data.csv' #

This dataset includes codings of the variables Action and Social by four individual coders (two for each variable). Variables:

* Coder1_Action     Whether the regret was one of action (1) or inaction (0) according to coder 1
* Coder2_Action     Whether the regret was one of action (1) or inaction (0) according to coder 2
* Coder3_Social     Whether the regret was in a social domain (1) or a non-social domain (0) according to coder 3
* Coder4_Social     Whether the regret was in a social domain (1) or a non-social domain (0) according to coder 4
  

# DESCRIPTION OF ANALYSIS SCRIPT 'Regret analysis script.R' #

This script contains the major analyses reported in the article (i.e., all those reported in the Results section).
It does not contain the analyses necessary to report the demographic data reported in the method section, for the reasons mentioned above.
It also does not contain the missing data imputation process given that missing data was imputed using demographic information which is excluded here.# Towers-et-al-Regret
