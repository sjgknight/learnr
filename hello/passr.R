## ----passr, message=FALSE, warning=FALSE, include=FALSE-----------------------
#this file gets included/sourced/child rmd into each learnr Rmd. It means I can update how things get submitted on all tutorials without needing to manually edit them all.

#see passr project file for ideas for other ways to do this (email, gdrive distrib, etc.)

library(learnrhash)


## ----context="server"---------------------------------------------------------

learnrhash::encoder_logic()
learnrhash::decoder_logic()
#learnSTATS::encoder_logic()


## ----encode, echo=FALSE-------------------------------------------------------
learnrhash::encoder_ui()


## ----submit_ui, echo=F--------------------------------------------------------
learnrhash::decoder_ui()

