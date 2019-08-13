# When the tune shapes morphology - the origins of vocatives

An investigation of whether vocative markers are more tune-friendly than comparable case markers.

### Prerequisites

What things you need to install the software and how to install them

```
## define package list
packages <- c("readbulk",
              "rstudioapi",
	      "tidyverse",
              "brms",
              "ggbeeswarm",
              "maps")

## install packages (don't run)
install.packages(packages)

```

### Content

#### raw_data
Contains the data table generated when collecting the corpus:
  * `vocatives_glottolog.csv`(-> redundant)
  * `vocatives.csv` 
  The raw corpus.
  
#### derived_data
Contains all data derived by `01_merge_glottolog.R` and `vocative_variable.Rmd`
  * `vocatives_processed.csv`
  Contains cleaned up raw-corpus for further modelling and plotting. Derived by `02_vocatives_variables.Rmd`
  	- **language**: 	language name
	- **case**: 		concrete case with a variety of structural case descriptions
	- **default**: 		logical, ???
	- **morphological**:	the nature of the marker incl. affix, clitic, particle, or phonological modulation including deletion, prosodic or no if not applicable to above categories
	- **noun_type**: 	type of noun, if a restriction exists (e.g. vocatives are often restricted to kinship terms)
	- **noun_class**:	noun class, if a restriction exists
	- **number**:		grammatical number, if a restriction exists
	- **conditioning**:	phonological conditioning, if a restriction exists
	- **form**:		the  phonological form of the alternation as originally noted when looking at the grammars
	- **form_add**:		a tidied version of the form column that contains only forms that are added to the segmental string (position is indicated by the hyphen)
	- **form_replace**: 	a tidied version of the form column that contains only forms that are characterized by replacement (rare)
	- **form_delete**: 	a tidied version of the form column that contains only forms that are characterized by deletion (rare)
	- **prosodic_form**:	if prosodic modulation is described,the prosodic form of the alternation as originally noted when looking at the grammars
	- **prosody_clean**: 	logical, notes if row refers to a prosodic modulation
	- **prosody_stress**: 	binary, notes if row refers to a stress shift
	- **prosody_tone**: 	binary, notes if row refers to a lexical tone change
	- **prosody_vowel_lengthening**: 	binary, notes if row refers to a vowel lengthening
	- **case_broad**:	categorizes `case` column into three broad categories: nom-like, acc-like, and vocative
	- **form_add_s**:	????
	- **form_add_prefix**:	the content of `form_add` for only forms that precede the noun
	- **form_add_suffix**: 	the content of `form_add` for only forms that succeed the noun
	- **form_add_all**:	????
	- **vowel_pres**:	logical, does the added form contain a vowel?
	- **cons_pres**:	logical, does the added form contain a consonant?
	- **vowel_end**:	logical, does the added form end in a vowel?
	- **obstr_vl_pres**:	binary, does the added form contain a voiceless consonant?
	- **obstr_vl_count**:	numeric, how many voiceless consonants does the added form contain?
	- **obstr_vl_prop**:	numeric, what is the proportion of voiceless consonants to the overall number of segments of the added form?
	- **last_vowel**:	what is the final vowel of the added form?
	- **last_vowel_qual**:	what is the vowel quality of the last vowel of the added form
	- **v_height**:		what is the vowel height of the last vowel of the added form
	- **v_long**:		logical, does the last vowel occupy two length slots, i.e. is it a long vowel or a diphtongue?
	- **cons_end**:		logical, does the form end in a consonant?
	- **cons_onset**:	logical, does the form have a consonantal onset?
  
  
  * `languages_and_dialects_geo.csv`: 
  Contains information about macroareas and location of languages
  	- **glottocode**: 	glottolog code of language 	
  	- **name**:		language name
  	- **isocodes**:		isocode if available
  	- **level**:		categorization as language or dialect
 	- **macroarea**:	glottolog macroarea categorization into Africa, Australia, Eurasia, North America, Papunesia, South America
  	- **latitude**:		self-explanatory
  	- **longitude**:	self-explanatory
  
  * `voc_languages.csv`	
  
  * `glottolog_complete.csv`
  Contains complementary information about location and macroarea of languages. Relevant columns are: 
  	- **latitude**:		self-explanatory
  	- **longitude**:	self-explanatory
  	- **Language**: 	language name
	- **family**: 		language family according to glottolog
  
  * `glottolog_complete_add_on.csv`
  Contains missing information that are not contained in `glottolog_complete.csv`
 	- **latitude**:		self-explanatory
  	- **longitude**:	self-explanatory
  	- **Language**: 	language name
	- **family**: 		language family according to glottolog
  
TO DO: code book for new variables

#### scripts 
Contains all scripts numbered according to its usage:
* `00_packages.R` installs all relevant packages and snapshots it with packrat
* `00_packratRestore.R` can be executed by the user to restore the libary required for the scripts
* `01_vocatives_variables.Rmd` cleans up raw data and preprocess it for further modelling and plotting
* `02_merge_glottolog` merges raw data and several files containing information about location, family and macroareas.
* `0#_vocatives-models.Rmd` runs all relevant Bayesian models and stores model outputs in `models`.
* `0#_vocatives_plots.Rmd` takes model outputs and creates plots, stored in `plots`
  
#### plots  
Contains all plots generated by `0#_vocatives_plots.Rmd` in `png` and `pdf`

#### model
Contains all model objects generated in `0#_vocatives-models.Rmd`
