# Project: Vocatives
# Authors: Marton Soskuthy & Timo Roettger
# Part ##: Merging Glottolog data with raw data
# Date: 06/17/2019
# contacts: timo.b.roettger@gmail.com
#           marton.soskuthy@ubc.ca

library(rstudioapi)
library(tidyverse)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
setwd("../derived_data/")

# read in collection of glottolog and WALS
lang <- read_tsv("Glottolog_complete.csv")

# reduce to relevant columns
lang <- lang %>% 
  rename(Language = name) %>% 
  select(Language, latitude, longitude, family)

# load in rows that are not in "lang"
lang_add <- read_csv("Glottolog_complete_add_on.csv")

# join both tables
lang <- full_join(lang, lang_add)

# read in vocative table
setwd("../raw_data/")
voc <- read_csv("Vocatives_glottolog.csv")

# preprocess 
voc <- voc %>% 
  select(Language, Case) %>% 
  rename(Old = Language) %>% 
  mutate(Language = Old) 

# change language names accordingly
voc[voc$Language == "Alaaba",]$Language <- "Alaba-K'abeena"
voc[voc$Language == "Boraana Oromo",]$Language <- "Borana-Arsi-Guji Oromo"
voc[voc$Language == "Cantonese",]$Language <- "Yue Chinese"
voc[voc$Language == "Chagatay",]$Language <- "Northern Uzbek"
voc[voc$Language == "Chuckchi",]$Language <- "Chukchi"
voc[voc$Language == "Classical Arabic",]$Language <- "Standard Arabic"
voc[voc$Language == "Eastern Burushaski",]$Language <- "Burushaski"
voc[voc$Language == "Hualapai",]$Language <- "Havasupai-Walapai-Yavapai"
voc[voc$Language == "Hup",]$Language <- "Hupdë"
voc[voc$Language == "Karo",]$Language <- "Karo (Brazil)"
voc[voc$Language == "Khalkha Mongolian",]$Language <- "Mongol (Khamnigan)"
voc[voc$Language == "Kulung",]$Language <- "Kulung (Nepal)"
voc[voc$Language == "Lezgian",]$Language <- "Lezghian"
voc[voc$Language == "Mani",]$Language <- "Bullom So"
voc[voc$Language == "Meithei",]$Language <- "Manipuri"
voc[voc$Language == "Mongsen Ao",]$Language <- "Ao Naga"
voc[voc$Language == "Murui",]$Language <- "Murui Huitoto"
voc[voc$Language == "Nishnaabemwin (Ottawa)",]$Language <- "Ottawa"
voc[voc$Language == "Palula",]$Language <- "Phalura"
voc[voc$Language == "Rapa Nui",]$Language <- "Rapanui"
voc[voc$Language == "Salako (Kendayan)",]$Language <- "Kendayan"
voc[voc$Language == "Sierra Popoluca",]$Language <- "Highland Popoluca"
voc[voc$Language == "Toqabaqita",]$Language <- "To'abaita"
voc[voc$Language == "Tukang Besi",]$Language <- "Tukang Besi North"
voc[voc$Language == "Wampis",]$Language <- "Huambisa"
voc[voc$Language == "Nuxalk",]$Language <- "Bella Coola"
voc[voc$Language == "rGyalrong, Jiaomuzu",]$Language <- "rGyalrong (Caodeng)"
voc[voc$Language == "Yintyingka",]$Language <- "Yintyinka-Ayabadhu"
voc[voc$Language == "Yup'ik",]$Language <- "Yup'ik (Central)"
voc[voc$Language == "Witsuwit'en",]$Language <- "Babine"
voc[voc$Language == "West Greenlandic",]$Language <- "Kalaallisut"
voc[voc$Language == "Miami-Illinois",]$Language <- "Illinois"
voc[voc$Language == "Chiapas Zoque",]$Language <- "Zoque (Copainalá)"
voc[voc$Language == "Nahuatl",]$Language <- "Nahuatl (Central)"
voc[voc$Language == "Eton",]$Language <- "Eton-Mengisa"
voc[voc$Language == "Khwe",]$Language <- "Kxoe"
voc[voc$Language == "Nkore-Kiga",]$Language <- "Nyankole"
voc[voc$Language == "!Gora",]$Language <- "Korana"

# join voc and lang, add "isolate", drop columns
voc_languages <- full_join(voc, lang) %>% 
  drop_na(Case) %>% 
  mutate(family1 = ifelse(is.na(family), Language, family),
         family2 = ifelse(is.na(family), "isolate", family)) %>% 
  select(-Case, -family) %>% 
  rename(language = Old,
         new_language = Language) %>% 
  distinct()

# write to csv
setwd("../derived_data/")
write.csv(voc_languages, file = "voc_languages.csv", row.names = FALSE)


