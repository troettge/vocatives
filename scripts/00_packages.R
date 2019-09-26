# Project: Vocatives
# Authors: Marton Soskuthy & Timo Roettger
# Part 00: Install packages needed for analysis
# Date: 07/27/2019
# contacts: timo.b.roettger@gmail.com
#           marton.soskuthy@ubc.ca

# install and load in packages

## define package list
packages <- c("readbulk",
              "rstudioapi",
	            "tidyverse",
              "brms",
              "ggbeeswarm",
              "maps")

## install packages (don't run)
install.packages(packages)
