# Project: Vocatives
# Authors: Marton Soskuthy & Timo Roettger
# Part 02: session_info
# Date: 06/17/2019
# contacts: timo.b.roettger@gmail.com
#           marton.soskuthy@ubc.ca

# set working directory
# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
setwd("../derived_data/") 

# extract session info and store as .txt file
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
