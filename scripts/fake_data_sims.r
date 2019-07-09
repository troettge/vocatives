library(lme4)
library(arm)
library(rstudioapi)
library(tidyverse)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
setwd("../derived_data/")

# loading vocatives data, merging with lang families data set
v <- read_csv('../data/vocatives_processed.csv')
langs <- read_csv('../derived_data/voc_languages.csv') %>%
  filter(!(language %in% c("Korean","Alaaba")))

v <- full_join(v,langs)
# restricting to vocative / accusative-like
v_acc_voc <- filter(v, case_broad %in% c("vocative","acc-like"))


# ok, so this is somewhat complex, but here's the gist:
# - the simulated data set is of the same size as ours
# - the grouping levels are identical in size & number to the vocatives data
# - cases distributed across families in the same way as in our data
# - simulation parameters:
#   + family intercept sd
#   + family slope over cond sd
#   + case fixed effect slope
#   + model structure (change manually inside for loop)
# - recorded info: 
#   + p values for case fixed effect slope
#   + estimated case fixed effect coefficient
#   + logit(proportion of outcome==1) - logit(proportion of outcome==0) ~ case fixed effect coefficient estimated from raw data
# - + logit(proportion of outcome==1 averaged across language families) - logit(proportion of outcome==0 averaged across language families) ~ case fixed effect coefficient estimated from raw data but pooling within language families

family.intcpt.sd <- 2 # pretty close to the actual models!
family.slope.sd <- 1
case.slope <- 1 # making this a type-II error sim; setting this to 0 gives a type-I error sim

# setting up family ids / cases for fake data
family.ids <- as.numeric(as.factor(v_acc_voc$family1))
cases <- as.numeric(v_acc_voc$case_broad=="vocative")

# very primitive way of recording various estimates from the simulated data
ps <- c() # p-values
betas <- c() # estimated fixed eff slope for case
raw.ms <- c() # slope estimated from raw data
raw.by_family.ms <- c() # slope estimated from raw data + pooling within families

# main loop
for (i in 1:200) {
  # randomly generating by-family intercepts
  family.intercepts <- rnorm(max(family.ids), 0, family.intcpt.sd)[family.ids]
  # randomly generating by-family slopes over case
  family.slopes <- rnorm(max(family.ids), 0, family.slope.sd)[family.ids]
  # calculating outcome logits
  logits <- family.intercepts + cases * (family.slopes + case.slope)
  # calculating outcome probs
  probs <- invlogit(logits)
  
  # setting up empty outcome variable
  outcomes <- rep(0, length(family.ids))
  for (j in 1:length(family.ids)) {
    # randomly generating outcomes using the probs from above (0 / 1)
    outcomes[j] <- sample(c(1,0), 1, prob=c(probs[j], 1-probs[j]), replace=T)
  }
  # assembling data frame
  dat <- data.frame(s=family.ids, case=cases, out=outcomes)
  
  # calculating raw proportions -> transforming to logit scale -> recording in vector
  raw.ms.table <- dat %>%
    group_by(case) %>%
    summarise(prop=mean(out))
  raw.ms <- c(raw.ms, logit(as.vector(raw.ms.table[2,2]))- logit(as.vector(raw.ms.table[1,2])))
  
  # calculating raw proportions by family -> transforming to logit scale -> recording in vector
  raw.by_family.ms.table <- dat %>%
    group_by(s, case) %>%
    summarise(prop=mean(out)) %>%
    ungroup() %>%
    group_by(case) %>%
    summarise(prop=mean(prop))
  raw.by_family.ms <- c(raw.by_family.ms, logit(as.vector(raw.by_family.ms.table[2,2])) - logit(as.vector(raw.by_family.ms.table[1,2])))
  
  # regression models
  m <- glmer(out ~ case + (1 + case | s), data=dat, family="binomial")
  #m <- glm(out ~ case, data=dat, family="binomial")
  
  # extracting p-values / estimates
  ps <- c(ps, summary(m)$coefficients[2,4])
  betas <- c(betas, summary(m)$coefficients[2,1])
}

# some interesting stats
# - p < 0.05?
mean(ps < 0.05)

# - distribution of model estimates
hist(betas)

# - how do model estimates compare to raw estimates?
hist(unlist(raw.ms))
hist(unlist(raw.by_family.ms))
plot(unlist(raw.ms), betas)
plot(unlist(raw.by_family.ms), betas)

# bottomline:
# - appropriately specified mixed effects model gives more accurate estimates of population parameters than raw proportions, even if the latter seem intuitively "more real"
